#!/usr/bin/env node
/**
 * tools/minify-css.mjs
 *
 * Lossless minification + autoprefixing for site/css/style.css using
 * lightningcss. Writes the minified bytes back over the file at deploy
 * time. Source-control stays human-readable; published CSS is small.
 *
 * Usage:
 *   node tools/minify-css.mjs           # minify in place
 *   node tools/minify-css.mjs --dry-run # report sizes only
 */

import fs from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { transform } from "lightningcss";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.resolve(__dirname, "..");
const CSS_DIR = path.join(ROOT, "site", "css");

const args = new Set(process.argv.slice(2));
const DRY_RUN = args.has("--dry-run");

async function listCss(dir) {
  const out = [];
  try {
    const entries = await fs.readdir(dir, { withFileTypes: true });
    for (const e of entries) {
      const full = path.join(dir, e.name);
      if (e.isDirectory()) out.push(...await listCss(full));
      else if (e.isFile() && e.name.endsWith(".css") && !e.name.endsWith(".min.css")) {
        out.push(full);
      }
    }
  } catch { /* dir may not exist */ }
  return out;
}

(async () => {
  console.log(`▸ minify-css.mjs ${DRY_RUN ? "(dry-run)" : ""}`);
  const files = await listCss(CSS_DIR);
  console.log(`  ${files.length} CSS file(s) to minify.`);

  let totalBefore = 0, totalAfter = 0;
  for (const file of files) {
    const before = await fs.readFile(file);
    totalBefore += before.length;

    let out;
    try {
      const result = transform({
        filename: file,
        code: before,
        minify: true,
        sourceMap: false,
        // Target last 2 versions of major browsers + Edge ≥ 90.
        // lightningcss handles vendor prefixes for these targets automatically.
        targets: {
          chrome: 90 << 16,
          firefox: 90 << 16,
          safari: (14 << 16) | (1 << 8),
          edge: 90 << 16,
        },
      });
      out = result.code;
    } catch (e) {
      console.error(`  ✗ ${path.relative(ROOT, file)} — ${e.message}`);
      continue;
    }

    totalAfter += out.length;
    if (!DRY_RUN) await fs.writeFile(file, out);
    const pct = before.length ? ((1 - out.length / before.length) * 100).toFixed(1) : "0";
    console.log(`  ${path.relative(ROOT, file)}  ${(before.length / 1024).toFixed(1)} KB → ${(out.length / 1024).toFixed(1)} KB  (−${pct}%)`);
  }

  if (files.length > 1) {
    const pct = totalBefore ? ((1 - totalAfter / totalBefore) * 100).toFixed(1) : "0";
    console.log(`  Total: ${(totalBefore / 1024).toFixed(1)} KB → ${(totalAfter / 1024).toFixed(1)} KB  (−${pct}%)`);
  }
  console.log(`✓ done`);
})().catch(e => {
  console.error(e);
  process.exit(1);
});
