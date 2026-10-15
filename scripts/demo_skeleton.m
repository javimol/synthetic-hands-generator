% DEMO_SKELETON  Show the three stages of the generator for one posture:
% the kinematic skeleton, the voxel volume and the depth image.
addpath(fullfile(fileparts(mfilename('fullpath')), '..', 'src'));
postureId = 5;   % open hand; see generateHandParameters for the ids
close all;
[depthImage, rS, volume] = renderDepthHand(postureId);
figure; printPoints(rS, '*'); axis([-50 50 -50 50 -50 50]);
title('Skeleton: joints, fill points and bones');
figure; printVoxels(volume, [], []); title('Voxel volume');
figure; imshow(depthImage, []); title('Depth image');
