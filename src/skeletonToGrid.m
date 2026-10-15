function g = skeletonToGrid(rS, r)
%SKELETONTOGRID Skeleton points in voxel-grid / image coordinates.
%   g = skeletonToGrid(rS, r) maps the 3xN points r, taken from the
%   skeleton rS returned by voxelizeHand, to [row; column; depth] in the
%   voxel volume and the depth image. Uses the same change of basis and
%   centring offset as voxelizeHand.
LX = 144;  % first dimension of the voxel volume, see voxelizeHand
g = [LX - r(2,:); r(1,:); r(3,:)] + repmat(rS.offset, 1, size(r,2));
