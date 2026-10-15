function [r,lsegmento]= interpolPoints(r1,r2,Npoints)
v = r2- r1;
L = sqrt(sum(v.^2));
lsegmento = L;
if Npoints<=1
    r=[r2];
   if Npoints<1
       kk=0;
   end
    return;
end
 
 vNorm = v/ L;
 resolution = L/(Npoints-1+2);
 rInterpol = repmat(r1,1,Npoints);
 rInterpol=rInterpol+ [[resolution:resolution:L-resolution/2]*vNorm(1);[resolution:resolution:L-resolution/2]*vNorm(2);[resolution:resolution:L-resolution/2]*vNorm(3)];
 r=[rInterpol r2];

 
