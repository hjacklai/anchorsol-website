#!/usr/bin/env node
/**
 * tools/optimise-images.mjs
 *
 * Walks site/assets/images/ and:
 *   1. Re-compresses each JPEG/PNG above THRESH_BYTES at QUALITY_JPEG / QUALITY_PNG
 *   2. Generates a sibling .webp (QUALITY_WEBP) and .avif (QUALITY_AVIF) for each
 *   3. Writes a manifest at site/assets/images/_manifest.json
 *
 * Idempotent — skips files that already have up-to-date siblings.
 *
 * Then, when --rewrite-html is passed, walks site/*.html (one level deep) and
 * rewrites <img src="...{jpg,png}" ...> tags to <picture> with AVIF/WebP sources
 * and the original as <img> fallback.
 *
 * Usage:
 *   node tools/optimise-images.mjs               # generate WebP/AVIF, re-compress
 *   node tools/optimise-images.mjs --rewrite-html # also rewrite HTML to <picture>
 *   node tools/optimise-images.mjs --dry-run     # report only
 */

import fs from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";
import sharp from "sharp";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.resolve(__dirname, "..");
const IMG_DIR = path.join(ROOT, "site", "assets", "images");
const HTML_GLOB = path.join(ROOT, "site");
const MANIFEST = path.join(IMG_DIR, "_manifest.json");

const QUALITY_JPEG = 85;
const QUALITY_PNG = 90;
const QUALITY_WEBP = 80;
const QUALITY_AVIF = 60;
const THRESH_BYTES = 200 * 1024; // skip tiny images
const RECOMPRESS_BYTES = 500 * 1024; // re-compress originals above this
const MAX_WIDTH = 1920;

const args = new Set(process.argv.slice(2));
const DRY_RUN = args.has("--dry-run");
const REWRITE_HTML = args.has("--rewrite-html");

const RX_RASTER = /\.(jpe?g|png)$/i;

async function listImages() {
  const entries = await fs.readdir(IMG_DIR, { withFileTypes: true });
  return entries
    .filter(e => e.isFile() && RX_RASTER.test(e.name) && !e.name.startsWith("_"))
    .map(e => path.join(IMG_DIR, e.name));
}

async function safeStat(p) {
  try { return await fs.stat(p); } catch { return null; }
}

async function processImage(file) {
  const ext = path.extname(file).toLowerCase();
  const base = file.slice(0, -ext.length);
  const isJpeg = ext === ".jpg" || ext === ".jpeg";
  const stat = await safeStat(file);
  if (!stat || stat.size < THRESH_BYTES) return { file, skipped: "too small", size: stat?.size };

  const original = await sharp(file, { failOn: "none" }).rotate();
  const meta = await original.metadata();
  const width = Math.min(meta.width || MAX_WIDTH, MAX_WIDTH);
  const result = { file: path.basename(file), origSize: stat.size };

  // WebP sibling
  const webpPath = `${base}.webp`;
  const webpStat = await safeStat(webpPath);
  if (!webpStat || webpStat.mtimeMs < stat.mtimeMs) {
    if (DRY_RUN) {
      result.webp = "would write";
    } else {
      await sharp(file).rotate().resize({ width, withoutEnlargement: true }).webp({ quality: QUALITY_WEBP, effort: 4 }).toFile(webpPath);
      const newStat = await fs.stat(webpPath);
      result.webp = newStat.size;
    }
  } else {
    result.webp = "up-to-date";
  }

  // AVIF sibling
  const avifPath = `${base}.avif`;
  const avifStat = await safeStat(avifPath);
  if (!avifStat || avifStat.mtimeMs < stat.mtimeMs) {
    if (DRY_RUN) {
      result.avif = "would write";
    } else {
      try {
        await sharp(file).rotate().resize({ width, withoutEnlargement: true }).avif({ quality: QUALITY_AVIF, effort: 4 }).toFile(avifPath);
        const newStat = await fs.stat(avifPath);
        result.avif = newStat.size;
      } catch (e) {
        result.avif = `failed: ${e.message}`;
      }
    }
  } else {
    result.avif = "up-to-date";
  }

  // Re-compress original if oversized
  if (stat.size > RECOMPRESS_BYTES) {
    if (DRY_RUN) {
      result.recompress = "would re-compress";
    } else {
      const tmp = `${file}.tmp`;
      let pipeline = sharp(file).rotate().resize({ width, withoutEnlargement: true });
      pipeline = isJpeg
        ? pipeline.jpeg({ quality: QUALITY_JPEG, mozjpeg: true })
        : pipeline.png({ quality: QUALITY_PNG, compressionLevel: 9 });
      await pipeline.toFile(tmp);
      const newStat = await fs.stat(tmp);
      if (newStat.size < stat.size * 0.95) {
        await fs.rename(tmp, file);
        result.recompress = `${stat.size} → ${newStat.size}`;
      } else {
        await fs.unlink(tmp);
        result.recompress = "no gain — kept original";
      }
    }
  }

  return result;
}

async function rewriteHtml(htmlDir) {
  const entries = await fs.readdir(htmlDir, { withFileTypes: true });
  const files = entries.filter(e => e.isFile() && e.name.endsWith(".html")).map(e => path.join(htmlDir, e.name));
  let touched = 0;
  for (const file of files) {
    const before = await fs.readFile(file, "utf8");
    // Only rewrite raw <img ... src="...{jpg|jpeg|png}" ... /> not already inside <picture>
    const after = before.replace(
      /(<img\b(?![^>]*\bdata-no-picture\b)[^>]*\bsrc="([^"]+\.(?:jpe?g|png))"[^>]*\/>)/g,
      (full, imgTag, src) => {
        if (src.startsWith("http")) return full; // don't rewrite remote
        const base = src.replace(/\.[^.]+$/, "");
        return `<picture><source type="image/avif" srcset="${base}.avif"><source type="image/webp" srcset="${base}.webp">${imgTag}</picture>`;
      }
    );
    if (after !== before) {
      if (!DRY_RUN) await fs.writeFile(file, after, "utf8");
      touched++;
    }
  }
  return touched;
}

(async () => {
  console.log(`▸ optimise-images.mjs ${DRY_RUN ? "(dry-run)" : ""}`);
  console.log(`  IMG_DIR = ${IMG_DIR}`);

  const files = await listImages();
  console.log(`  ${files.length} raster images to consider.`);

  const manifest = { generated: new Date().toISOString(), entries: [] };
  let totalBefore = 0, totalAfter = 0;
  for (const file of files) {
    const r = await processImage(file);
    manifest.entries.push(r);
    if (typeof r.origSize === "number") totalBefore += r.origSize;
    const newOrig = await safeStat(file);
    if (newOrig) totalAfter += newOrig.size;
  }
  if (!DRY_RUN) await fs.writeFile(MANIFEST, JSON.stringify(manifest, null, 2));
  console.log(`  Original total: ${(totalBefore / 1024 / 1024).toFixed(1)} MB`);
  console.log(`  After re-compression: ${(totalAfter / 1024 / 1024).toFixed(1)} MB`);
  console.log(`  Wrote manifest: ${path.relative(ROOT, MANIFEST)}`);

  if (REWRITE_HTML) {
    console.log(`▸ rewriting HTML <img> → <picture>`);
    const touched = await rewriteHtml(HTML_GLOB);
    console.log(`  ${touched} HTML files touched.`);
  }

  console.log(`✓ done`);
})().catch(e => {
  console.error(e);
  process.exit(1);
});
