function [Rxyz,Ryzx,Rzyx]= rotationMatrix(phix,phiy,phiz)
%ROTATIONMATRIX 4x4 homogeneous rotation matrices.
%   Rxyz applies the rotations in the order phix, phiy, phiz; Ryzx and
%   Rzyx use the other orders.
alpha = -phix;
Rx = [1 0 0 0 ;0 cos(alpha) -sin(alpha) 0;0 sin(alpha) cos(alpha) 0; 0 0 0 1]';

alpha = -phiy;
Ry = [cos(alpha) 0 sin(alpha) 0; 0 1 0 0;-sin(alpha) 0 cos(alpha) 0; 0 0 0 1]';

alpha = -phiz;
Rz = [cos(alpha) -sin(alpha) 0 0; sin(alpha) cos(alpha) 0 0; 0 0 1 0; 0 0 0 1]';

Rxyz = Rx*Ry*Rz;
Ryzx = Ry*Rz*Rx;
Rzyx = Rz*Ry*Rx;
