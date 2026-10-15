function depthImage = model2depthImage(volume)
%MODEL2DEPTHIMAGE Depth image of a voxel volume seen along the z axis.
%   For every (x, y) the pixel value is the largest z index occupied by the
%   hand (0 for background), saturated to the uint8 range.
z = reshape(1:size(volume,3), 1, 1, []);
depthImage = uint8(max((volume==1) .* z, [], 3));
