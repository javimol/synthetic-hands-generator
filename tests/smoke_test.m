% SMOKE_TEST  Basic checks; run from the repository root:
%   octave --no-gui --eval "run('tests/smoke_test.m')"
addpath(fullfile(fileparts(mfilename('fullpath')), '..', 'src'));

% 1. Every posture in the dictionary renders a plausible hand.
ids = [1:8 11 12 101:104 201:205 301:312 401:427];
for id = ids
    d = renderDepthHand(id);
    assert(isequal(size(d), [144 176]), sprintf('posture %d: wrong size', id));
    assert(isa(d, 'uint8'), sprintf('posture %d: wrong class', id));
    n = nnz(d);
    assert(n > 150 && n < 6000, sprintf('posture %d: %d foreground pixels', id, n));
end
fprintf('ok: %d postures render\n', numel(ids));

% 2. Regression against the stored reference rendering.
ref = imread(fullfile(fileparts(mfilename('fullpath')), 'reference', 'posture005_scale5.png'));
d = renderDepthHand(5, 'Scale', 5);
assert(isequal(d, ref), 'posture 5 at scale 5 differs from tests/reference');
fprintf('ok: regression image matches\n');

% 3. Ball dilation is symmetric and has the expected size.
v = zeros(11, 11, 11); v(6, 6, 6) = 1;
b = dilateBall(v, 2);
assert(nnz(b) == 81, sprintf('ball r=2 has %d voxels', nnz(b)));
assert(isequal(b, flip(b, 1)) && isequal(b, flip(b, 2)) && isequal(b, flip(b, 3)));
fprintf('ok: dilateBall\n');

% 4. make_dataset writes one image and one index row per sample, and the
%    keypoints land on the hand surface.
addpath(fullfile(fileparts(mfilename('fullpath')), '..', 'scripts'));
outDir = tempname();
make_dataset('custom', 'Postures', [5 8], 'FingerPalmRatios', [1 1.2], ...
             'Views', 2, 'ViewRange', [0 pi/8; -pi/8 pi/8; -pi/8 pi/8], 'OutputDir', outDir);
images = dir(fullfile(outDir, '*.png'));
assert(numel(images) == 8, sprintf('%d images instead of 8', numel(images)));
fid = fopen(fullfile(outDir, 'index.csv'));
header = strsplit(fgetl(fid), ',');
assert(numel(header) == 42);
rows = 0;
while true
    l = fgetl(fid);
    if ~ischar(l), break; end
    rows = rows + 1;
    c = strsplit(l, ',');
    if str2double(c{3}) ~= 5, continue; end   % open hand: nothing in front of the joints
    d = imread(fullfile(outDir, c{1}));
    kp = str2double(c(end-8:end));
    for j = 0:2
        gap = double(d(kp(3*j+1), kp(3*j+2))) - kp(3*j+3);
        assert(gap >= 0 && gap <= 4, sprintf('%s: keypoint %d is %d voxels from the surface', c{1}, j, gap));
    end
end
fclose(fid);
assert(rows == 8, sprintf('%d index rows instead of 8', rows));
if exist('OCTAVE_VERSION', 'builtin'), confirm_recursive_rmdir(false, 'local'); end
rmdir(outDir, 's');
fprintf('ok: make_dataset\n');
