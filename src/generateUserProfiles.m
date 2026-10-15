function prof = generateUserProfiles(scales, fingerPalmRatios, palmWidths)
%GENERATEUSERPROFILES Hand anatomy profiles ("synthetic users").
%   prof = generateUserProfiles(scales, fingerPalmRatios, palmWidths)
%   returns a cell array with one profile struct for every combination of
%   the given values. Pass [] for any argument to use its default:
%     scales            overall hand size (default 3)
%     fingerPalmRatios  fingers/palm aspect relation, FP-AR (default 1)
%     palmWidths        palm width, PW; finger bases are spaced 0.25*PW*scale
%                       apart (default 4)
%
%   Profile fields (lengths are in voxels):
%     id                       profile number as a string, '1001', '1002', ...
%     center                   centre the hand in the voxel volume
%     phiI, phiM, phiR, phiL   splay angle of each finger about z
%     scale, fingerPalmRatio, palmWidth
%     palmLength, thumbPalmLength, littlePalmLength
%                              palm segments (finger base to knuckle)
%     proximalLength, thumbProximalLength
%                              first phalanx
%     tipSegmentLength         second and third phalanges
%     fillSpacing              spacing of the fill points along each segment
%     baseT, baseI, baseM, baseR, baseL
%                              finger bases relative to the wrist
if nargin < 1 || isempty(scales), scales = 3; end
if nargin < 2 || isempty(fingerPalmRatios), fingerPalmRatios = 1; end
if nargin < 3 || isempty(palmWidths), palmWidths = 4; end

base.center = true;
% Splay angle of each finger
base.phiI = -pi/18;
base.phiM = 0;
base.phiR = pi/18;
base.phiL = pi/9;

prof = {};
for s = scales
    for fp = fingerPalmRatios
        for pw = palmWidths
            d = base;
            d.id = num2str(1000 + numel(prof) + 1);
            d.scale = s;
            d.fingerPalmRatio = fp;
            d.palmWidth = pw;
            % Segment lengths
            d.palmLength = 6*s;
            d.thumbPalmLength = 4*s;
            d.littlePalmLength = 3*s;
            d.proximalLength = fp*3*s;
            d.thumbProximalLength = fp*3*s;
            d.tipSegmentLength = fp*2*s;
            d.fillSpacing = s/2;
            % Finger bases, 0.25*PW*scale apart
            step = 0.25*pw;
            d.baseT = [2*step step 0]'*s;
            d.baseI = [step step 0]'*s;
            d.baseM = [0 step 0]'*s;
            d.baseR = [-step step 0]'*s;
            d.baseL = [-2*step step 0]'*s;
            prof{end+1} = d; %#ok<AGROW>
        end
    end
end
