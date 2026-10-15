function [r,rStruct,TMS,data0] = calculatePoints(p,data0)
%POR CORREGIR: MUY IMPORTANTE: orden de las matrices T*S*R La S está
%implicita en SCALE
if exist('data0') ~=1
    dataAux = generateUserProfiles([],[],[],[]);
    data0 = dataAux{1};
end

r = [];
rStruct=[];
SCALE= data0.SCALE;
%ORIGENES_RELATIVOS al nivel 0
rrelT = data0.rrelT;
rrelI = data0.rrelI;
rrelM = data0.rrelM;
rrelR = data0.rrelR;
rrelL = data0.rrelL;
%Longitud Falanges
LPalma = data0.LPalma;
LPalma_T = data0.LPalma_T;
LPalma_L = data0.LPalma_L;
L2 = data0.L2;
L2_T=data0.L2_T;
LExtremos = data0.LExtremos;
LSegmentosRelleno=data0.LSegmentosRelleno;
%Angulo de cada dedo
phiI=data0.phiI;
phiM=data0.phiM;
phiR=data0.phiR;
phiL=data0.phiL;

% 
% %Thumb
% p.PhiT1_x= 0;
% p.PhiT1_z= 0;
% p.PhiT2_x= 0;
% p.PhiT2_z= 0;
% p.PhiT3_z= 0;
% 
% %Index
% p.phiI2_x= 0;
% p.phiI2_z= 0;
% p.phiI3_x= 0;
% p.phiI4_x= 0;
% 
% %Middle
% p.phiM2_x= 0;
% p.phiM2_z= 0;
% p.phiM3_x= 0;
% p.phiM4_x= 0;
% 
% %Ring
% p.phiR2_x= 0;
% p.phiR2_z= 0;
% p.phiR3_x= 0;
% p.phiR4_x= 0;
% 
% %Little
% p.phiL2_x= 0;
% p.phiL2_z= 0;
% p.phiL3_x= 0;
% p.phiL4_x= 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Firstly, we calculate the Transformation Matrixes
%http://gpwiki.org/index.php/Matrix_math
% %Global
% p.phi1_x= 0;
% p.phi1_y= 0;
% p.phi1_z= 0;
% p.T1_x= 0;
% p.T1_y= 0;
% p.T1_z= 0;
X=p.T1_x;
Y=p.T1_y;
Z=p.T1_z;
TM0_a = tranlationMatrix(X,Y,Z);
%Rotation in x y & z
phix=p.phi1_x;
phiy=p.phi1_y;
phiz=p.phi1_z;
TM0_b = rotationMatrix(phix,phiy,phiz);
TMS.T0 = TM0_a*TM0_b;
% %Thumb
% p.PhiT1_x= 0;
% p.PhiT1_z= 0;
% p.PhiT2_x= 0;
% p.PhiT2_z= 0;
% p.PhiT3_z= 0;
phix=p.phiT1_x;phiy=0;phiz=p.phiT1_z;
TMS.T1_T = tranlationMatrix(rrelT(1),rrelT(2),rrelT(3))*rotationMatrix(phix,phiy,phiz);
phix=p.phiT2_x;
phiy=0;
phiz=p.phiT2_z;
TMS.T2_T = tranlationMatrix(0,LPalma_T,0)*rotationMatrix(phix,phiy,phiz);
phix=0;
phiy=0;
phiz=p.phiT3_z;
TMS.T3_T = tranlationMatrix(0,L2_T,0)*rotationMatrix(phix,phiy,phiz);


