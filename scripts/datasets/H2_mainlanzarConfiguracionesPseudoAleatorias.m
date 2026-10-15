addpath(fullfile(fileparts(mfilename('fullpath')), '..', '..', 'src'));
close all;
DICT = 'AllPostures';semanticData=[1,2,3,4,5,6,7,8,11,12,[101:104],[201,202,203,204,205] [301:312] [401:427]];
ID_STR = 'H2';
domain_ASPECT_RELATION = [0.75,1,1.25];
N_POV_perScale = 1;domainScale = [3,3];
N_POV = 1;domain = [0,0;0,0;0,0];
NperPOSE = 1;

OUTPUTDIR = ['syn_' DICT '_' ID_STR];
mkdir (OUTPUTDIR);
dlmwrite([OUTPUTDIR '/dict.txt'],semanticData);



data0.flagOffset = true;
SCALE = 3; 
data0.SCALE=SCALE;
data0.rrelT = [2 1 0]'*SCALE;
data0.rrelI = [1 1 0]'*SCALE;
data0.rrelM = [0 1 0]'*SCALE;
data0.rrelR = [-1 1 0]'*SCALE;
data0.rrelL = [-2 1 0]'*SCALE;
%Longitud Falanges
data0.LPalma = 6*SCALE;
data0.LPalma_T = 4*SCALE;
data0.LPalma_L = 3*SCALE;
data0.L2 = 3*SCALE;
data0.L2_T=3*SCALE;
data0.LExtremos = 2*SCALE;
data0.LSegmentosRelleno=SCALE/2;



[p] =generateHandParameters(semanticData);







semanticIds1 = [];
pInitial= [];
for i =1:length(p)
    pLocal = p{i};
    pplain = struct2plain( pLocal );
    pnt = checkRestrictions(pplain);
    pInitial= [pInitial;pnt];
    semanticIds1 = [semanticIds1 semanticData(i)*ones(1,size(pnt,1))];   
end





%ESCALAS
SCALE_2 =  [];
pInitial_2 = [];
semanticIds_2 = [];
for i =1:size(pInitial,1)
    %Genero escalas aleatorias
    semanticId_Local = semanticIds1(i);
    pLocal = pInitial(i,:);
    scaleLocal = rand(N_POV_perScale,1)*(domainScale(1,2)-domainScale(1,1))+domainScale(1,1);
    SCALE_2 = [SCALE_2;scaleLocal];
    pNoisyLocal = repmat(pLocal,N_POV_perScale,1);
    pInitial_2 = [pInitial_2;pNoisyLocal];
    semanticIds_2 = [semanticIds_2;repmat(semanticId_Local,N_POV_perScale,1)];   
end


%VARIACIONES EN LOS ANGULOS
pM = [];
semanticIds = [];
SCALE = [];
semilla = 0;
rng(semilla);

for i =1:size(pInitial_2,1)
    pLocal = pInitial_2(i,:);
    scaleLocal =  SCALE_2(i);
    semanticIdsLocal = semanticIds_2(i);
    %Genero un matriz con los valores aleatorios para los 3 �ngulos
    phixLocal =rand(N_POV,1)*(domain(1,2)-domain(1,1))+domain(1,1);
    phiyLocal =rand(N_POV,1)*(domain(2,2)-domain(2,1))+domain(2,1);
    phizLocal =rand(N_POV,1)*(domain(3,2)-domain(3,1))+domain(3,1);
    phiLocal = [phixLocal phiyLocal phizLocal];
    pNoisyLocal = repmat(pLocal,size(phiLocal,1),1);
    pNoisyLocal(:,1:3)=pNoisyLocal(:,1:3) + phiLocal;
    pM = [pM;pNoisyLocal];
    semanticIds=[semanticIds;semanticIdsLocal*ones(size(pNoisyLocal),1)];
     SCALE = [SCALE;repmat(scaleLocal,N_POV,1)];
end
dlmwrite([OUTPUTDIR '/semanticIds.txt'],semanticIds);
dlmwrite([OUTPUTDIR '/scale.txt'],SCALE);
dlmwrite([OUTPUTDIR '/parameters.txt'],pM);
for iAR = 1:length(domain_ASPECT_RELATION)
    AR_Local = domain_ASPECT_RELATION(iAR);
    display ( '****************************');
    display ( ['Aspect Relation: ' num2str(AR_Local)]);
    
    useStr = num2str(100*AR_Local);
    data = data0;
    data.L2 = AR_Local*data0.L2;
    data.L2_T=AR_Local*data0.L2_T;
    data.LExtremos = AR_Local*data0.LExtremos;
     %%%%%%%%%%%%%%%
    for i =1:size(pM,1)
        display ( [num2str(i) ' of ' num2str(size(pM,1))]);
        pplain = pM(i,:);
        p = plain2struct(pplain);
        %scaleLocal = SCALE(i);
        data.SCALE = SCALE(i);
        [rS,m] = encarna(p,data);
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
        label = semanticIds(i);
        ite = 0;
        %filename = [OUTPUTDIR '/' num2str(user) '_' num2str(label) '_' num2str(ite) '_phix' num2str(p.phi1_x*180/pi) '_phiy' num2str(p.phi1_y*180/pi) '_phiz' num2str(p.phi1_z*180/pi) '_' num2str(i)];
        filename = [OUTPUTDIR '/' useStr '_' num2str(label) '_' num2str(ite) '_' num2str(i)];
        imwrite(depthImage,[filename  '.png']);
       % dlmwrite([filename  '_mun_I_L_vN.dat'],[rmuneca rIbeginning rLbeginning annN]);    
    end
end