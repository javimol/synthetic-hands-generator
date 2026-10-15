% DEMO_POINTS_OF_VIEW  One posture seen from a 3x3 grid of points of view
% (rotations about x in {0, 22.5, 45} degrees and about y in {-45, 0, 45}).
addpath(fullfile(fileparts(mfilename('fullpath')), '..', 'src'));
postureId = 1;
dx = [0 pi/8 pi/4];
dy = [-pi/4 0 pi/4];
close all;
figure;
k = 0;
for i = 1:numel(dx)
    for j = 1:numel(dy)
        k = k + 1;
        subplot(numel(dx), numel(dy), k);
        imshow(renderDepthHand(postureId, 'Rotation', [dx(i) dy(j) 0]), []);
        title(sprintf('x %+.1f, y %+.1f', dx(i)*180/pi, dy(j)*180/pi));
    end
end
