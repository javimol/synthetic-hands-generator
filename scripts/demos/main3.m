%main3
%%%
% 1: Enumerate One---
% 2: Enumerate Two---
% 3: Enumerate Three---
% 4: Enumerate Four---
% 5: Enumerate Five---
% 6: Ok---
% 7: Stop---
% 8: Fist---
% 202: Jedi
% 205: OkPalmaDerecha

addpath(fullfile(fileparts(mfilename('fullpath')), '..', '..', 'src'));
close all;
semanticData=[312];%[1,2,3,4,5];
[pAux] =generateHandParameters(semanticData);
p = pAux{1};
[rS,m] = encarna(p);
format = '*'; printPoints(rS,format);
axis([-50 50 -50 50 -50 50 ]);
figure
ret = printVoxels(m,[],[]);

depthImage = model2depthImage(m);
figure;
imshow (depthImage);
