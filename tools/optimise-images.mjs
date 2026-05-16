#!/usr/bin/env node
/**
 * tools/optimise-images.mjs
 *
 * Walks site/assets/images/ and site/assets/videos/ and:
 *   1. Re-compresses each JPEG/PNG above RECOMPRESS_BYTES at QUALITY_JPEG / QUALITY_PNG
 *      (mozjpeg + 4:4:4 chroma to preserve detail, used for hero assets)
 *   2. Generates a sibling .webp (QUALITY_WEBP) and .avif (QUALITY_AVIF) for each
 *   3. Writes a manifest at site/assets/images/_manifest.json (incl. width/height)
 *
 * Idempotent — skips files that already have up-to-date siblings.
 *
 * Then, when --rewrite-html is passed, walks ALL .html files under site/
 * (recursive) and rewrites <img src="...{jpg,png}" ...> tags to
 *   <picture>
 *     <source type="image/avif" srcset="...">
 *     <source type="image/webp" srcset="...">
 *     <img ... width=W height=H ...>
 *   </picture>
 * — but only when AVIF/WebP siblings actually exist.
 *
 * Usage:
 *   node tools/optimise-images.mjs                # generate WebP/AVIF, re-compress
 *   node tools/optimise-images.mjs --rewrite-html # also rewrite HTML to <picture>
 *   node tools/optimise-images.mjs --dry-run      # report only
 */

import fs from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";
import sharp from "sharp";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.resolve(__dirname, "..");
// Scan multiple asset folders.
const IMG_DIRS = [
  path.join(ROOT, "site", "assets", "images"),
  path.join(ROOT, "site", "assets", "videos"),
];
const IMG_DIR = IMG_DIRS[0]; // primary, for manifest path
const SITE_ROOT = path.join(ROOT, "site");
const MANIFEST = path.join(IMG_DIR, "_manifest.json");

const QUALITY_JPEG = 92;       // visually indistinguishable from source (PSNR ≥ 40 dB)
const QUALITY_PNG = 92;        // higher quality (90 was borderline lossy)
const QUALITY_WEBP = 82;       // sweet spot: ~85% of JPEG quality at ~30% smaller
const QUALITY_AVIF = 65;       // slight bump from 60 for less artifacting
const THRESH_BYTES = 40 * 1024;     // process anything ≥40KB (catches thumbnails)
const RECOMPRESS_BYTES = 600 * 1024; // re-compress originals above this; tuned so
                                     // already-pre-optimised files (q=92/95 4:4:4)
                                     // are skipped on subsequent deploys.
const MAX_WIDTH = 1920;        // cap at 1920 (no upscaling)

const args = new Set(process.argv.slice(2));
const DRY_RUN = args.has("--dry-run");
const REWRITE_HTML = args.has("--rewrite-html");

const RX_RASTER = /\.(jpe?g|png)$/i;

