function [Rxyz,Ryzx,Rzyx]= rotationMatrix(phix,phiy,phiz)
%Esta hace las rotaciones en el orden phix, phiy y phiz
alpha = -phix;
Rx = [1 0 0 0 ;0 cos(alpha) -sin(alpha) 0;0 sin(alpha) cos(alpha) 0; 0 0 0 1]';

alpha = -phiy;
Ry = [cos(alpha) 0 sin(alpha) 0; 0 1 0 0;-sin(alpha) 0 cos(alpha) 0; 0 0 0 1]';

alpha = -phiz;
Rz = [cos(alpha) -sin(alpha) 0 0; sin(alpha) cos(alpha) 0 0; 0 0 1 0; 0 0 0 1]';

Rxyz = Rx*Ry*Rz;
Ryzx = Ry*Rz*Rx;
Rzyx = Rz*Ry*Rx;