%For the rest of fingers
ids = 'IMRL';
for i=1:length(ids)
    id = ids(i);
    % p.phi{id}2_x= 0;
    % p.phi{id}2_z= 0;
    % p.phi{id}3_x= 0;
    % p.phi{id}4_x= 0;
    phix=0;
    phiy=0;
    eval(['phiz=phi' id ';']);
    eval(['TMS.T1_' id '= tranlationMatrix(rrel' id '(1),rrel' id '(2),rrel' id '(3))*rotationMatrix(phix,phiy,phiz);']);
    eval(['phix=p.phi' id '2_x;']);
    phiy=0;
    eval(['phiz=p.phi' id '2_z;']);
    LPalmaLocal = LPalma;
    if id=='L'
        LPalmaLocal = LPalma_L;
    end
    eval(['TMS.T2_' id '=tranlationMatrix(0,LPalmaLocal,0)*rotationMatrix(phix,phiy,phiz);']);
    eval(['phix=p.phi' id '3_x;'])
    phiy=0;
    phiz=0;
    eval(['TMS.T3_' id '=tranlationMatrix(0,L2,0)*rotationMatrix(phix,phiy,phiz);']);
    eval(['phix=p.phi' id '4_x;']);
    phiy=0;
    phiz=0;  
    eval(['TMS.T4_' id '=tranlationMatrix(0,LExtremos,0)*rotationMatrix(phix,phiy,phiz);']);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%We calculate the joints
%LEVEL 0: MUÑECA
rMu = TMS.T0*[0 0 0 1]';    

%LEVEL 1 
    %absolute
    rT1 = TMS.T0*TMS.T1_T*[0 0 0 1]';
    rI1 = TMS.T0*TMS.T1_I*[0 0 0 1]';
    rM1 = TMS.T0*TMS.T1_M*[0 0 0 1]';
    rR1 = TMS.T0*TMS.T1_R*[0 0 0 1]';
    rL1 = TMS.T0*TMS.T1_L*[0 0 0 1]';
    r1 = [rT1 rI1 rM1 rR1 rL1];
    r1relleno = [];
    r1relleno = [r1relleno (rT1+(rT1+rI1)/2)/2 (rT1+rI1)/2 ((rT1+rI1)/2 +rI1)/2 (rI1+rM1)/2 (rM1+rR1)/2 (rR1+rL1)/2];
    %Un poquito más de carne el pulgar
    r1relleno = [r1relleno (rT1+(rT1+rI1)/2)/2 (rT1+rI1)/2 ((rT1+rI1)/2 +rI1)/2];
%LEVEL 2 
    %absolute
    rT2 = TMS.T0*TMS.T1_T*TMS.T2_T*[0 0 0 1]';
    rI2 = TMS.T0*TMS.T1_I*TMS.T2_I*[0 0 0 1]';
    rM2 = TMS.T0*TMS.T1_M*TMS.T2_M*[0 0 0 1]';
    rR2 = TMS.T0*TMS.T1_R*TMS.T2_R*[0 0 0 1]';
    rL2 = TMS.T0*TMS.T1_L*TMS.T2_L*[0 0 0 1]';
    r2 = [rT2 rI2 rM2 rR2 rL2];
    r2relleno = [];
    r2relleno = [r2relleno (rT2+(rT2+rI2)/2)/2 (rT2+rI2)/2 ((rT2+rI2)/2 +rI2)/2 (rI2+rM2)/2 (rM2+rR2)/2 (rR2+rL2)/2];
    %Un poquito más de carne el pulgar
    r2relleno = [r2relleno (rT2+(rT2+rM2)/2)/2 (rT2+rM2)/2 ((rT2+rM2)/2 +rM2)/2];
%LEVEL 3 
    %absolute
    rT3 = TMS.T0*TMS.T1_T*TMS.T2_T*TMS.T3_T*[0 0 0 1]';
    rI3 = TMS.T0*TMS.T1_I*TMS.T2_I*TMS.T3_I*[0 0 0 1]';
    rM3 = TMS.T0*TMS.T1_M*TMS.T2_M*TMS.T3_M*[0 0 0 1]';
    rR3 = TMS.T0*TMS.T1_R*TMS.T2_R*TMS.T3_R*[0 0 0 1]';
    rL3 = TMS.T0*TMS.T1_L*TMS.T2_L*TMS.T3_L*[0 0 0 1]';
    r3 = [rT3 rI3 rM3 rR3 rL3];

