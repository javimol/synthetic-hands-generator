function y = dilateBall(m, r)
%DILATEBALL Binary dilation of a 3D volume with a Euclidean ball of radius r.
%   Replaces the original mmdil(m, mmsedisk(r,'3D')) calls from the
%   proprietary SDC Morphology Toolbox. A voxel belongs to the ball when its
%   distance to the centre, rounded to the nearest integer, is <= r.
n = ceil(r);
[x, yy, z] = ndgrid(-n:n, -n:n, -n:n);
b = double(round(sqrt(x.^2 + yy.^2 + z.^2)) <= r);
y = double(convn(double(m ~= 0), b, 'same') > 0);
