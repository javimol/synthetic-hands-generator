function make_dataset(preset, varargin)
%MAKE_DATASET Generate a dataset of synthetic depth hands.
%   make_dataset(preset) renders the dataset described by a named preset
%   (see the list below); make_dataset('custom', Name, Value, ...) or
%   make_dataset(preset, Name, Value, ...) sets or overrides options.
%
%   A dataset is every combination of
%     postures x hand profiles x scales x points of view x noisy samples.
%
%   Options:
%     'Postures'          posture ids (default: all 58, see
%                         generateHandParameters)
%     'Scales'            hand scales of the profile grid (default 3)
%     'FingerPalmRatios'  FP-AR values of the profile grid (default 1)
%     'PalmWidths'        PW values of the profile grid (default 4)
%     'RandomScales'      [n lo hi]: instead of the profile scale, draw n
%                         random scales in [lo, hi] for every posture
%     'Views'             number of random points of view (default 1)
%     'ViewRange'         3x2 ranges [min max] of the rotation added about
%                         x, y and z (default zeros: frontal view only)
%     'ViewGrid'          {dx, dy, dz}: use every combination of these
%                         rotations instead of random views
%     'NoiseSNR'          if set, add Gaussian noise of this power (dBW) to
%                         the joint angles
%     'NoisySamples'      noisy copies per view (default 1)
%     'Seed'              random seed (default 0)
%     'OutputDir'         default output/<preset>
%     'Show'              plot every sample while rendering (default false)
%
%   Output, in OutputDir:
%     <profile>_<posture>_<n>.png  one depth image per sample
%     index.csv                    one row per image: profile, posture,
%                                  hand anatomy, the 27 pose parameters and
%                                  the image coordinates (row, column,
%                                  depth) of the wrist and of the index and
%                                  little finger knuckles
%
%   Presets reproducing the original thesis scripts:
%     A       one frontal view of every posture
%     B       10 random scales in [2.5, 7.5]
%     C       10 random scales in [2.5, 7.5] x 50 random views
%     D/E/F   scale 5 with 200/500/1000 random views
%     G       10 random scales in [4.5, 5.5] x 50 random views
%     H2      FP-AR in {0.75, 1, 1.25}
%     I2      FP-AR {1, 1.1, 1.2} x PW {2, 3, 4}
%     I2c     FP-AR {1, ..., 1.4} x PW {2, 3, 4}
%     I2e     FP-AR {1, ..., 1.3} x PW {2, 3, 4}
%     J2      FP-AR {0.8, ..., 1.2} x PW {3, 4, 5} x 20 random views
%     J2e     FP-AR {1, ..., 1.3} x PW {2, 3, 4} x 20 random views
%     noisy   8 postures x 3x3 grid of views x 20 noisy samples (-25 dBW)
%     soutschek  the 5 postures of Soutschek et al. x 20 random views
%   Profile sets of Table 3.1 in the thesis (add 'Views', n for #POV):
%     thesisA, thesisB, thesisC, thesisD
%
%   Example:
%     make_dataset('thesisB', 'Views', 20)
addpath(fullfile(fileparts(mfilename('fullpath')), '..', 'src'));

opts = struct('Postures', [1:8 11 12 101:104 201:205 301:312 401:427], ...
    'Scales', 3, 'FingerPalmRatios', 1, 'PalmWidths', 4, ...
    'RandomScales', [], 'Views', 1, 'ViewRange', zeros(3,2), ...
    'ViewGrid', {{}}, 'NoiseSNR', [], 'NoisySamples', 1, 'Seed', 0, ...
    'OutputDir', fullfile('output', preset), 'Show', false);
opts = applyOptions(opts, presetOptions(preset));
opts = applyOptions(opts, varargin);

rng(opts.Seed);
if ~exist(opts.OutputDir, 'dir'), mkdir(opts.OutputDir); end
paramNames = fieldnames(plain2struct(zeros(1,27)))';
fid = fopen(fullfile(opts.OutputDir, 'index.csv'), 'w');
fprintf(fid, '%s\n', strjoin([{'file','profile','posture','scale', ...
    'finger_palm_ratio','palm_width'}, paramNames, ...
    {'wrist_row','wrist_col','wrist_depth','index_row','index_col', ...
     'index_depth','little_row','little_col','little_depth'}], ','));

profiles = generateUserProfiles(opts.Scales, opts.FingerPalmRatios, opts.PalmWidths);
[~, poses] = generateHandParameters(opts.Postures);
poses = checkRestrictions(poses);
n = 0;
for iProf = 1:numel(profiles)
    for iPose = 1:numel(opts.Postures)
        for prof = profileVariants(profiles{iProf}, opts)
            for view = viewOffsets(opts)
                for k = 1:opts.NoisySamples
                    pplain = poses(iPose,:);
                    if ~isempty(opts.NoiseSNR)
                        noisy = checkRestrictions(introduceNoise(pplain, 1, opts.NoiseSNR));
                        pplain(7:end) = noisy(7:end);
                    end
                    pplain(1:3) = pplain(1:3) + view';
                    p = plain2struct(pplain);
                    [rS, volume] = voxelizeHand(p, prof{1});
                    depthImage = model2depthImage(volume);
                    n = n + 1;
                    file = sprintf('%s_%d_%d.png', prof{1}.id, opts.Postures(iPose), n);
                    imwrite(depthImage, fullfile(opts.OutputDir, file));
                    keypoints = round(skeletonToGrid(rS, [rS.wrist rS.r2(:,2) rS.r2(:,5)]));
                    fprintf(fid, '%s,%s,%d,%g,%g,%g%s%s\n', file, prof{1}.id, ...
                        opts.Postures(iPose), prof{1}.scale, prof{1}.fingerPalmRatio, ...
                        prof{1}.palmWidth, sprintf(',%.6g', pplain), sprintf(',%d', keypoints(:)));
                    if opts.Show
                        showSample(rS, depthImage);
                    end
                end
            end
        end
    end
    fprintf('profile %d of %d done, %d images\n', iProf, numel(profiles), n);
end
fclose(fid);
fprintf('Wrote %d images to %s\n', n, opts.OutputDir);
end

function variants = profileVariants(prof, opts)
% The profile itself, or copies of it with random scales
if isempty(opts.RandomScales)
    variants = {prof};
    return;
end
rs = opts.RandomScales;
variants = cell(1, rs(1));
for i = 1:rs(1)
    s = rs(2) + rand*(rs(3) - rs(2));
    v = generateUserProfiles(s, prof.fingerPalmRatio, prof.palmWidth);
    v{1}.id = prof.id;
    variants{i} = v{1};
end
end

function views = viewOffsets(opts)
% 3xN rotation offsets, one column per point of view
if ~isempty(opts.ViewGrid)
    [x, y, z] = ndgrid(opts.ViewGrid{1}, opts.ViewGrid{2}, opts.ViewGrid{3});
    views = [x(:) y(:) z(:)]';
else
    r = opts.ViewRange;
    views = repmat(r(:,1), 1, opts.Views) + rand(3, opts.Views).*repmat(r(:,2)-r(:,1), 1, opts.Views);
end
end

function showSample(rS, depthImage)
figure(1); clf;
printPoints(rS, '*');
axis([-50 50 -50 50 -50 50]);
xlabel('x'); ylabel('y'); zlabel('z');
figure(2); clf;
imshow(depthImage, []);
drawnow;
end

function opts = applyOptions(opts, new)
% new is a struct or a cell array of name/value pairs
if isstruct(new)
    new = [fieldnames(new) struct2cell(new)]';
end
for i = 1:2:numel(new)
    if ~isfield(opts, new{i})
        error('make_dataset: unknown option ''%s''', new{i});
    end
    opts.(new{i}) = new{i+1};
end
end

function o = presetOptions(name)
views = [0 pi/8; -pi/8 pi/8; -pi/8 pi/8];   % range used in the thesis
switch name
    case 'custom', o = struct();
    case 'A',   o = struct();
    case 'B',   o = struct('RandomScales', [10 2.5 7.5]);
    case 'C',   o = struct('RandomScales', [10 2.5 7.5], 'Views', 50, 'ViewRange', views);
    case 'D',   o = struct('Scales', 5, 'Views', 200, 'ViewRange', views);
    case 'E',   o = struct('Scales', 5, 'Views', 500, 'ViewRange', views);
    case 'F',   o = struct('Scales', 5, 'Views', 1000, 'ViewRange', views);
    case 'G',   o = struct('RandomScales', [10 4.5 5.5], 'Views', 50, 'ViewRange', views);
    case 'H2',  o = struct('FingerPalmRatios', [0.75 1 1.25]);
    case 'I2',  o = struct('FingerPalmRatios', [1 1.1 1.2], 'PalmWidths', [2 3 4]);
    case 'I2c', o = struct('FingerPalmRatios', [1 1.1 1.2 1.3 1.4], 'PalmWidths', [2 3 4]);
    case 'I2e', o = struct('FingerPalmRatios', [1 1.1 1.2 1.3], 'PalmWidths', [2 3 4]);
    case 'J2',  o = struct('FingerPalmRatios', [0.8 0.9 1 1.1 1.2], 'PalmWidths', [3 4 5], ...
                           'Views', 20, 'ViewRange', views);
    case 'J2e', o = struct('FingerPalmRatios', [1 1.1 1.2 1.3], 'PalmWidths', [2 3 4], ...
                           'Views', 20, 'ViewRange', views);
    case 'noisy'
        o = struct('Postures', [1 2 3 4 5 7 202 205], ...
                   'ViewGrid', {{0:pi/8:pi/4, -pi/4:pi/4:pi/4, 0}}, ...
                   'NoiseSNR', -25, 'NoisySamples', 20);
    case 'soutschek'
        o = struct('Postures', 201:205, 'Views', 20, 'ViewRange', views);
    case 'thesisA', o = struct('FingerPalmRatios', 1, 'PalmWidths', 3, 'ViewRange', views);
    case 'thesisB', o = struct('FingerPalmRatios', [1 1.1 1.2 1.3], 'PalmWidths', [2 3 4], 'ViewRange', views);
    case 'thesisC', o = struct('FingerPalmRatios', 1:0.05:1.2, 'PalmWidths', 2:0.5:4, 'ViewRange', views);
    case 'thesisD', o = struct('FingerPalmRatios', 0.9:0.05:1.1, 'PalmWidths', 2:0.5:4, 'ViewRange', views);
    otherwise
        error('make_dataset: unknown preset ''%s''', name);
end
end
