%main4
addpath(fullfile(fileparts(mfilename('fullpath')), '..', '..', 'src'));
close all;
%DICT = 'DictA';
%DICT = 'Dict12345';semanticData=[1,2,3,4,5];
DICT = 'DictSoutschek';semanticData=[201,202,203,204,205];

%N_POV = 200;domain = [0,pi/4;-pi/4,pi/4;-pi/4,pi/4]
N_POV = 20;domain = [0,pi/8;-pi/8,pi/8;-pi/8,pi/8]
NperPOSE = 1;

coor = [1:3];
OUTPUTDIR = ['syn_' DICT '_' num2str(N_POV) 'pov_' num2str(NperPOSE) 'perPose_Noisy_phix_' num2str(domain(1,1)) '_' num2str(domain(1,2)) '_phiy_' num2str(domain(2,1)) '_' num2str(domain(2,2)) '_phiz_' num2str(domain(3,1)) '_' num2str(domain(3,2))];
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

pM = [];
semanticIds = [];
semilla = 0;
rng(semilla);
for i =1:size(pInitial,1)
    pLocal = pInitial(i,:);
    semanticIdsLocal = semanticIds1(i);
    %Genero un matriz con los valores aleatorios para los 3 ángulos
    phixLocal =rand(N_POV,1)*(domain(1,2)-domain(1,1))+domain(1,1);
    phiyLocal =rand(N_POV,1)*(domain(2,2)-domain(2,1))+domain(2,1);
    phizLocal =rand(N_POV,1)*(domain(3,2)-domain(3,1))+domain(3,1);
    phiLocal = [phixLocal phiyLocal phizLocal];
    pNoisyLocal = repmat(pLocal,size(phiLocal,1),1);
    pNoisyLocal(:,1:3)=phiLocal;
    pM = [pM;pNoisyLocal];
    semanticIds=[semanticIds;semanticIdsLocal*ones(size(pNoisyLocal),1)];
end

for i =1:size(pM,1)
    display ( [num2str(i) ' of ' num2str(size(pM,1))]);
    pplain = pM(i,:);
    p = plain2struct(pplain);
    [rS,m] = encarna(p);
    %%We get three point for alignment purposes
    rmuneca = round(rS.rMu+rS.desplazamiento);
    rIbeginning =round(rS.r2(:,2)+rS.desplazamiento);
    rLbeginning =round(rS.r2(:,5)+rS.desplazamiento);
    %%
    points = [rS.rMu rS.r2(:,2) rS.r2(:,5)];
    v1 =points(:,2) -points(:,1);
    v2 =points(:,3) -points(:,1);
    annN = cross(v1,v2);
    annN = annN/sqrt(sum(annN(:).^2));     
    figure(1)
    clf
    format = '*';
    printPoints(rS,format);
    hold on;
    text(rmuneca(1,:),rmuneca(2,:),rmuneca(3,:),'wrist');
    text(rIbeginning(1,:),rIbeginning(2,:),rIbeginning(3,:),'index');
    text(rLbeginning(1,:),rLbeginning(2,:),rLbeginning(3,:),'little');
    hold off;
    t = [0:100];
     hold on
     ptoMedio = mean(points')';
     plot3(ptoMedio(1)+annN(1)*t,ptoMedio(2)+annN(2)*t,ptoMedio(3)+annN(3)*t,'r*')
     hold off
    axis([-50 50 -50 50 -50 50 ]);    
    xlabel('x');
    ylabel('y');
    zlabel('z');
%     figure(2)
%     clf
%     ret = printVoxels(m,[],[]);

    depthImage = model2depthImage(m);
    figure(3);
    clf
    imshow (depthImage);
    user = 0;
    label = semanticIds(i);
    ite = 0;
    filename = [OUTPUTDIR '/' num2str(user) '_' num2str(label) '_' num2str(ite) '_phix' num2str(p.phi1_x*180/pi) '_phiy' num2str(p.phi1_y*180/pi) '_phiz' num2str(p.phi1_z*180/pi) '_' num2str(i)];
    imwrite(depthImage,[filename  '.png']);
    dlmwrite([filename  '_mun_I_L_vN.dat'],[rmuneca rIbeginning rLbeginning annN]);    
end
