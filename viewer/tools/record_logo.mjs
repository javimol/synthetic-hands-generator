// Records docs/img/logo.gif: the pipeline animation of the viewer (hand-viewer.html?logo).
//   npm install --no-save puppeteer-core@23 gifenc@1 pngjs@7
//   node viewer/tools/record_logo.mjs [--id 101] [--size 360] [--frames 100] [--delay 60]
// Uses the Chrome or Chromium in $CHROME (default /usr/bin/google-chrome).
import puppeteer from 'puppeteer-core';
import gifenc from 'gifenc';
import { PNG } from 'pngjs';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const { GIFEncoder, quantize, applyPalette } = gifenc;
const opt = { id: 101, size: 360, frames: 100, delay: 60 };
const argv = process.argv.slice(2);
for (let i = 0; i < argv.length; i += 2) opt[argv[i].replace(/^--/, '')] = +argv[i + 1];

const root = path.join(path.dirname(fileURLToPath(import.meta.url)), '..', '..');
const browser = await puppeteer.launch({
  executablePath: process.env.CHROME || '/usr/bin/google-chrome', headless: 'new',
  args: ['--use-angle=swiftshader', '--enable-unsafe-swiftshader'],
});
const page = await browser.newPage();
page.on('pageerror', e => { throw e; });
await page.setViewport({ width: opt.size, height: opt.size });
const url = `file://${path.join(root, 'viewer', 'hand-viewer.html')}?logo&size=${opt.size}&id=${opt.id}`;
await page.goto(url, { waitUntil: 'networkidle0' });
await page.waitForSelector('body[data-ready="1"]');
await page.evaluate(() => document.fonts.ready);

const frames = [];
for (let i = 0; i < opt.frames; i++) {
  await page.evaluate(t => window.logoFrame(t), i / opt.frames);
  const png = await page.screenshot({ clip: { x: 0, y: 0, width: opt.size, height: opt.size } });
  frames.push(PNG.sync.read(Buffer.from(png)).data);
}
await browser.close();

// one palette for the whole loop, so that colours do not flicker
const sample = [];
for (const f of frames) for (let i = 0; i < f.length; i += 12) sample.push(f[i], f[i + 1], f[i + 2], 255);
const palette = quantize(new Uint8Array(sample), 256);
const gif = GIFEncoder();
for (const f of frames) gif.writeFrame(applyPalette(f, palette), opt.size, opt.size, { palette, delay: opt.delay });
gif.finish();
const out = path.join(root, 'docs', 'img', 'logo.gif');
fs.writeFileSync(out, gif.bytes());
console.log(`Wrote ${out}: ${frames.length} frames, ${(gif.bytes().length / 1024).toFixed(0)} KiB`);