%LEVEL 4 
    %absolute
    rT4 = TMS.T0*TMS.T1_T*TMS.T2_T*TMS.T3_T*[0 LExtremos 0 1]';%***
    rI4 = TMS.T0*TMS.T1_I*TMS.T2_I*TMS.T3_I*TMS.T4_I*[0 0 0 1]';
    rM4 = TMS.T0*TMS.T1_M*TMS.T2_M*TMS.T3_M*TMS.T4_M*[0 0 0 1]';
    rR4 = TMS.T0*TMS.T1_R*TMS.T2_R*TMS.T3_R*TMS.T4_R*[0 0 0 1]';
    rL4 = TMS.T0*TMS.T1_L*TMS.T2_L*TMS.T3_L*TMS.T4_L*[0 0 0 1]';
    r4 = [rT4 rI4 rM4 rR4 rL4];
%LEVEL 5 
    %absolute
    rT5 = [];
    rI5 = TMS.T0*TMS.T1_I*TMS.T2_I*TMS.T3_I*TMS.T4_I*[0 LExtremos 0 1]';;%***
    rM5 = TMS.T0*TMS.T1_M*TMS.T2_M*TMS.T3_M*TMS.T4_M*[0 LExtremos 0 1]';;%***
    rR5 = TMS.T0*TMS.T1_R*TMS.T2_R*TMS.T3_R*TMS.T4_R*[0 LExtremos 0 1]';;%***
    rL5 = TMS.T0*TMS.T1_L*TMS.T2_L*TMS.T3_L*TMS.T4_L*[0 LExtremos 0 1]';;%***
    r5 = [rT5 rI5 rM5 rR5 rL5];
    rStruct.rMu = rMu([1:3],:);
    rStruct.r1 = r1([1:3],:);
    rStruct.r2 = r2([1:3],:);
    rStruct.r3 = r3([1:3],:);
    rStruct.r4 = r4([1:3],:);
    rStruct.r5 = r5([1:3],:);
 r = [r1([1:3],:) r2([1:3],:) r3([1:3],:) r4([1:3],:) r5([1:3],:)];
%Puntos de relleno 
 rrelleno = [];
 for iL=0:5-1
     if iL>0
     eval(['rLA = rStruct.r' num2str(iL) ';']);
     else
         rLA = repmat(rStruct.rMu,1,5);
     end
     eval(['rLB = rStruct.r' num2str(iL+1) ';']);
     if (size(rLB,2)<size(rLA,2))
         rLA = rLA([1:3],2:end);
     end
     for i=1:size(rLA,2)
        rA = rLA([1:3],i);
        rB = rLB([1:3],i);
        rAux = rB-rA;
        LrAux = sqrt(sum(rAux.^2));
        Npoints = ceil(LrAux/LSegmentosRelleno)-1;
  %      Npoints =6;
        [rrellenoLocal,lsegmento]= interpolPoints(rA,rB,Npoints);       
        rrelleno = [rrelleno rrellenoLocal];
     end      
 end
 
 
 %Aristas intermedias añadidas
 %rrellenoAux = [r1relleno([1:3],:) r2relleno([1:3],:)];
 
 rLA=r1relleno;
 rLB=r2relleno;
 for i=1:size(rLA,2)
        rA = rLA([1:3],i);
        rB = rLB([1:3],i);
        %Npoints =6;
          Npoints = ceil(LrAux/LSegmentosRelleno)-1;
        [rrellenoLocal,lsegmento]= interpolPoints(rA,rB,Npoints);       
        rrelleno = [rrelleno rrellenoLocal(:,[1:end-1])];
 end   
 rStruct.relleno= rrelleno;
 rStruct.r1relleno = r1relleno;
 rStruct.r2relleno = r2relleno;
 r = [r rrelleno];