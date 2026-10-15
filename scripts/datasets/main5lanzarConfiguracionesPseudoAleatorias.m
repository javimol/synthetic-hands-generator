%main4
addpath(fullfile(fileparts(mfilename('fullpath')), '..', '..', 'src'));
close all;
DICT = 'DictA';
N_POV = 9;
NperPOSE = 20;
SNR = -25;

OUTPUTDIR = ['synImages_AllignmentPoints_' DICT '_' num2str(N_POV) 'pov_' num2str(NperPOSE) 'perPose_SNR_' num2str(SNR) 'dB'];
mkdir (OUTPUTDIR);
%%%
% 1: Enumerate One---
% 2: Enumerate Two---
% 3: Enumerate Three---
% 4: Enumerate Four---
% 5: Enumerate Five---
% 6: Ok---
% 7: Stop---
% 8: Fist---
% 205: OkPalmaDerecha
% 202: Jedi

%semanticData=[1,2,3,4,5];
semanticData=[1,2,3,4,5,7,202,205];
dlmwrite([OUTPUTDIR '/dict.txt'],semanticData);
%%%
% 1: Enumerate One---
% 2: Enumerate Two---
% 3: Enumerate Three---
% 4: Enumerate Four---
% 5: Enumerate Five---
% 6: Ok---
% 7: Stop---
% 8: Fist---
[p] =generateHandParameters(semanticData);
% phixR = [0:pi/6:pi/3];
% phiyR =  [-pi/6:pi/6:pi/6] + 0;
% phizR = [0];%Partimos de un sistema que digiere las rotaciones en este plano


semanticIds1 = [];
pInitial= [];
for i =1:length(p)
    pLocal = p{i};
    pplain = struct2plain( pLocal );
    %[pn] = introduceNoise(pplain,N_POV,SNR);
    pnt = checkRestrictions(pplain);
    pInitial= [pInitial;pnt];
    semanticIds1 = [semanticIds1 semanticData(i)*ones(1,size(pnt,1))];   
end

switch N_POV
    case 1
        phixR =[0];
        phiyR =  [0];
        phizR = [0];%Partimos de un sistema que digiere las rotaciones en este
    case 9
        phixR = [0:pi/8:pi/4];
        phiyR =  [-pi/4:pi/4:pi/4] + 0;
        phizR = [0];%Partimos de un sistema que digiere las rotaciones en este
    case 16
        phixR = [0:pi/6:pi/2];
        phiyR =  [-pi/2:pi/3:pi/2] + 0;
        phizR = [0];%Partimos de un sistema que digiere las rotaciones en este
end

pM = [];
semanticIds = [];
for i0=1:size(pInitial,1)
    p0plain = pInitial(i0,:);
    p0 = plain2struct( p0plain );
    pMLocal = generatePointOfViewVariations(p0,phixR,phiyR,phizR);
    pNoisy= [];
    semanticIdsLocal = [];
    for cont =1:length(pMLocal)
        pLocal = pMLocal{cont};
        pplain = struct2plain( pLocal );
        [pn] = introduceNoise(pplain,NperPOSE,SNR);
        pnt = checkRestrictions(pn);
        pNoisy= [pNoisy;pnt];
        semanticIdsLocal = [semanticIdsLocal semanticIds1(i0)*ones(1,size(pnt,1))];
%         clf;
%             pAux = plain2struct(pnt);
%             [rS,m] = encarna(pLocal);
%             format = '*'; printPoints(rS,format);
%              axis([-50 50 -50 50 -50 50 ]);
    end
    if i0==1
        pM = pNoisy;
    else
        pM = [pM;pNoisy];
    end    
    semanticIds = [semanticIds semanticIdsLocal];
end

for i =1:size(pM,1)
    display ( [num2str(i) ' of ' num2str(size(pM,1))]);
    pplain = pM(i,:);
    p = plain2struct(pplain);
    [rS,m] = encarna(p);
    %%We get three point for alignment purposes
    [rS.rMu rS.r2(:,2) rS.r2(:,5)];
    rmuneca = round(rS.rMu+rS.desplazamiento);
    rIbeginning =round(rS.r2(:,2)+rS.desplazamiento);
    rLbeginning =round(rS.r2(:,5)+rS.desplazamiento);
    %%    
    figure(1)
    clf
    format = '*';
    printPoints(rS,format);
    hold on;
    text(rmuneca(1,:),rmuneca(2,:),rmuneca(3,:),'wrist');
    text(rIbeginning(1,:),rIbeginning(2,:),rIbeginning(3,:),'index');
    text(rLbeginning(1,:),rLbeginning(2,:),rLbeginning(3,:),'little');
    hold off;
    axis([-50 50 -50 50 -50 50 ]);
    figure(2)
    clf
    ret = printVoxels(m,[],[]);

    depthImage = model2depthImage(m);
    figure(3);
    clf
    imshow (depthImage);
    user = 0;
    label = semanticIds(i);
    ite = 0;
    filename = [OUTPUTDIR '/' num2str(user) '_' num2str(label) '_' num2str(ite) '_phix' num2str(p.phi1_x*180/pi) '_phiy' num2str(p.phi1_y*180/pi) '_phiz' num2str(p.phi1_z*180/pi) '_' num2str(i)];
    imwrite(depthImage,[filename  '.png']);
    dlmwrite([filename  '_mun_I_L.dat'],[rmuneca rIbeginning rLbeginning]);    
end
