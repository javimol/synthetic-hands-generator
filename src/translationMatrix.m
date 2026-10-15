function T = translationMatrix(X,Y,Z)
%TRANSLATIONMATRIX 4x4 homogeneous translation matrix.
T = [1 0 0 0; 0 1 0 0; 0 0 1 0; X Y Z 1]';
