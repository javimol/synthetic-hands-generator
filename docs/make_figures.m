% MAKE_FIGURES  Render the figures of the README into docs/img.
%   Run from the repository root:
%     octave --no-gui --eval "run('docs/make_figures.m')"
root = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(root, 'src'));
outDir = fullfile(root, 'docs', 'img');
if ~exist(outDir, 'dir'), mkdir(outDir); end
close all;

%% Hand model: joints, segment lengths and degrees of freedom
prof = generateUserProfiles();
p = generateHandParameters(5); p = p{1};          % open hand, frontal
[~, rS] = calculatePoints(p, prof{1});
f = figure('visible', 'off', 'position', [0 0 760 600]);
axes('position', [0 0 1 1]); hold on; axis equal off;
fingers = 'TIMRL';
J = {rS.wrist, rS.r1, rS.r2, rS.r3, rS.r4, rS.r5};
for fi = 1:5
    if fi == 1, lv = 1:4; else, lv = 1:5; end
    pts = rS.wrist;
    for l = lv
        c = fi - (l == 5);                     % level 5 has no thumb column
        pts = [pts J{l+1}(:, c)];              %#ok<AGROW>
    end
    plot(pts(1,:), pts(2,:), 'k-', 'linewidth', 1.5);
    plot(pts(1,2:end), pts(2,2:end), 'o', 'markersize', 7, ...
         'markerfacecolor', [0.85 0.33 0.1], 'markeredgecolor', 'k');
    for k = 2:size(pts, 2)
        if k == 2 && fi == 3      % M1 sits right above the wrist
            q = pts(:,k) + [-0.5; 2.2; 0]; ha = 'right';
        elseif k == 2 && fi > 1   % finger bases are crowded: label below
            q = pts(:,k) + [0; -2.6; 0]; ha = 'center';
        else
            q = pts(:,k) + [1.6; -0.3; 0]; ha = 'left';
        end
        text(q(1), q(2), sprintf('%s%d', fingers(fi), lv(k-1)), ...
             'fontsize', 11, 'fontweight', 'bold', 'horizontalalignment', ha);
    end
end
plot(rS.wrist(1), rS.wrist(2), 's', 'markersize', 10, ...
     'markerfacecolor', [0.2 0.2 0.2], 'markeredgecolor', 'k');
text(rS.wrist(1), rS.wrist(2) - 3, 'O', 'fontsize', 11, 'fontweight', 'bold', ...
     'horizontalalignment', 'center');
% Palm width: distance between the bases of the thumb and the little finger
y0 = rS.wrist(2) - 7;
x15 = rS.r1(1,[5 1]);
plot(x15, [y0 y0], '-', 'color', [0.45 0.45 0.45]);
plot([x15; x15], [y0 y0; y0+1 y0+1], '-', 'color', [0.45 0.45 0.45]);
text(mean(x15), y0 - 1.8, 'PW\times s (L1 to T1)', 'color', [0.45 0.45 0.45], ...
     'fontsize', 10, 'horizontalalignment', 'center');
% Degrees of freedom, next to the joint where each rotation is applied
blue = [0 0.35 0.75];
dof = {rS.wrist,       'global: \theta_1^x \theta_1^y \theta_1^z  T^x T^y T^z', [-30 -3.5];
       rS.r1(:,1),     '\theta_{T1}^x \theta_{T1}^z', [3 -3];
       rS.r2(:,1),     '\theta_{T2}^x \theta_{T2}^z', [3 -3];
       rS.r3(:,1),     '\theta_{T3}^z', [3 -3];
       rS.r2(:,2),     '\theta_{I2}^x \theta_{I2}^z', [2.5 -3];
       rS.r3(:,2),     '\theta_{I3}^x', [2.5 -3];
       rS.r4(:,2),     '\theta_{I4}^x', [2.5 -3]};
