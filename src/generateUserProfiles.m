function prof = generateUserProfiles(SCALE,FP_ar,P_ar,grosor)

if isempty(SCALE)
    SCALE = 3;
end

if isempty(FP_ar)
    FP_ar = 1;
end
if isempty(P_ar)
    P_ar = 4;
end
if isempty(grosor)
    grosor = 1;
end

dataLocal.usr = '0';
dataLocal.flagOffset = true;

%Angulo de cada dedo
dataLocal.phiI=-pi/18;
dataLocal.phiM=0;
dataLocal.phiR=pi/18;
dataLocal.phiL=pi/9;

counter = 1;
for s =1:length(SCALE)
    scaleLocal= SCALE(s);
    display ( '****************************');
    display ( ['Scale: ' num2str(scaleLocal)]);
    dataLocal.SCALE = scaleLocal;
    %default 3
    %Longitud Falanges 
    dataLocal.LPalma = 6*scaleLocal;
    dataLocal.LPalma_T = 4*scaleLocal;
    dataLocal.LPalma_L = 3*scaleLocal;
    dataLocal.L2 = 3*scaleLocal;
    dataLocal.L2_T=3*scaleLocal;
    dataLocal.LExtremos = 2*scaleLocal;
    dataLocal.LSegmentosRelleno=scaleLocal/2;
    for i=1:length(FP_ar)
        FP_ar_Local = FP_ar(i);
        dataLocal.FP_ar=FP_ar_Local;
        display ( '****************************');
        display ( ['Fingers|Palm Aspect Relation: ' num2str(FP_ar_Local)]);
        %default 1
        dataLocal.L2 = FP_ar_Local*dataLocal.L2;
        dataLocal.L2_T=FP_ar_Local*dataLocal.L2_T;
        dataLocal.LExtremos = FP_ar_Local*dataLocal.LExtremos;
        %%%%%%%%%%%%%%%
        for j=1:length(P_ar)
            P_ar_Local = P_ar(j);
            dataLocal.P_ar=P_ar_Local;
             display ( '   ****************************');
             display ( ['   Palm Aspect Relation: ' num2str(P_ar_Local)]);
             %P_ar por defecto = 4: denominador de h=1/base del triangulo
            Lstep = 0.25*P_ar_Local;
            dataLocal.rrelT = [2*Lstep Lstep 0]'*scaleLocal;
            dataLocal.rrelI = [Lstep Lstep 0]'*scaleLocal;
            dataLocal.rrelM = [0 Lstep 0]'*scaleLocal;
            dataLocal.rrelR = [-Lstep Lstep 0]'*scaleLocal;
            dataLocal.rrelL = [-2*Lstep Lstep 0]'*scaleLocal;
            %%%%%%%%%%%%%%%
            for k = 1:length(grosor)
                grosorLocal = grosor(k);
                display ( '      ****************************');
                display ( ['      Width: ' num2str(grosorLocal)]);
                %default 1
                dataLocal.Rdil= grosorLocal;
                %%%%%%%%%%%%%%%
                dataLocal.usr =[num2str(1000+counter)];
                prof{counter} = dataLocal;
                counter = counter+1;
            end
        end
    end
end
if counter==1
    prof{counter}=data0;
end