async function listImages() {
  const all = [];
  for (const dir of IMG_DIRS) {
    let entries;
    try {
      entries = await fs.readdir(dir, { withFileTypes: true });
    } catch {
      continue;
    }
    for (const e of entries) {
      if (e.isFile() && RX_RASTER.test(e.name) && !e.name.startsWith("_")) {
        all.push(path.join(dir, e.name));
      }
    }
  }
  return all;
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
  const origWidth = meta.width || 0;
  const origHeight = meta.height || 0;
  const width = Math.min(origWidth || MAX_WIDTH, MAX_WIDTH);
  // Scale height to match if we resize down.
  const heightOut = (origWidth && origHeight)
    ? Math.round(origHeight * (width / origWidth))
    : origHeight;

  const result = {
    file: path.basename(file),
    origSize: stat.size,
    width,
    height: heightOut,
  };

  // WebP sibling
  const webpPath = `${base}.webp`;
  const webpStat = await safeStat(webpPath);
  if (!webpStat || webpStat.mtimeMs < stat.mtimeMs) {
    if (DRY_RUN) {
      result.webp = "would write";
    } else {
      await sharp(file).rotate().resize({ width, withoutEnlargement: true })
        .webp({ quality: QUALITY_WEBP, effort: 5 })
        .toFile(webpPath);
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
        await sharp(file).rotate().resize({ width, withoutEnlargement: true })
          .avif({ quality: QUALITY_AVIF, effort: 4, chromaSubsampling: "4:4:4" })
          .toFile(avifPath);
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
        ? pipeline.jpeg({ quality: QUALITY_JPEG, mozjpeg: true, chromaSubsampling: "4:4:4" })
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

// Recursive HTML walk under site/
async function listHtmlFiles(dir) {
  const out = [];
  const entries = await fs.readdir(dir, { withFileTypes: true });
  for (const e of entries) {
    const full = path.join(dir, e.name);
    if (e.isDirectory()) {
      // Skip node_modules, hidden dirs
      if (e.name.startsWith(".") || e.name === "node_modules") continue;
      out.push(...await listHtmlFiles(full));
    } else if (e.isFile() && e.name.endsWith(".html")) {
      out.push(full);
    }
  }
  return out;
}

// dimension lookup: cached sharp metadata per absolute image path
const dimCache = new Map();
async function getDimensions(absPath) {
  if (dimCache.has(absPath)) return dimCache.get(absPath);
  try {
    const m = await sharp(absPath, { failOn: "none" }).metadata();
    const dim = { width: Math.min(m.width || 0, MAX_WIDTH), height: 0 };
    if (m.width && m.height) {
      dim.height = (dim.width === m.width)
        ? m.height
        : Math.round(m.height * (dim.width / m.width));
    }
    dimCache.set(absPath, dim);
    return dim;
  } catch {
    dimCache.set(absPath, null);
    return null;
  }
}

async function rewriteHtml() {
  const files = await listHtmlFiles(SITE_ROOT);
  let touched = 0;
  let imgsWrapped = 0;
  let imgsSized = 0;

  // Match <img ...> with src ending in jpg/jpeg/png. Tolerates both
  // self-closing <img .../> and HTML5 <img ...>. Skips data-no-picture.
  // Use a non-greedy attribute body so we don't accidentally span tags.
  const RX_IMG = /<img\b(?![^>]*\bdata-no-picture\b)([^>]*?)\bsrc="([^"]+\.(?:jpe?g|png))"([^>]*)>/gi;

  for (const file of files) {
    const before = await fs.readFile(file, "utf8");
    const htmlDir = path.dirname(file);
    let after = "";
    let lastIndex = 0;
    let m;
    // Need a fresh regex per file because we use exec for index tracking.
    const re = new RegExp(RX_IMG.source, RX_IMG.flags);
    while ((m = re.exec(before)) !== null) {
      const [full, attrsBefore, src, attrsAfter] = m;

      // Append the chunk before this match
      after += before.slice(lastIndex, m.index);
      lastIndex = m.index + full.length;

      // Skip http/https or data URIs
      if (/^(https?:|data:)/i.test(src)) {
        after += full;
        continue;
      }

      // Skip if already inside a <picture>. Look back up to 512 chars and
      // check that the most recent <picture is not yet closed by </picture>.
      const lookback = before.slice(Math.max(0, m.index - 512), m.index);
      const lastOpen = lookback.lastIndexOf("<picture");
      const lastClose = lookback.lastIndexOf("</picture>");
      if (lastOpen !== -1 && lastOpen > lastClose) {
        after += full;
        continue;
      }

      // Resolve src relative to this HTML file's directory
      const srcAbs = path.resolve(htmlDir, src);
      const base = srcAbs.slice(0, -path.extname(srcAbs).length);
      const avifAbs = `${base}.avif`;
      const webpAbs = `${base}.webp`;
      const avifExists = await safeStat(avifAbs);
      const webpExists = await safeStat(webpAbs);

      // Sibling URLs share the same relative path as src
      const srcBase = src.replace(/\.[^.]+$/, "");
      const sources = [];
      if (avifExists) sources.push(`<source type="image/avif" srcset="${srcBase}.avif">`);
      if (webpExists) sources.push(`<source type="image/webp" srcset="${srcBase}.webp">`);

      // Build the rewritten <img>: re-emit src + attrs, add width/height if absent
      const hasWidth = /\bwidth\s*=/.test(attrsBefore) || /\bwidth\s*=/.test(attrsAfter);
      const hasHeight = /\bheight\s*=/.test(attrsBefore) || /\bheight\s*=/.test(attrsAfter);
      let sizeAttrs = "";
      if (!hasWidth || !hasHeight) {
        const dim = await getDimensions(srcAbs);
        if (dim && dim.width && dim.height) {
          if (!hasWidth) sizeAttrs += ` width="${dim.width}"`;
          if (!hasHeight) sizeAttrs += ` height="${dim.height}"`;
          imgsSized++;
        }
      }
      const newImg = `<img${attrsBefore}src="${src}"${attrsAfter}${sizeAttrs}>`;

      if (sources.length > 0) {
        after += `<picture>${sources.join("")}${newImg}</picture>`;
        imgsWrapped++;
      } else {
        // No siblings → at least keep the width/height fix
        after += newImg;
      }
    }
    after += before.slice(lastIndex);

    if (after !== before) {
      if (!DRY_RUN) await fs.writeFile(file, after, "utf8");
      touched++;
    }
  }
  return { touched, imgsWrapped, imgsSized };
}

(async () => {
  console.log(`▸ optimise-images.mjs ${DRY_RUN ? "(dry-run)" : ""}`);
  console.log(`  Scanning ${IMG_DIRS.length} directories:`);
  for (const d of IMG_DIRS) console.log(`    - ${path.relative(ROOT, d)}`);

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
    console.log(`▸ rewriting HTML <img> → <picture> (recursive)`);
    const { touched, imgsWrapped, imgsSized } = await rewriteHtml();
    console.log(`  ${touched} HTML files touched, ${imgsWrapped} <img> wrapped, ${imgsSized} sized.`);
  }

  console.log(`✓ done`);
})().catch(e => {
  console.error(e);
  process.exit(1);
});
