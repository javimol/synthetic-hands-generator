function [rS,y]= encarna(p,data0)
if exist('data0') ~=1
    dataAux = generateUserProfiles([],[],[],[]);
    data0 = dataAux{1};
end

flagOffset = data0.flagOffset;
%L=150;
%QCIF
LX =144; 
LY =176;
LZ=256;
SCALE=data0.SCALE;
Rdil = (4/5)*SCALE;
[r,rS,TMS,data] = calculatePoints(p,data0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%CAMBIO DE BASE NECESARIO PARA QUE LA IMAGEN
%%%%%%%%%%%%%%%%%%%%%%%%%%%QUEDE COMO DEBE
 rAux = r;
r = [LX-rAux(2,:); rAux(1,:); rAux(3,:)];
 %%%%%%%%%
%  rAux = rS.rMu;
%  rS.rMu = [LX-rAux(2,:); rAux(1,:); rAux(3,:)];
%  rAux = rS.r1;
%  rS.r1 = [LX-rAux(2,:); rAux(1,:); rAux(3,:)];
%  rAux = rS.r2;
%  rS.r2 = [LX-rAux(2,:); rAux(1,:); rAux(3,:)];
%  rAux = rS.r3;
%  rS.r3 = [LX-rAux(2,:); rAux(1,:); rAux(3,:)];
%  rAux = rS.r4;
%  rS.r4 = [LX-rAux(2,:); rAux(1,:); rAux(3,:)];
%  rAux = rS.r5;
%  rS.r5 = [LX-rAux(2,:); rAux(1,:); rAux(3,:)];
%  rAux = rS.relleno;
%  rS.relleno = [LX-rAux(2,:); rAux(1,:); rAux(3,:)];
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%encarnación
xmin=min(r(1,:));
xmax=max(r(1,:));
ymin=min(r(2,:));
ymax=max(r(2,:));
zmin=min(r(3,:));
zmax=max(r(3,:));
 rS.desplazamiento = 0;
if flagOffset
    rangox=xmax-xmin;
    rangoy=ymax-ymin;
    rangoz=zmax-zmin;
    offsetx = (LX-rangox)/2;
    offsety = (LY-rangoy)/2;
    offsetz = (LZ-rangoz)/2;
    if offsetx<25 || offsety<25 || offsetz<25
        warning('encarna: Dimensiones insuficientes');
        pause;
        kk=0;
    end
    desplazamiento= -[xmin-offsetx;ymin-offsety;zmin-offsetz];
    rS.desplazamiento = desplazamiento;
    r=r+repmat(desplazamiento,1,size(r,2));
end   

rRedondeado = round(r);

matrizModel = zeros(LX,LY,LZ);
for i=1:size(rRedondeado,2)
    indices = int32(rRedondeado(:,i));
    if indices(1)<1 || indices(2)<1 || indices(3)<1
        continue;
    end
    matrizModel(indices(1),indices(2),indices(3)) = 1;
end


y = dilateBall(matrizModel, Rdil);
y = y/max(y(:));

