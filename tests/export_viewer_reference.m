% EXPORT_VIEWER_REFERENCE  Depth images for tests/viewer_test.mjs.
%   Run from the repository root:
%     octave --no-gui --eval "run('tests/export_viewer_reference.m')"
%     node tests/viewer_test.mjs
%   Writes tests/viewer_reference.txt: every posture under three profiles and
%   points of view, one image per line, in column-major order.
here = fileparts(mfilename('fullpath'));
addpath(fullfile(here, '..', 'src'));
ids = [1:8 11 12 101:104 201:205 301:312 401:427];
% scale, FP-AR, PW, view rotation; keep in sync with tests/viewer_test.mjs
cases = {[3 1 4 0 0 0], [5 1.2 3 pi/8 -pi/8 pi/16], [2.5 0.9 2 pi/4 pi/4 0]};
fid = fopen(fullfile(here, 'viewer_reference.txt'), 'w');
for c = 1:numel(cases)
    q = cases{c};
    for id = ids
        d = renderDepthHand(id, 'Scale', q(1), 'FingerPalmRatio', q(2), ...
                            'PalmWidth', q(3), 'Rotation', q(4:6));
        fprintf(fid, '%d %d %s\n', c, id, sprintf('%d,', d(:)));
    end
end
fclose(fid);
fprintf('Wrote %d reference images\n', numel(cases) * numel(ids));
