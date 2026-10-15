%main4
addpath(fullfile(fileparts(mfilename('fullpath')), '..', '..', 'src'));
close all;
%DICT = 'DictA';
DICT = 'DictFiguras';
N_POV = 1;


OUTPUTDIR = ['synImages_AllignmentPoints_' DICT '_' num2str(N_POV) 'pov'];
mkdir (OUTPUTDIR);
VOLCAR_FIGURAS = true;
if VOLCAR_FIGURAS
    OUTPUTFIGURES = [OUTPUTDIR '/figures'];
    mkdir (OUTPUTFIGURES);
end
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

semanticData=[1,2,3,4,5];
%semanticData=[1,2,3,4,5,7,202,205];
dlmwrite([OUTPUTDIR '/dict.txt'],semanticData);
%%%
[p] =generateHandParameters(semanticData);
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
% phixR = [0:pi/6:pi/2];
% phiyR =  [-pi/2:pi/3:pi/2] + 0;
% phizR = [0];%Partimos de un sistema que digiere las rotaciones en este plano

% % plano
pM = {};
semanticIds = [];
for i0=1:length(p)
    p0 = p{i0};
    pMLocal = generatePointOfViewVariations(p0,phixR,phiyR,phizR);
    if i0==1
        pM = pMLocal;
    else
        pM = [pM pMLocal];
    end    
    semanticIds = [semanticIds semanticData(i0)*ones(1,length(pMLocal))];
end

for i =1:length(pM)
%for i =5:5
    display ( [num2str(i) ' of ' num2str(length(pM))]);
    p = pM{i};
    [rS,m] = encarna(p);
    %%We get three point for alignment purposes
    [rS.rMu rS.r2(:,2) rS.r2(:,5)]
    rmuneca = round(rS.rMu+rS.desplazamiento);
    rIbeginning =round(rS.r2(:,2)+rS.desplazamiento);
    rLbeginning =round(rS.r2(:,5)+rS.desplazamiento);
    %%    
    h =figure(1)
    clf
    format = '*k';
    printPoints(rS,format);
    axis square
    axis([-60 60 0 120 -60 60]);
    if VOLCAR_FIGURAS
        saveas(h,[OUTPUTFIGURES '/fig' num2str(i) '.fig']);
        names = fieldnames(p);
        fid = fopen([OUTPUTFIGURES '/fig' num2str(i) '.txt'], 'w');
        for iNames =1: length(names)
             nameLocal = names{iNames};
             eval(['valueAux = p.' nameLocal ';']);
              fprintf(fid, '%s:%f\n',nameLocal,valueAux);
        end
        fclose(fid);
    end
%     hold on;
%     text(rmuneca(1,:),rmuneca(2,:),rmuneca(3,:),'wrist');
%     text(rIbeginning(1,:),rIbeginning(2,:),rIbeginning(3,:),'index');
%     text(rLbeginning(1,:),rLbeginning(2,:),rLbeginning(3,:),'little');
%     hold off;  
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
    filename = [OUTPUTDIR '/' num2str(user) '_' num2str(label) '_' num2str(ite) '_phix' num2str(p.phi1_x*180/pi) '_phiy' num2str(p.phi1_y*180/pi) '_phiz' num2str(p.phi1_z*180/pi)];
    imwrite(depthImage,[filename  '.png']);
    dlmwrite([filename  '_mun_I_L.dat'],[rmuneca rIbeginning rLbeginning]);    
end
