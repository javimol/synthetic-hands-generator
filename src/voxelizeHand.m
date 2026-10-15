function [rS,volume] = voxelizeHand(p,profile)
%VOXELIZEHAND Turn the hand skeleton into a solid voxel volume.
%   [rS, volume] = voxelizeHand(p, profile) computes the skeleton of the
%   hand with parameters p (see calculatePoints), places its points in a
%   144x176x256 voxel grid (QCIF image size, 8-bit depth) and dilates them
%   with a ball of radius 0.8*scale to give the hand its volume.
%
%   If profile.center is true the hand is centred in the grid and
%   rS.offset holds the shift that was applied (in grid coordinates);
%   otherwise the translation in p places the hand.
if nargin < 2
    profiles = generateUserProfiles();
    profile = profiles{1};
end
LX = 144;
LY = 176;
LZ = 256;
dilationRadius = (4/5)*profile.scale;
[r,rS] = calculatePoints(p,profile);

% Change of basis so that the hand appears upright in the image
r = [LX-r(2,:); r(1,:); r(3,:)];

rS.offset = 0;
if profile.center
    rMin = min(r,[],2);
    rMax = max(r,[],2);
    margin = ([LX;LY;LZ]-(rMax-rMin))/2;
    if any(margin<25)
        warning('voxelizeHand: the hand barely fits in the volume');
    end
    rS.offset = -(rMin-margin);
    r = r+repmat(rS.offset,1,size(r,2));
end

r = round(r);
volume = zeros(LX,LY,LZ);
for i=1:size(r,2)
    idx = int32(r(:,i));
    if any(idx<1)
        continue;
    end
    volume(idx(1),idx(2),idx(3)) = 1;
end

volume = dilateBall(volume, dilationRadius);
volume = volume/max(volume(:));
