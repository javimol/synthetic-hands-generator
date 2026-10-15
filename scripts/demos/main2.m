%main2
addpath(fullfile(fileparts(mfilename('fullpath')), '..', '..', 'src'));
close all;
semanticData=[];
[p] =generateHandParameters(semanticData);
[rS,m] = encarna(p);
format = '*'; printPoints(rS,format);
axis([-50 50 -50 50 -50 50 ]);
figure
ret = printVoxels(m,[],[]);

depthImage = model2depthImage(m);
figure;
imshow (depthImage);
