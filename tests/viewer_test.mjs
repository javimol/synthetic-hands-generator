// Checks that the JavaScript port of the model in viewer/hand-viewer.html renders the
// same depth images as the MATLAB/Octave code. Make the reference first:
//   octave --no-gui --eval "run('tests/export_viewer_reference.m')"
//   node tests/viewer_test.mjs
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const here = path.dirname(fileURLToPath(import.meta.url));
const html = fs.readFileSync(path.join(here, '..', 'viewer', 'hand-viewer.html'), 'utf8');
const ref = fs.readFileSync(path.join(here, 'viewer_reference.txt'), 'utf8');

const code = html.match(/<script id="hand-model">([\s\S]*?)<\/script>/)[1];
const HandModel = new Function('module', `${code}\nreturn HandModel;`)(undefined);
const json = html.match(/<script id="postures"[^>]*>([\s\S]*?)<\/script>/)[1].replace(/\/\*[^*]*\*\//g, '');
const postures = new Map(JSON.parse(json).flatMap(d => d.postures).map(p => [p.id, p.p]));

// keep in sync with tests/export_viewer_reference.m
const cases = [[3, 1, 4, 0, 0, 0], [5, 1.2, 3, Math.PI / 8, -Math.PI / 8, Math.PI / 16],
               [2.5, 0.9, 2, Math.PI / 4, Math.PI / 4, 0]];
const { LX, LY } = HandModel;
let failed = 0, total = 0;
for (const line of ref.trim().split('\n')) {
  const [c, id, data] = line.split(' ');
  const want = data.split(',').filter(Boolean).map(Number);
  const [scale, fp, pw, ...view] = cases[c - 1];
  if (!postures.has(+id)) throw new Error(`posture ${id} is missing from the viewer`);
  const got = HandModel.render(postures.get(+id), { scale, fp, pw, view }).depth;
  let diff = 0;
  for (let i = 0; i < LX; i++) for (let j = 0; j < LY; j++) if (got[i * LY + j] !== want[j * LX + i]) diff++;
  total++;
  if (diff) { failed++; console.log(`case ${c}, posture ${id}: ${diff} pixels differ`); }
}
if (total !== 3 * postures.size) throw new Error(`expected ${3 * postures.size} reference images, got ${total}`);
console.log(failed ? `FAIL: ${failed} of ${total} images differ` : `ok: ${total} viewer images match Octave`);
process.exit(failed ? 1 : 0);
