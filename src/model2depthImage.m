function depthImage = model2depthImage(y)
alto = size(y,1);
ancho= size(y,2);
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
       %depthImage(ancho-j+1,i) = uint8(z);
       depthImage(i,j) = uint8(z);
   end
end
