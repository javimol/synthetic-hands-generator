addpath(fullfile(fileparts(mfilename('fullpath')), '..', '..', 'src'));
close all;
DICT = 'AllPostures';semanticData=[1,2,3,4,5,6,7,8,11,12,[101:104],[201,202,203,204,205] [301:312] [401:427]];
ID_STR = 'I2c';
N_POV_perScale = 1;domainScale = [3,3];
%N_POV = 100;domain = [0,pi/8;-pi/8,pi/8;-pi/8,pi/8];
%N_POV = 20;domain = [0,pi/8;-pi/8,pi/8;-pi/8,pi/8];
N_POV = 1;domain = [0,0;0,0;0,0];
NperPOSE = 1;

OUTPUTDIR = ['syn_' DICT '_' ID_STR];
mkdir (OUTPUTDIR);
dlmwrite([OUTPUTDIR '/dict.txt'],semanticData);


%Synthetic users
SCALE = [3];
%b%FP_ar=[0.8,0.9,1,1.1,1.2];
FP_ar=[1,1.1,1.2,1.3,1.4];
P_ar = [2,3,4];
grosor = [2,3];%Cuidadin con los rangos del grosor, deben ir acorde a la escala de la mano y con NUMEROS ENTEROS

prof = generateUserProfiles(SCALE,FP_ar,P_ar,grosor);
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


%VARIACIONES EN LOS ANGULOS
pM = [];
semanticIds = [];
SCALE = [];
semilla = 0;
rng(semilla);

for i =1:size(pInitial,1)
    pLocal = pInitial(i,:);
    semanticIdsLocal = semanticIds1(i);
    %Genero un matriz con los valores aleatorios para los 3 �ngulos
    phixLocal =rand(N_POV,1)*(domain(1,2)-domain(1,1))+domain(1,1);
    phiyLocal =rand(N_POV,1)*(domain(2,2)-domain(2,1))+domain(2,1);
    phizLocal =rand(N_POV,1)*(domain(3,2)-domain(3,1))+domain(3,1);
    phiLocal = [phixLocal phiyLocal phizLocal];
    pNoisyLocal = repmat(pLocal,size(phiLocal,1),1);
    pNoisyLocal(:,1:3)=pNoisyLocal(:,1:3) + phiLocal;
    pM = [pM;pNoisyLocal];
    semanticIds=[semanticIds;semanticIdsLocal*ones(size(pNoisyLocal),1)];
end
dlmwrite([OUTPUTDIR '/semanticIdsPerUser.txt'],semanticIds);
dlmwrite([OUTPUTDIR '/parametersPerUser.txt'],pM);

semanticIdsGLOBAL = [];
pMGLOBAL=[]
for iprof = 1:length(prof)
    profLocal = prof{iprof};
    display ( '****************************');
    display ( []);
    display ( ['User|Scale|FP_ar|P_ar|grosor: ' profLocal.usr '|' num2str(profLocal.SCALE) '|' num2str(profLocal.FP_ar) '|' num2str(profLocal.P_ar) '|' num2str(profLocal.Rdil)]);
    semanticIdsGLOBAL = [semanticIdsGLOBAL;semanticIds];
    pMGLOBAL=[pMGLOBAL;pM];
    ite =1;
    for i =1:size(pM,1)
        display ( [num2str(i) ' of ' num2str(size(pM,1))]);
        pplain = pM(i,:);
        p = plain2struct(pplain);
        [rS,m] = encarna(p,profLocal);
       %%%%%%%%%%%%%%%%%%%%%
        figure(1); clf;
        format = '*';
        printPoints(rS,format);
        axis([-50 50 -50 50 -50 50 ]);    
        xlabel('x');   ylabel('y'); zlabel('z');
    %     figure(2)    %     clf    %     ret = printVoxels(m,[],[]);
        depthImage = model2depthImage(m);
        figure(2);        clf;
        imshow (depthImage);
        %%%%%%%%%%%%%%%%%%%%%
        useStr=profLocal.usr;
        label = semanticIds(i);
        filename = [OUTPUTDIR '/' useStr '_' num2str(label) '_' num2str(ite)];
        imwrite(depthImage,[filename  '.png']);
        save([filename  '.mat'],'profLocal');
        ite = ite+1;
      end
end