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
