function ret = printPoints(rS,format)
CON_RELLENO = true;
ret = 0;
%ejes
% X = [0 0 0;10 0 0];
% Y = [0 0 0;0 10 0];
% Z = [0 0 0;0 0 10];
hold on;
% plot3(X(:,1),X(:,2),X(:,3));xlabel('x');
% plot3(Y(:,1),Y(:,2),Y(:,3));ylabel('y');
% plot3(Z(:,1),Z(:,2),Z(:,3));zlabel('z');
plot3(rS.rMu(1,:),rS.rMu(2,:),rS.rMu(3,:),format,'MarkerSize',12);
plot3(rS.r1(1,:),rS.r1(2,:),rS.r1(3,:),format,'MarkerSize',12);
plot3(rS.r2(1,:),rS.r2(2,:),rS.r2(3,:),format,'MarkerSize',12);
plot3(rS.r3(1,:),rS.r3(2,:),rS.r3(3,:),format,'MarkerSize',12);
plot3(rS.r4(1,:),rS.r4(2,:),rS.r4(3,:),format,'MarkerSize',12);
plot3(rS.r5(1,:),rS.r5(2,:),rS.r5(3,:),format,'MarkerSize',12);
if CON_RELLENO
    plot3(rS.relleno(1,:),rS.relleno(2,:),rS.relleno(3,:),'k.','MarkerSize',12);
    %Lineas entre los extremos de las falanges
    plot3(rS.r1(1,:),rS.r1(2,:),rS.r1(3,:),'-.g');
    plot3(rS.r2(1,:),rS.r2(2,:),rS.r2(3,:),'-.g');


    r1relleno=rS.r1relleno;
    r2relleno = rS.r2relleno;

    plot3([rS.r2(1,1) rS.r2(1,3)],[rS.r2(2,1) rS.r2(2,3)],[rS.r2(3,1) rS.r2(3,3)],'-.g');

    plot3(r1relleno(1,:),r1relleno(2,:),r1relleno(3,:),'og','MarkerSize',12);
    plot3(r2relleno(1,:),r2relleno(2,:),r2relleno(3,:),'og','MarkerSize',12);
    for iR=1:size(r1relleno,2)
        plot3([r1relleno(1,iR) r2relleno(1,iR)],[r1relleno(2,iR) r2relleno(2,iR)],[r1relleno(3,iR) r2relleno(3,iR)],':g');
    end
end
%I do label the points calculated in the imaginary segments
%abc = 'abcdefghijk';
abc = 'TIMRL';
rAux = rS.r1;
for ir=1:size(rAux,2)
    text(rAux(1,ir),rAux(2,ir),rAux(3,ir),[abc(ir) '1'],'FontSize',18);
end
rAux =rS.r2;
for ir=1:size(rAux,2)
    text(rAux(1,ir),rAux(2,ir),rAux(3,ir),[ abc(ir) '2'],'FontSize',18);
end
if ~CON_RELLENO
    rAux =rS.r3;
    for ir=1:size(rAux,2)
        text(rAux(1,ir),rAux(2,ir),rAux(3,ir),[ abc(ir) '3'],'FontSize',18);
    end
    rAux =rS.r4;
    for ir=2:size(rAux,2)
        text(rAux(1,ir),rAux(2,ir),rAux(3,ir),[ abc(ir) '4'],'FontSize',18);
    end
end

%Pinto ejes
plot3([-30 -25],[15 15],[0,0],'-k');
plot3([-25],[15],[0],'>k','MarkerSize',12);
plot3([-30 -30],[15 20],[0,0],'-k');
plot3([-30],[20],[0],'^k','MarkerSize',12);
plot3([-30],[15],[0],'ok','MarkerSize',12);
text(-25,15,0, 'x' ,'FontSize',18);
text(-30,20,0, 'y' ,'FontSize',18);
text(-30,15,0, 'z' ,'FontSize',18);

%pulgar
puntosX =[rS.rMu(1,1) rS.r1(1,1) rS.r2(1,1) rS.r3(1,1) rS.r4(1,1)];
puntosY =[rS.rMu(2,1) rS.r1(2,1) rS.r2(2,1) rS.r3(2,1) rS.r4(2,1)];
puntosZ =[rS.rMu(3,1) rS.r1(3,1) rS.r2(3,1) rS.r3(3,1) rS.r4(3,1)];
plot3(puntosX,puntosY,puntosZ,'k-');
puntosX =[rS.rMu(1,1) rS.r1(1,2) rS.r2(1,2) rS.r3(1,2) rS.r4(1,2) rS.r5(1,1)];
puntosY =[rS.rMu(2,1) rS.r1(2,2) rS.r2(2,2) rS.r3(2,2) rS.r4(2,2) rS.r5(2,1)];
puntosZ =[rS.rMu(3,1) rS.r1(3,2) rS.r2(3,2) rS.r3(3,2) rS.r4(3,2) rS.r5(3,1)];
plot3(puntosX,puntosY,puntosZ,'k-');
puntosX =[rS.rMu(1,1) rS.r1(1,3) rS.r2(1,3) rS.r3(1,3) rS.r4(1,3) rS.r5(1,2)];
puntosY =[rS.rMu(2,1) rS.r1(2,3) rS.r2(2,3) rS.r3(2,3) rS.r4(2,3) rS.r5(2,2)];
puntosZ =[rS.rMu(3,1) rS.r1(3,3) rS.r2(3,3) rS.r3(3,3) rS.r4(3,3) rS.r5(3,2)];
plot3(puntosX,puntosY,puntosZ,'k-');
puntosX =[rS.rMu(1,1) rS.r1(1,4) rS.r2(1,4) rS.r3(1,4) rS.r4(1,4) rS.r5(1,3)];
puntosY =[rS.rMu(2,1) rS.r1(2,4) rS.r2(2,4) rS.r3(2,4) rS.r4(2,4) rS.r5(2,3)];
puntosZ =[rS.rMu(3,1) rS.r1(3,4) rS.r2(3,4) rS.r3(3,4) rS.r4(3,4) rS.r5(3,3)];
plot3(puntosX,puntosY,puntosZ,'k-');
puntosX =[rS.rMu(1,1) rS.r1(1,5) rS.r2(1,5) rS.r3(1,5) rS.r4(1,5) rS.r5(1,4)];
puntosY =[rS.rMu(2,1) rS.r1(2,5) rS.r2(2,5) rS.r3(2,5) rS.r4(2,5) rS.r5(2,4)];
puntosZ =[rS.rMu(3,1) rS.r1(3,5) rS.r2(3,5) rS.r3(3,5) rS.r4(3,5) rS.r5(3,4)];
plot3(puntosX,puntosY,puntosZ,'k-');
%plot3(rS.relleno(1,:),rS.relleno(2,:),rS.relleno(3,:),'k-');





hold off;