for k = 1:size(dof, 1)
    q = dof{k,1} + [dof{k,3}'; 0];
    text(q(1), q(2), dof{k,2}, 'color', blue, 'fontsize', 11);
end
% Segment lengths along the middle finger and the thumb (s = scale)
grey = [0.45 0.45 0.45];
seg = {rS.wrist, rS.r1(:,3), '';
       rS.r1(:,3), rS.r2(:,3), '6s';
       rS.r2(:,3), rS.r3(:,3), '3s\timesFP';
       rS.r3(:,3), rS.r4(:,3), '2s\timesFP';
       rS.r4(:,3), rS.r5(:,2), '2s\timesFP';
       rS.r1(:,1), rS.r2(:,1), '4s';
       rS.r2(:,1), rS.r3(:,1), '3s\timesFP';
       rS.r3(:,1), rS.r4(:,1), '2s\timesFP';
       rS.r1(:,5), rS.r2(:,5), '3s'};
for k = 1:size(seg, 1)
    if isempty(seg{k,3}), continue; end
    m = (seg{k,1} + seg{k,2}) / 2;
    text(m(1) - 1.2, m(2), seg{k,3}, 'color', grey, 'fontsize', 10, ...
         'horizontalalignment', 'right');
end
% Axis gizmo
g = [-32; 12];
plot(g(1) + [0 6], g(2) + [0 0], 'k-', g(1) + [0 0], g(2) + [0 6], 'k-');
text(g(1) + 6.8, g(2), 'x', 'fontsize', 11); text(g(1) - 0.5, g(2) + 7.6, 'y', 'fontsize', 11);
plot(g(1), g(2), 'ko', 'markersize', 7); text(g(1) - 3.5, g(2) - 1.8, 'z', 'fontsize', 11);
axis([-40 42 -13 53]);
print(f, fullfile(outDir, 'hand_model.png'), '-dpng', '-r110');
close(f);

%% Pipeline: seed points, voxel volume, depth image
[d, rS, volume] = renderDepthHand(3, 'Rotation', [pi/8 0 0]);
% Seed points in image coordinates (see voxelizeHand)
img = @(r) [r(1,:) + rS.offset(2); size(volume,1) - r(2,:) + rS.offset(1)];   % [col; row]
[rows, cols] = find(d > 0);
win = [min(rows) - 6, max(rows) + 6, min(cols) - 6, max(cols) + 6];
f = figure('visible', 'off', 'position', [0 0 1200 460]);
axes('position', [0.02 0.04 0.3 0.84]); hold on;
fl = img(rS.fill); f1 = img([rS.fill1 rS.fill2]);
allJ = img([rS.wrist rS.r1 rS.r2 rS.r3 rS.r4 rS.r5]);
plot(fl(1,:), fl(2,:), '.', 'color', [0.45 0.45 0.45], 'markersize', 6);
plot(f1(1,:), f1(2,:), 'o', 'color', [0 0.6 0.3], 'markersize', 5);
plot(allJ(1,:), allJ(2,:), '*', 'color', [0.85 0.33 0.1], 'markersize', 7);
axis equal off; set(gca, 'ydir', 'reverse'); axis(win([3 4 1 2]));
title('1. Seed points: * joints, o palm, . fill', 'fontsize', 12);
axes('position', [0.35 0.04 0.3 0.84]);
v = volume(win(1):win(2), win(3):win(4), :);
zs = find(squeeze(any(any(v, 1), 2)));
v = v(:, :, max(1, zs(1) - 3):min(end, zs(end) + 3));
fv = isosurface(v, 0.5);
fv.vertices(:,2) = -fv.vertices(:,2);   % image rows grow downwards
patch('faces', fv.faces, 'vertices', fv.vertices, ...
      'facevertexcdata', fv.vertices(:,3), 'facecolor', 'interp', 'edgecolor', 'none');
colormap(gca, copper(256));
axis equal off; view(-20, 55);
title('2. Volume: seeds dilated by a ball of radius 0.8s', 'fontsize', 12);
axes('position', [0.68 0.04 0.3 0.84]);
crop = double(d(win(1):win(2), win(3):win(4)));
imagesc(crop); axis image off; colormap(gca, gray(256));
fg = crop(crop > 0); caxis([min(fg) - 8, max(fg)]);
h = colorbar; set(h, 'fontsize', 10);
title('3. Depth image: nearest voxel per pixel', 'fontsize', 12);
print(f, fullfile(outDir, 'pipeline.png'), '-dpng', '-r100');
close(f);

%% Points of view and user profiles
addpath(fullfile(root, 'docs'));
ims = {}; labels = {};
for tx = [0 pi/8 pi/4]
    for ty = [-pi/4 0 pi/4]
        ims{end+1} = renderDepthHand(5, 'Rotation', [tx ty 0]);              %#ok<SAGROW>
        labels{end+1} = sprintf('\\theta_1^x=%s, \\theta_1^y=%s', ...
                                 angleName(tx), angleName(ty));             %#ok<SAGROW>
    end
end
depthSheet(ims, labels, 3, fullfile(outDir, 'points_of_view.png'), 150);

ims = {}; labels = {};
for fp = [1 1.1 1.2 1.3]
    for pw = [2 3 4]
        ims{end+1} = renderDepthHand(5, 'FingerPalmRatio', fp, 'PalmWidth', pw, ...
                                     'Rotation', [pi/16 0 0]);           %#ok<SAGROW>
        labels{end+1} = sprintf('FP-AR %.1f, PW %d', fp, pw);                     %#ok<SAGROW>
    end
end
depthSheet(ims, labels, 6, fullfile(outDir, 'profiles.png'), 120);

%% Dictionaries
if exist('OCTAVE_VERSION', 'builtin'), enye = char([195 177]); else, enye = char(241); end
dicts = {
    'molina2011', [1:5 7 8 11 12], ...
        {'Enum1', 'Enum2', 'Enum3', 'Enum4', 'Enum5', 'Stop', 'Fist', 'OkLeft', 'OkRight'}, 9
    'kollorz2008', 301:312, num2cell('ABCDEFGHIJKL'), 6
    'soutschek2008', 201:205, num2cell('abcde'), 5
    'misc', 101:104, {'m1', 'm2', 'm3', 'm4'}, 4
    'lse', 401:427, [num2cell('abcdefghijklmn') {enye} num2cell('opqrstuvwxyz')], 9
};
for k = 1:size(dicts, 1)
    ids = dicts{k,2};
    ims = cell(1, numel(ids)); labels = cell(1, numel(ids));
    for i = 1:numel(ids)
        ims{i} = renderDepthHand(ids(i), 'Rotation', [pi/16 0 0]);
        labels{i} = sprintf('%s (%d)', dicts{k,3}{i}, ids(i));
    end
    depthSheet(ims, labels, dicts{k,4}, ...
               fullfile(outDir, ['dict_' dicts{k,1} '.png']));
end
fprintf('Figures written to %s\n', outDir);
