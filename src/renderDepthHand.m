function [depthImage, rS, volume] = renderDepthHand(postureId, varargin)
%RENDERDEPTHHAND Render a synthetic depth image of a hand posture.
%   depthImage = renderDepthHand(postureId) returns a 144x176 (QCIF) uint8
%   depth image of the posture with the given dictionary id (see
%   generateHandParameters), using the default hand profile, seen from the
%   front.
%
%   Optional name/value pairs:
%     'Scale'            hand scale (default 3)
%     'FingerPalmRatio'  fingers/palm aspect relation, FP-AR (default 1)
%     'PalmWidth'        palm width, PW (default 4)
%     'Rotation'         [dphi_x dphi_y dphi_z] added to the global
%                        rotation, in radians (default [0 0 0])
%
%   [depthImage, rS, volume] = renderDepthHand(...) also returns the
%   skeleton points (see calculatePoints) and the voxel volume.
%
%   Example:
%     d = renderDepthHand(8, 'Rotation', [pi/8 0 0]);  % fist, tilted
%     imshow(d, []);
opts = struct('Scale', 3, 'FingerPalmRatio', 1, 'PalmWidth', 4, ...
              'Rotation', [0 0 0]);
for k = 1:2:numel(varargin)
    opts.(varargin{k}) = varargin{k+1};
end
prof = generateUserProfiles(opts.Scale, opts.FingerPalmRatio, opts.PalmWidth);
p = generateHandParameters(postureId);
p = p{1};
p.phi1_x = p.phi1_x + opts.Rotation(1);
p.phi1_y = p.phi1_y + opts.Rotation(2);
p.phi1_z = p.phi1_z + opts.Rotation(3);
[rS, volume] = voxelizeHand(p, prof{1});
depthImage = model2depthImage(volume);
