function [r,segmentLength]= interpolPoints(r1,r2,nPoints)
%INTERPOLPOINTS Evenly spaced points on the segment from r1 to r2.
%   r = interpolPoints(r1, r2, nPoints) returns nPoints points strictly
%   inside the segment followed by r2. With nPoints <= 1 only r2 is
%   returned.
v = r2-r1;
L = sqrt(sum(v.^2));
segmentLength = L;
if nPoints<=1
    r = r2;
    return;
end
vNorm = v/L;
resolution = L/(nPoints-1+2);
steps = resolution:resolution:L-resolution/2;
r = [repmat(r1,1,nPoints) + [steps*vNorm(1); steps*vNorm(2); steps*vNorm(3)], r2];
