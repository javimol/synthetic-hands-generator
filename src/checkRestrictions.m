function pout = checkRestrictions(p)
%CHECKRESTRICTIONS Clamp hand parameters to the joint limits.
%   pout = checkRestrictions(p) clamps every row of p (1x27 parameter
%   vectors, see struct2plain) to the allowed range of each parameter.
%     pplain = [p.phi1_x    p.phi1_y    p.phi1_z    p.T1_x  p.T1_y  p.T1_z]; 
PopInitRange = [0 pi;       0 pi;        0 pi;     1 256;  1 256;  1 256];
%     pplain = [pplain          p.phiT1_x   p.phiT1_z       p.phiT2_x   p.phiT2_z   p.phiT3_z];
PopInitRange  =[PopInitRange;   0 pi/4;     -pi/3 -pi/8;    -pi/8 pi/8; -pi/4 pi/2;     0 pi/2];
%     pplain = [pplain          p.phiI2_x   p.phiI2_z       p.phiI3_x   p.phiI4_x];
PopInitRange  =[PopInitRange;   0 pi/2;     -pi/8 pi/8;     0 pi/2;     0 pi/2];
%     pplain = [pplain          p.phiM2_x   p.phiM2_z       p.phiM3_x       p.phiM4_x];
PopInitRange  =[PopInitRange;   0 pi/2;     -pi/8 pi/8;     0 pi/2;         0 pi/2];
%     pplain = [pplain          p.phiR2_x   p.phiR2_z       p.phiR3_x       p.phiR4_x];
PopInitRange  =[PopInitRange;   0 pi/2;     -pi/8 pi/8;     0 pi/2;         0 pi/2];
%  pplain = [pplain             p.phiL2_x   p.phiL2_z       p.phiL3_x       p.phiL4_x]; 
PopInitRange  =[PopInitRange;   0 pi/2;     -pi/8 pi/8;     0 pi/2;         0 pi/2];
pout=[];
for i=1:size(p,1)
    pLocal = p(i,:);
    poutLocal = pLocal;
    for j=1:length(pLocal)
        if pLocal(j)<PopInitRange(j,1)
            poutLocal(j) = PopInitRange(j,1);
        elseif pLocal(j)>PopInitRange(j,2)
            poutLocal(j) = PopInitRange(j,2);
        end
    end
    pout = [pout;poutLocal];
end