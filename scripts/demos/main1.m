addpath(fullfile(fileparts(mfilename('fullpath')), '..', '..', 'src'));
%main1
close all;
Rdil = 4;
close all;
semanticData=[];
[p] =generateHandParameters(semanticData);

[r,rS,TMS] = calculatePoints(p);
format = '*';
printPoints(rS,format);
axis([-50 50 -50 50 -50 50 ]);

%encarnación
rRedondeado = round(r);
rmin=min(rRedondeado(:));
rRedondeado=rRedondeado-rmin+4*Rdil;
matrizModel = zeros(max(rRedondeado(:))+8*Rdil,max(rRedondeado(:))+8*Rdil,max(rRedondeado(:))+8*Rdil);


for i=1:size(rRedondeado,2)
    indices = rRedondeado(:,i);
    matrizModel(indices(1),indices(2),indices(3)) = 1;
end
figure
ret = printVoxels(matrizModel,[],[]);


y = dilateBall(matrizModel, Rdil);
y = y/max(y(:));
figure
ret = printVoxels(y,[],[]);

ancho= size(y,1);
alto = size(y,2);
depthImage = uint8(zeros(alto,ancho));
for i = 1:alto
   for j = 1:ancho
       haz = y(i,j,:);
       [iA,iB]=find(haz==1);
       if ~isempty(iA)
           z = max(iB);
       else
           z = 0;
       end           
        depthImage(ancho-j+1,i) = uint8(z);
   end
end
figure;
imshow (depthImage);
