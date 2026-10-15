function [p,pplain] =generateHandParameters(semanticData)
%GENERATEHANDPARAMETERS Joint parameters of the postures in the dictionary.
%   [p, pplain] = generateHandParameters(ids) returns a cell array with the
%   parameter struct of each posture id, and the same parameters as rows of
%   a matrix (see struct2plain). With ids = [] it returns a single example
%   pose as a struct.
%
%   Posture ids:
%     1-8      One, Two, Three, Four, Five, Ok, Stop, Fist
%     11, 12   OkLeft, OkRight (with 1-5, 7 and 8: Molina et al. 2011)
%     101-104  miscellaneous postures m1-m4
%     201-205  Soutschek et al. (2008): 201 = Stop (as 7), 202 = Jedi,
%              203 = Two (as 2), 204 = Fist (as 8), 205 = Ok, palm right
%     301-312  Kollorz et al. (2008), postures A-L
%     401-427  Spanish Sign Language alphabet a-z in order, with n-tilde:
%              401 = a, 414 = n, 415 = n-tilde, 427 = z
%
%   Parameters (radians, translation in voxels):
%     phi1_x, phi1_y, phi1_z, T1_x, T1_y, T1_z   global rotation and position
%     phiT1_x, phiT1_z, phiT2_x, phiT2_z, phiT3_z thumb joints
%     phi<F>2_x, phi<F>2_z, phi<F>3_x, phi<F>4_x  joints of finger F = I, M, R, L
if isempty(semanticData)
    %Global
    p.phi1_x= pi/4; p.phi1_y= 0;p.phi1_z= 0; p.T1_x= 0;p.T1_y= 0;p.T1_z= 0;
    %Thumb
    p.phiT1_x= 0;p.phiT1_z= -pi/4;p.phiT2_x= 0;p.phiT2_z= 0;p.phiT3_z= 0;
    %Index
    p.phiI2_x= 0;p.phiI2_z= 0;p.phiI3_x= 0;p.phiI4_x= 0;
    %Middle
    p.phiM2_x= pi/5;p.phiM2_z= 0;p.phiM3_x= 0;p.phiM4_x= 0;
    %Ring
    p.phiR2_x= pi/4;p.phiR2_z= 0;p.phiR3_x= 0;p.phiR4_x= 0;
    %Little
    p.phiL2_x= pi/3;p.phiL2_z= 0;p.phiL3_x= 0;p.phiL4_x= 0;
    
    pplain = [p.phi1_x p.phi1_y p.phi1_z p.T1_x p.T1_y p.T1_z];
    pplain = [pplain p.phiT1_x p.phiT1_z p.phiT2_x p.phiT2_z p.phiT3_z];
    pplain = [pplain p.phiI2_x p.phiI2_z p.phiI3_x p.phiI4_x];
    pplain = [pplain p.phiM2_x p.phiM2_z p.phiM3_x p.phiM4_x];
    pplain = [pplain p.phiR2_x p.phiR2_z p.phiR3_x p.phiR4_x];
    pplain = [pplain p.phiL2_x p.phiL2_z p.phiL3_x p.phiL4_x];
    return;
end
             %Splay angle of each finger
                    phiI=-pi/18;
                    phiM=0;
                    phiR=pi/18;
                    phiL=pi/9;
                    
for i=1:length(semanticData)
    id = semanticData(i);
    switch id
% 1: Enumerate One---
% 2: Enumerate Two---
% 3: Enumerate Three---
% 4: Enumerate Four---
% 5: Enumerate Five---
% 6: Ok---
% 7: Stop---
% 8: Fist---
        case {1}
            %Global
            pLocal.phi1_x= 0; pLocal.phi1_y= 0;pLocal.phi1_z= 0; pLocal.T1_x= 0;pLocal.T1_y= 0;pLocal.T1_z= 0;
            %Thumb
            pLocal.phiT1_x= pi/4;pLocal.phiT1_z= -pi/8;pLocal.phiT2_x= 0;pLocal.phiT2_z= pi/4;pLocal.phiT3_z= pi/4;
            %Index
            pLocal.phiI2_x= 0;pLocal.phiI2_z= 0;pLocal.phiI3_x= 0;pLocal.phiI4_x= 0;
            %Middle
            pLocal.phiM2_x= pi/2;pLocal.phiM2_z= 0;pLocal.phiM3_x= pi/2;pLocal.phiM4_x= pi/2;
            %Ring
            pLocal.phiR2_x= pi/2;pLocal.phiR2_z= 0;pLocal.phiR3_x= pi/2;pLocal.phiR4_x= pi/2;
            %Little
            pLocal.phiL2_x= pi/2;pLocal.phiL2_z= 0;pLocal.phiL3_x=pi/2;pLocal.phiL4_x= pi/2;
        case {2,203,422,423}
            %Global
            pLocal.phi1_x= 0; pLocal.phi1_y= 0;pLocal.phi1_z= 0; pLocal.T1_x= 0;pLocal.T1_y= 0;pLocal.T1_z= 0;
            %Thumb
            pLocal.phiT1_x= pi/4;pLocal.phiT1_z= 0;pLocal.phiT2_x= 0;pLocal.phiT2_z= pi/4;pLocal.phiT3_z= pi/4;
            %Index
            pLocal.phiI2_x= 0;pLocal.phiI2_z= 0;pLocal.phiI3_x= 0;pLocal.phiI4_x= 0;
            %Middle
            pLocal.phiM2_x= 0;pLocal.phiM2_z= pi/12;pLocal.phiM3_x= 0;pLocal.phiM4_x= 0;
            %Ring
            pLocal.phiR2_x= pi/2;pLocal.phiR2_z= 0;pLocal.phiR3_x= pi/2;pLocal.phiR4_x= pi/2;
            %Little
            pLocal.phiL2_x= pi/2;pLocal.phiL2_z= 0;pLocal.phiL3_x=pi/2;pLocal.phiL4_x= pi/2;            
        case {3}
           	%Global
            pLocal.phi1_x= 0; pLocal.phi1_y= 0;pLocal.phi1_z= 0; pLocal.T1_x= 0;pLocal.T1_y= 0;pLocal.T1_z= 0;
            %Thumb
            pLocal.phiT1_x= 0;pLocal.phiT1_z= -pi/4;pLocal.phiT2_x= 0;pLocal.phiT2_z= 0;pLocal.phiT3_z= 0;
            %Index
            pLocal.phiI2_x= 0;pLocal.phiI2_z= 0;pLocal.phiI3_x= 0;pLocal.phiI4_x= 0;
            %Middle
            pLocal.phiM2_x= 0;pLocal.phiM2_z= pi/12;pLocal.phiM3_x= 0;pLocal.phiM4_x= 0;
            %Ring
            pLocal.phiR2_x= pi/2;pLocal.phiR2_z= 0;pLocal.phiR3_x= pi/2;pLocal.phiR4_x= pi/2;
            %Little
            pLocal.phiL2_x= pi/2;pLocal.phiL2_z= 0;pLocal.phiL3_x=pi/2;pLocal.phiL4_x= pi/2;
            
        case 4
           	%Global
            pLocal.phi1_x= 0; pLocal.phi1_y= 0;pLocal.phi1_z= 0; pLocal.T1_x= 0;pLocal.T1_y= 0;pLocal.T1_z= 0;
            %Thumb
            pLocal.phiT1_x= pi/4;pLocal.phiT1_z= pi/16;pLocal.phiT2_x= 0;pLocal.phiT2_z= pi/4;pLocal.phiT3_z= pi/4;
            %Index
            pLocal.phiI2_x= 0;pLocal.phiI2_z= 0;pLocal.phiI3_x= 0;pLocal.phiI4_x= 0;
            %Middle
            pLocal.phiM2_x= 0;pLocal.phiM2_z= 0;pLocal.phiM3_x= 0;pLocal.phiM4_x= 0;
            %Ring
            pLocal.phiR2_x= 0;pLocal.phiR2_z= pi/32;pLocal.phiR3_x= 0;pLocal.phiR4_x= 0;
            %Little
            pLocal.phiL2_x= 0;pLocal.phiL2_z= pi/20;pLocal.phiL3_x=0;pLocal.phiL4_x= 0;
            
        case 5
           	%Global
            pLocal.phi1_x= 0; pLocal.phi1_y= 0;pLocal.phi1_z= 0; pLocal.T1_x= 0;pLocal.T1_y= 0;pLocal.T1_z= 0;
            %Thumb
            pLocal.phiT1_x= 0;pLocal.phiT1_z= -pi/4;pLocal.phiT2_x= 0;pLocal.phiT2_z= 0;pLocal.phiT3_z= 0;
            %Index
            pLocal.phiI2_x= 0;pLocal.phiI2_z= 0;pLocal.phiI3_x= 0;pLocal.phiI4_x= 0;
            %Middle
            pLocal.phiM2_x= 0;pLocal.phiM2_z= 0;pLocal.phiM3_x= 0;pLocal.phiM4_x= 0;
            %Ring
            pLocal.phiR2_x= 0;pLocal.phiR2_z= pi/32;pLocal.phiR3_x= 0;pLocal.phiR4_x= 0;
            %Little
            pLocal.phiL2_x= 0;pLocal.phiL2_z= pi/20;pLocal.phiL3_x=0;pLocal.phiL4_x= 0;
        case 6
            %Global
            pLocal.phi1_x= pi/2; pLocal.phi1_y= pi/2;pLocal.phi1_z=0 ; pLocal.T1_x= 0;pLocal.T1_y= 0;pLocal.T1_z= 0;
            %Thumb
            pLocal.phiT1_x= 0;pLocal.phiT1_z= -pi/4;pLocal.phiT2_x= 0;pLocal.phiT2_z= 0;pLocal.phiT3_z= 0;
            %Index
            pLocal.phiI2_x= pi/2;pLocal.phiI2_z= 0;pLocal.phiI3_x= pi/2;pLocal.phiI4_x= pi/2;
            %Middle
            pLocal.phiM2_x= pi/2;pLocal.phiM2_z= 0;pLocal.phiM3_x= pi/2;pLocal.phiM4_x= pi/2;
            %Ring
            pLocal.phiR2_x= pi/2;pLocal.phiR2_z= 0;pLocal.phiR3_x= pi/2;pLocal.phiR4_x= pi/2;
            %Little
            pLocal.phiL2_x= pi/2;pLocal.phiL2_z= 0;pLocal.phiL3_x=pi/2;pLocal.phiL4_x= pi/2;
         case {7,201}
            %Global
            pLocal.phi1_x= 0; pLocal.phi1_y= 0;pLocal.phi1_z=0 ; pLocal.T1_x= 0;pLocal.T1_y= 0;pLocal.T1_z= 0;
            %Thumb
            pLocal.phiT1_x= 0;pLocal.phiT1_z= -pi/4;pLocal.phiT2_x=0;pLocal.phiT2_z= pi/4;pLocal.phiT3_z= 0;
            %Index
            pLocal.phiI2_x= 0;pLocal.phiI2_z= -phiI ;pLocal.phiI3_x=0;pLocal.phiI4_x= 0;
            %Middle
            pLocal.phiM2_x= 0;pLocal.phiM2_z= -phiM;pLocal.phiM3_x=0;pLocal.phiM4_x= 0;
            %Ring
            pLocal.phiR2_x= 0;pLocal.phiR2_z= -phiR;pLocal.phiR3_x=0;pLocal.phiR4_x= 0;
            %Little
            pLocal.phiL2_x= 0;pLocal.phiL2_z= -phiL;pLocal.phiL3_x=0;pLocal.phiL4_x= 0;
        case {8,204}
            %Global
            pLocal.phi1_x= pi/2; pLocal.phi1_y= 0;pLocal.phi1_z= 0; pLocal.T1_x= 0;pLocal.T1_y= 0;pLocal.T1_z= 0;
            %Thumb
            pLocal.phiT1_x= pi/4;pLocal.phiT1_z= -pi/8;pLocal.phiT2_x= 0;pLocal.phiT2_z= pi/4;pLocal.phiT3_z= pi/4;
            %Index
            pLocal.phiI2_x= pi/2;pLocal.phiI2_z= 0;pLocal.phiI3_x= pi/2;pLocal.phiI4_x= pi/2;
            %Middle
            pLocal.phiM2_x= pi/2;pLocal.phiM2_z= 0;pLocal.phiM3_x= pi/2;pLocal.phiM4_x= pi/2;
            %Ring
            pLocal.phiR2_x= pi/2;pLocal.phiR2_z= 0;pLocal.phiR3_x= pi/2;pLocal.phiR4_x= pi/2;
            %Little
            pLocal.phiL2_x= pi/2;pLocal.phiL2_z= 0;pLocal.phiL3_x=pi/2;pLocal.phiL4_x= pi/2;
        case {11}
            %Global
            pLocal.phi1_x= pi/2; pLocal.phi1_y= 0;pLocal.phi1_z= 0; pLocal.T1_x= 0;pLocal.T1_y= 0;pLocal.T1_z= 0;
            %Thumb
            pLocal.phiT1_x= 0;pLocal.phiT1_z= -pi/4;pLocal.phiT2_x= 0;pLocal.phiT2_z= 0;pLocal.phiT3_z= 0;
            %Index
            pLocal.phiI2_x= pi/2;pLocal.phiI2_z= 0;pLocal.phiI3_x= pi/2;pLocal.phiI4_x= pi/2;
            %Middle
            pLocal.phiM2_x= pi/2;pLocal.phiM2_z= 0;pLocal.phiM3_x= pi/2;pLocal.phiM4_x= pi/2;
            %Ring
            pLocal.phiR2_x= pi/2;pLocal.phiR2_z= 0;pLocal.phiR3_x= pi/2;pLocal.phiR4_x= pi/2;
            %Little
            pLocal.phiL2_x= pi/2;pLocal.phiL2_z= 0;pLocal.phiL3_x=pi/2;pLocal.phiL4_x= pi/2;
         case {12}
            %Global
            pLocal.phi1_x= pi/2; pLocal.phi1_y= pi;pLocal.phi1_z= 0; pLocal.T1_x= 0;pLocal.T1_y= 0;pLocal.T1_z= 0;
            %Thumb
            pLocal.phiT1_x= 0;pLocal.phiT1_z= -pi/4;pLocal.phiT2_x= 0;pLocal.phiT2_z= 0;pLocal.phiT3_z= 0;
            %Index
            pLocal.phiI2_x= pi/2;pLocal.phiI2_z= 0;pLocal.phiI3_x= pi/2;pLocal.phiI4_x= pi/2;
            %Middle
            pLocal.phiM2_x= pi/2;pLocal.phiM2_z= 0;pLocal.phiM3_x= pi/2;pLocal.phiM4_x= pi/2;
            %Ring
            pLocal.phiR2_x= pi/2;pLocal.phiR2_z= 0;pLocal.phiR3_x= pi/2;pLocal.phiR4_x= pi/2;
            %Little
            pLocal.phiL2_x= pi/2;pLocal.phiL2_z= 0;pLocal.phiL3_x=pi/2;pLocal.phiL4_x= pi/2;
          case {101}
            %Global
            pLocal.phi1_x= 0; pLocal.phi1_y= 0;pLocal.phi1_z= 0; pLocal.T1_x= 0;pLocal.T1_y= 0;pLocal.T1_z= 0;
            %Thumb
            pLocal.phiT1_x= 0;pLocal.phiT1_z= -pi/4;pLocal.phiT2_x= 0;pLocal.phiT2_z= 0;pLocal.phiT3_z= 0;
            %Index
            pLocal.phiI2_x= 0;pLocal.phiI2_z= 0;pLocal.phiI3_x= 0;pLocal.phiI4_x= 0;
            %Middle
            pLocal.phiM2_x= pi/2;pLocal.phiM2_z= 0;pLocal.phiM3_x= pi/2;pLocal.phiM4_x= pi/2;
            %Ring
            pLocal.phiR2_x= pi/2;pLocal.phiR2_z= 0;pLocal.phiR3_x= pi/2;pLocal.phiR4_x= pi/2;
           %Little
            pLocal.phiL2_x= 0;pLocal.phiL2_z= pi/20;pLocal.phiL3_x=0;pLocal.phiL4_x= 0;
         case {102}
            %Global
            pLocal.phi1_x= 0; pLocal.phi1_y= pi;pLocal.phi1_z= 0; pLocal.T1_x= 0;pLocal.T1_y= 0;pLocal.T1_z= 0;
            %Thumb
            pLocal.phiT1_x= pi/4;pLocal.phiT1_z= -pi/8;pLocal.phiT2_x= 0;pLocal.phiT2_z= pi/4;pLocal.phiT3_z= pi/4;
            %Index
            pLocal.phiI2_x= pi/2;pLocal.phiI2_z= 0;pLocal.phiI3_x= pi/2;pLocal.phiI4_x= pi/2;
            %Middle
            pLocal.phiM2_x= 0;pLocal.phiM2_z= 0;pLocal.phiM3_x= 0;pLocal.phiM4_x= 0;
            %Ring
            pLocal.phiR2_x= pi/2;pLocal.phiR2_z= 0;pLocal.phiR3_x= pi/2;pLocal.phiR4_x= pi/2;
            %Little
            pLocal.phiL2_x= pi/2;pLocal.phiL2_z= 0;pLocal.phiL3_x=pi/2;pLocal.phiL4_x= pi/2;
          case 103
            %Global
            pLocal.phi1_x= pi/2; pLocal.phi1_y= pi/2;pLocal.phi1_z=0 ; pLocal.T1_x= 0;pLocal.T1_y= 0;pLocal.T1_z= 0;
            %Thumb
            pLocal.phiT1_x= 0;pLocal.phiT1_z= -pi/4;pLocal.phiT2_x= 0;pLocal.phiT2_z= 0;pLocal.phiT3_z= 0;
            %Index
            pLocal.phiI2_x= 0;pLocal.phiI2_z= 0;pLocal.phiI3_x= 0;pLocal.phiI4_x= 0;
            %Middle
            pLocal.phiM2_x= pi/2;pLocal.phiM2_z= 0;pLocal.phiM3_x= pi/2;pLocal.phiM4_x= pi/2;
            %Ring
            pLocal.phiR2_x= pi/2;pLocal.phiR2_z= 0;pLocal.phiR3_x= pi/2;pLocal.phiR4_x= pi/2;
            %Little
            pLocal.phiL2_x= pi/2;pLocal.phiL2_z= 0;pLocal.phiL3_x=pi/2;pLocal.phiL4_x= pi/2;
          case 104
            %Global
            pLocal.phi1_x= pi/2; pLocal.phi1_y= pi/2;pLocal.phi1_z=0 ; pLocal.T1_x= 0;pLocal.T1_y= 0;pLocal.T1_z= 0;
            %Thumb
            pLocal.phiT1_x= pi/4;pLocal.phiT1_z= -pi/8;pLocal.phiT2_x= 0;pLocal.phiT2_z= pi/4;pLocal.phiT3_z= pi/4;
            %Index
            pLocal.phiI2_x= 0;pLocal.phiI2_z= 0;pLocal.phiI3_x= 0;pLocal.phiI4_x= 0;
            %Middle
            pLocal.phiM2_x= pi/2;pLocal.phiM2_z= 0;pLocal.phiM3_x= pi/2;pLocal.phiM4_x= pi/2;
            %Ring
            pLocal.phiR2_x= pi/2;pLocal.phiR2_z= 0;pLocal.phiR3_x= pi/2;pLocal.phiR4_x= pi/2;
            %Little
            pLocal.phiL2_x= pi/2;pLocal.phiL2_z= 0;pLocal.phiL3_x=pi/2;pLocal.phiL4_x= pi/2;
        case 202
            %Global
            pLocal.phi1_x= 0; pLocal.phi1_y= 0;pLocal.phi1_z= 0; pLocal.T1_x= 0;pLocal.T1_y= 0;pLocal.T1_z= 0;
            %Thumb
            pLocal.phiT1_x= pi/4;pLocal.phiT1_z= -pi/8;pLocal.phiT2_x= 0;pLocal.phiT2_z= pi/4;pLocal.phiT3_z= pi/4;
            %Index
            pLocal.phiI2_x= 0;pLocal.phiI2_z= pi/18;pLocal.phiI3_x= 0;pLocal.phiI4_x= 0;
            %Middle
            pLocal.phiM2_x= 0;pLocal.phiM2_z= 0;pLocal.phiM3_x= 0;pLocal.phiM4_x= 0;
            %Ring
            pLocal.phiR2_x= pi/2;pLocal.phiR2_z= 0;pLocal.phiR3_x= pi/2;pLocal.phiR4_x= pi/2;
            %Little
            pLocal.phiL2_x= pi/2;pLocal.phiL2_z= 0;pLocal.phiL3_x=pi/2;pLocal.phiL4_x= pi/2;
       case {205,306}
            %Global
            pLocal.phi1_x= 0; pLocal.phi1_y= 0;pLocal.phi1_z=0 ; pLocal.T1_x= 0;pLocal.T1_y= 0;pLocal.T1_z= 0;
            %Thumb
            pLocal.phiT1_x= 0;pLocal.phiT1_z= -pi/4;pLocal.phiT2_x= 0;pLocal.phiT2_z= 0;pLocal.phiT3_z= 0;
            %Index
            pLocal.phiI2_x= pi/2;pLocal.phiI2_z= 0;pLocal.phiI3_x= pi/2;pLocal.phiI4_x= pi/2;
            %Middle
            pLocal.phiM2_x= pi/2;pLocal.phiM2_z= 0;pLocal.phiM3_x= pi/2;pLocal.phiM4_x= pi/2;
            %Ring
            pLocal.phiR2_x= pi/2;pLocal.phiR2_z= 0;pLocal.phiR3_x= pi/2;pLocal.phiR4_x= pi/2;
            %Little
            pLocal.phiL2_x= pi/2;pLocal.phiL2_z= 0;pLocal.phiL3_x=pi/2;pLocal.phiL4_x= pi/2;
       case {301}
             %Splay angle of each finger
                    phiI=-pi/18;
                    phiM=0;
                    phiR=pi/18;
                    phiL=pi/9;
            %Global
            pLocal.phi1_x= 0; pLocal.phi1_y= pi;pLocal.phi1_z=0 ; pLocal.T1_x= 0;pLocal.T1_y= 0;pLocal.T1_z= 0;
            %Thumb
            pLocal.phiT1_x= 0;pLocal.phiT1_z= -pi/4;pLocal.phiT2_x=0;pLocal.phiT2_z= pi/4;pLocal.phiT3_z= 0;
            %Index
            pLocal.phiI2_x= 0;pLocal.phiI2_z= -phiI ;pLocal.phiI3_x=0;pLocal.phiI4_x= 0;
            %Middle
            pLocal.phiM2_x= 0;pLocal.phiM2_z= -phiM;pLocal.phiM3_x=0;pLocal.phiM4_x= 0;
            %Ring
            pLocal.phiR2_x= 0;pLocal.phiR2_z= -phiR;pLocal.phiR3_x=0;pLocal.phiR4_x= 0;
            %Little
            pLocal.phiL2_x= 0;pLocal.phiL2_z= -phiL;pLocal.phiL3_x=0;pLocal.phiL4_x= 0;
        case {302}
            %Global
            pLocal.phi1_x= 0; pLocal.phi1_y= pi;pLocal.phi1_z= 0; pLocal.T1_x= 0;pLocal.T1_y= 0;pLocal.T1_z= 0;
            %Thumb
            pLocal.phiT1_x= pi/4;pLocal.phiT1_z= 0;pLocal.phiT2_x= 0;pLocal.phiT2_z= pi/4;pLocal.phiT3_z= pi/4;
            %Index
            pLocal.phiI2_x= 0;pLocal.phiI2_z= 0;pLocal.phiI3_x= 0;pLocal.phiI4_x= 0;
            %Middle
            pLocal.phiM2_x= 0;pLocal.phiM2_z= pi/12;pLocal.phiM3_x= 0;pLocal.phiM4_x= 0;
            %Ring
            pLocal.phiR2_x= pi/2;pLocal.phiR2_z= 0;pLocal.phiR3_x= pi/2;pLocal.phiR4_x= pi/2;
            %Little
            pLocal.phiL2_x= pi/2;pLocal.phiL2_z= 0;pLocal.phiL3_x=pi/2;pLocal.phiL4_x= pi/2;
        case {303, 403}
           %Global
            pLocal.phi1_x= 0; pLocal.phi1_y= pi/2;pLocal.phi1_z= 0; pLocal.T1_x= 0;pLocal.T1_y= 0;pLocal.T1_z= 0;
            %Thumb
            pLocal.phiT1_x= pi/3;pLocal.phiT1_z= 0;pLocal.phiT2_x= 0;pLocal.phiT2_z= pi/6;pLocal.phiT3_z= 0;
            %Index
            pLocal.phiI2_x= 0;pLocal.phiI2_z= -phiI ;pLocal.phiI3_x=pi/3;pLocal.phiI4_x= pi/6;
            %Middle
            pLocal.phiM2_x= 0;pLocal.phiM2_z= -phiM;pLocal.phiM3_x=pi/3;pLocal.phiM4_x= pi/6;
            %Ring
            pLocal.phiR2_x= 0;pLocal.phiR2_z= -phiR;pLocal.phiR3_x=pi/3;pLocal.phiR4_x= pi/6;
            %Little
            pLocal.phiL2_x= 0;pLocal.phiL2_z= -phiL;pLocal.phiL3_x=pi/12;pLocal.phiL4_x= pi/12;
        case {304}
            %Global
            pLocal.phi1_x= 0; pLocal.phi1_y= pi;pLocal.phi1_z= 0; pLocal.T1_x= 0;pLocal.T1_y= 0;pLocal.T1_z= 0;
            %Thumb
            pLocal.phiT1_x= 0;pLocal.phiT1_z= -pi/3;pLocal.phiT2_x= 0;pLocal.phiT2_z= -pi/8;pLocal.phiT3_z= 0;
            %Index
            pLocal.phiI2_x= 0;pLocal.phiI2_z= -phiI;pLocal.phiI3_x= 0;pLocal.phiI4_x= 0;
            %Middle
            pLocal.phiM2_x= pi/2;pLocal.phiM2_z= 0;pLocal.phiM3_x= pi/2;pLocal.phiM4_x= pi/2;
            %Ring
            pLocal.phiR2_x= pi/2;pLocal.phiR2_z= 0;pLocal.phiR3_x= pi/2;pLocal.phiR4_x= pi/2;
            %Little
            pLocal.phiL2_x= pi/2;pLocal.phiL2_z= 0;pLocal.phiL3_x=pi/2;pLocal.phiL4_x= pi/2;
        case {305}
            %Global
            pLocal.phi1_x= 0; pLocal.phi1_y= pi;pLocal.phi1_z=0 ; pLocal.T1_x= 0;pLocal.T1_y= 0;pLocal.T1_z= 0;
            %Thumb
            pLocal.phiT1_x= 0;pLocal.phiT1_z= -pi/4;pLocal.phiT2_x= 0;pLocal.phiT2_z= 0;pLocal.phiT3_z= 0;
            %Index
            pLocal.phiI2_x= pi/2;pLocal.phiI2_z= 0;pLocal.phiI3_x= pi/2;pLocal.phiI4_x= pi/2;
            %Middle
            pLocal.phiM2_x= pi/2;pLocal.phiM2_z= 0;pLocal.phiM3_x= pi/2;pLocal.phiM4_x= pi/2;
            %Ring
            pLocal.phiR2_x= pi/2;pLocal.phiR2_z= 0;pLocal.phiR3_x= pi/2;pLocal.phiR4_x= pi/2;
            %Little
            pLocal.phiL2_x= pi/2;pLocal.phiL2_z= 0;pLocal.phiL3_x=pi/2;pLocal.phiL4_x= pi/2;
        case {307}
            %Global
            pLocal.phi1_x= 0; pLocal.phi1_y= pi;pLocal.phi1_z= 0; pLocal.T1_x= 0;pLocal.T1_y= 0;pLocal.T1_z= 0;
            %Thumb
            pLocal.phiT1_x= pi/4;pLocal.phiT1_z= -pi/8;pLocal.phiT2_x= 0;pLocal.phiT2_z= pi/4;pLocal.phiT3_z= pi/4;
            %Index
            pLocal.phiI2_x= pi/2;pLocal.phiI2_z= 0;pLocal.phiI3_x= pi/2;pLocal.phiI4_x= pi/2;
            %Middle
            pLocal.phiM2_x= pi/2;pLocal.phiM2_z= 0;pLocal.phiM3_x= pi/2;pLocal.phiM4_x= pi/2;
            %Ring
            pLocal.phiR2_x= pi/2;pLocal.phiR2_z= 0;pLocal.phiR3_x= pi/2;pLocal.phiR4_x= pi/2;
            %Little
            pLocal.phiL2_x= pi/2;pLocal.phiL2_z= 0;pLocal.phiL3_x=pi/2;pLocal.phiL4_x= pi/2;
        case 308
            %Global
            pLocal.phi1_x= 0; pLocal.phi1_y= pi;pLocal.phi1_z= 0; pLocal.T1_x= 0;pLocal.T1_y= 0;pLocal.T1_z= 0;
            %Thumb
            pLocal.phiT1_x= pi/4;pLocal.phiT1_z= -pi/8;pLocal.phiT2_x= 0;pLocal.phiT2_z= pi/4;pLocal.phiT3_z= pi/4;
            %Index
            pLocal.phiI2_x= 0;pLocal.phiI2_z= -phiI;pLocal.phiI3_x= 0;pLocal.phiI4_x= 0;
            %Middle
            pLocal.phiM2_x= pi/2;pLocal.phiM2_z= 0;pLocal.phiM3_x= pi/2;pLocal.phiM4_x= pi/2;
            %Ring
            pLocal.phiR2_x= pi/2;pLocal.phiR2_z= 0;pLocal.phiR3_x= pi/2;pLocal.phiR4_x= pi/2;
            %Little
            pLocal.phiL2_x= pi/2;pLocal.phiL2_z= 0;pLocal.phiL3_x=pi/2;pLocal.phiL4_x= pi/2;
        case 309
            %Global
            pLocal.phi1_x= 0; pLocal.phi1_y= pi/2;pLocal.phi1_z=0 ; pLocal.T1_x= 0;pLocal.T1_y= 0;pLocal.T1_z= 0;
            %Thumb
            pLocal.phiT1_x= 0;pLocal.phiT1_z= -pi/4;pLocal.phiT2_x=0;pLocal.phiT2_z= pi/4;pLocal.phiT3_z= 0;
            %Index
            pLocal.phiI2_x= 0;pLocal.phiI2_z= -phiI ;pLocal.phiI3_x=0;pLocal.phiI4_x= 0;
            %Middle
            pLocal.phiM2_x= 0;pLocal.phiM2_z= -phiM;pLocal.phiM3_x=0;pLocal.phiM4_x= 0;
            %Ring
            pLocal.phiR2_x= 0;pLocal.phiR2_z= -phiR;pLocal.phiR3_x=0;pLocal.phiR4_x= 0;
            %Little
            pLocal.phiL2_x= 0;pLocal.phiL2_z= -phiL;pLocal.phiL3_x=0;pLocal.phiL4_x= 0;
        case 310
            %Global
            pLocal.phi1_x= 0; pLocal.phi1_y= pi;pLocal.phi1_z=0 ; pLocal.T1_x= 0;pLocal.T1_y= 0;pLocal.T1_z= 0;
            %Thumb
            pLocal.phiT1_x= 0;pLocal.phiT1_z= -pi/8;pLocal.phiT2_x=0;pLocal.phiT2_z= pi/8;pLocal.phiT3_z= 0;
            %Index
            pLocal.phiI2_x= 0;pLocal.phiI2_z= -phiI ;pLocal.phiI3_x=0;pLocal.phiI4_x= 0;
            %Middle
            pLocal.phiM2_x= 0;pLocal.phiM2_z= -phiM;pLocal.phiM3_x=0;pLocal.phiM4_x= 0;
            %Ring
            pLocal.phiR2_x= 0;pLocal.phiR2_z= -phiR;pLocal.phiR3_x=0;pLocal.phiR4_x= 0;
            %Little
            pLocal.phiL2_x= 0;pLocal.phiL2_z= -phiL;pLocal.phiL3_x=0;pLocal.phiL4_x= 0;
        case 311
            %Global
            pLocal.phi1_x= 0; pLocal.phi1_y= pi;pLocal.phi1_z= 0; pLocal.T1_x= 0;pLocal.T1_y= 0;pLocal.T1_z= 0;
            %Thumb
            pLocal.phiT1_x= pi/4;pLocal.phiT1_z= -pi/8;pLocal.phiT2_x= 0;pLocal.phiT2_z= pi/4;pLocal.phiT3_z= pi/4;
            %Index
            pLocal.phiI2_x= pi/2;pLocal.phiI2_z= 0;pLocal.phiI3_x= pi/2;pLocal.phiI4_x= pi/2;
            %Middle
            pLocal.phiM2_x= 0;pLocal.phiM2_z= 0;pLocal.phiM3_x= 0;pLocal.phiM4_x= 0;
            %Ring
            pLocal.phiR2_x= pi/2;pLocal.phiR2_z= 0;pLocal.phiR3_x= pi/2;pLocal.phiR4_x= pi/2;
            %Little
            pLocal.phiL2_x= pi/2;pLocal.phiL2_z= 0;pLocal.phiL3_x=pi/2;pLocal.phiL4_x= pi/2;
        case 312
            %Global
            pLocal.phi1_x= 3*pi/4; pLocal.phi1_y= pi/2;pLocal.phi1_z=0 ; pLocal.T1_x= 0;pLocal.T1_y= 0;pLocal.T1_z= 0;
            %Thumb
            pLocal.phiT1_x= 0;pLocal.phiT1_z= -pi/4;pLocal.phiT2_x= 0;pLocal.phiT2_z= 0;pLocal.phiT3_z= 0;
            %Index
            pLocal.phiI2_x= pi/2;pLocal.phiI2_z= 0;pLocal.phiI3_x= pi/2;pLocal.phiI4_x= pi/2;
            %Middle
            pLocal.phiM2_x= pi/2;pLocal.phiM2_z= 0;pLocal.phiM3_x= pi/2;pLocal.phiM4_x= pi/2;
            %Ring
            pLocal.phiR2_x= pi/2;pLocal.phiR2_z= 0;pLocal.phiR3_x= pi/2;pLocal.phiR4_x= pi/2;
            %Little
            pLocal.phiL2_x= pi/2;pLocal.phiL2_z= 0;pLocal.phiL3_x=pi/2;pLocal.phiL4_x= pi/2;
        case {401}%a
            %Global
            pLocal.phi1_x= 0; pLocal.phi1_y= 0;pLocal.phi1_z= 0; pLocal.T1_x= 0;pLocal.T1_y= 0;pLocal.T1_z= 0;
            %Thumb
            pLocal.phiT1_x= pi/4;pLocal.phiT1_z= -pi/8;pLocal.phiT2_x= 0;pLocal.phiT2_z= pi/4;pLocal.phiT3_z= pi/4;
            %Index
            pLocal.phiI2_x= pi/2;pLocal.phiI2_z= 0;pLocal.phiI3_x= pi/2;pLocal.phiI4_x= pi/2;
            %Middle
            pLocal.phiM2_x= pi/2;pLocal.phiM2_z= 0;pLocal.phiM3_x= pi/2;pLocal.phiM4_x= pi/2;
            %Ring
            pLocal.phiR2_x= pi/2;pLocal.phiR2_z= 0;pLocal.phiR3_x= pi/2;pLocal.phiR4_x= pi/2;
            %Little
            pLocal.phiL2_x= pi/2;pLocal.phiL2_z= 0;pLocal.phiL3_x=pi/2;pLocal.phiL4_x= pi/2;
        case {402}%b
            %Global
            pLocal.phi1_x= 0; pLocal.phi1_y=pi;pLocal.phi1_z=pi/2 ; pLocal.T1_x= 0;pLocal.T1_y= 0;pLocal.T1_z= 0;
            %Thumb
            pLocal.phiT1_x= 0;pLocal.phiT1_z= -pi/4;pLocal.phiT2_x=0;pLocal.phiT2_z= pi/4;pLocal.phiT3_z= 0;
            %Index
            pLocal.phiI2_x= 0;pLocal.phiI2_z= -phiI ;pLocal.phiI3_x=0;pLocal.phiI4_x= 0;
            %Middle
            pLocal.phiM2_x= 0;pLocal.phiM2_z= -phiM;pLocal.phiM3_x=0;pLocal.phiM4_x= 0;
            %Ring
            pLocal.phiR2_x= 0;pLocal.phiR2_z= -phiR;pLocal.phiR3_x=0;pLocal.phiR4_x= 0;
            %Little
            pLocal.phiL2_x= 0;pLocal.phiL2_z= -phiL;pLocal.phiL3_x=0;pLocal.phiL4_x= 0;
%          case {403}%c
%             %Global
%             pLocal.phi1_x= 0; pLocal.phi1_y= pi/2;pLocal.phi1_z=0 ; pLocal.T1_x= 0;pLocal.T1_y= 0;pLocal.T1_z= 0;
%             %Thumb
%             pLocal.phiT1_x= pi/2;pLocal.phiT1_z= -pi/8;pLocal.phiT2_x= -pi/8;pLocal.phiT2_z= 0;pLocal.phiT3_z= 0;
%             %Index
%             pLocal.phiI2_x= pi/8;pLocal.phiI2_z= -phiI ;pLocal.phiI3_x=pi/8;pLocal.phiI4_x=pi/8;
%             %Middle
%             pLocal.phiM2_x= pi/8;pLocal.phiM2_z= -phiM;pLocal.phiM3_x=pi/8;pLocal.phiM4_x= pi/8;
%             %Ring
%             pLocal.phiR2_x= pi/8;pLocal.phiR2_z= -phiR;pLocal.phiR3_x=pi/8;pLocal.phiR4_x=pi/8;
%             %Little
%             pLocal.phiL2_x= pi/16;pLocal.phiL2_z= -phiL;pLocal.phiL3_x=pi/8;pLocal.phiL4_x= pi/8;
        case {404}%d
            %Global
            pLocal.phi1_x= 0; pLocal.phi1_y= pi/4;pLocal.phi1_z= 0; pLocal.T1_x= 0;pLocal.T1_y= 0;pLocal.T1_z= 0;
            %Thumb
            pLocal.phiT1_x= pi/4;pLocal.phiT1_z= -pi/8;pLocal.phiT2_x= 0;pLocal.phiT2_z= pi/4;pLocal.phiT3_z= pi/4;
            %Index
            pLocal.phiI2_x= 0;pLocal.phiI2_z= 0;pLocal.phiI3_x= 0;pLocal.phiI4_x= 0;
            %Middle
            pLocal.phiM2_x= 3*pi/8;pLocal.phiM2_z= 0;pLocal.phiM3_x= 2*pi/8;pLocal.phiM4_x= pi/4;
            %Ring
            pLocal.phiR2_x= 3*pi/8;pLocal.phiR2_z= 0;pLocal.phiR3_x= 2*pi/8;pLocal.phiR4_x= pi/4;
            %Little
            pLocal.phiL2_x= pi/8;pLocal.phiL2_z= 0;pLocal.phiL3_x=pi/8;pLocal.phiL4_x= pi/2;
        case {405}%e
            %Global
            pLocal.phi1_x= 0; pLocal.phi1_y= 0;pLocal.phi1_z= 0; pLocal.T1_x= 0;pLocal.T1_y= 0;pLocal.T1_z= 0;
             %Thumb
            pLocal.phiT1_x= 0;pLocal.phiT1_z= -pi/4;pLocal.phiT2_x= 0;pLocal.phiT2_z= 0;pLocal.phiT3_z= 0;
            %Index
            pLocal.phiI2_x= 0;pLocal.phiI2_z=  -phiI;pLocal.phiI3_x= pi/2;pLocal.phiI4_x= pi/2;
            %Middle
            pLocal.phiM2_x= 0;pLocal.phiM2_z=  -phiM;pLocal.phiM3_x= pi/2;pLocal.phiM4_x= pi/2;
            %Ring
            pLocal.phiR2_x= 0;pLocal.phiR2_z=  -phiR;pLocal.phiR3_x= pi/2;pLocal.phiR4_x= pi/2;
            %Little
            pLocal.phiL2_x= 0;pLocal.phiL2_z=  -phiL;pLocal.phiL3_x=pi/2;pLocal.phiL4_x= pi/2;
          case {406}%f
            %Global
            pLocal.phi1_x= 0; pLocal.phi1_y= pi/4;pLocal.phi1_z= 0; pLocal.T1_x= 0;pLocal.T1_y= 0;pLocal.T1_z= 0;
            %Thumb
            pLocal.phiT1_x= 3*pi/16;pLocal.phiT1_z= -pi/8;pLocal.phiT2_x= 0;pLocal.phiT2_z= pi/8;pLocal.phiT3_z= pi/4;
            %Index
            pLocal.phiI2_x= pi/2;pLocal.phiI2_z= 0;pLocal.phiI3_x= 0;pLocal.phiI4_x= 0;
            %Middle
            pLocal.phiM2_x= 0;pLocal.phiM2_z= 0;pLocal.phiM3_x= 0;pLocal.phiM4_x= 0;
            %Ring
            pLocal.phiR2_x= 0;pLocal.phiR2_z= pi/32;pLocal.phiR3_x= 0;pLocal.phiR4_x= 0;
            %Little
            pLocal.phiL2_x= 0;pLocal.phiL2_z= pi/20;pLocal.phiL3_x=0;pLocal.phiL4_x= 0;
         case {407}%g
            %Global
            pLocal.phi1_x= 0; pLocal.phi1_y= -pi;pLocal.phi1_z= pi/2; pLocal.T1_x= 0;pLocal.T1_y= 0;pLocal.T1_z= 0;
            %Thumb
            pLocal.phiT1_x= pi/4;pLocal.phiT1_z= -pi/8;pLocal.phiT2_x= 0;pLocal.phiT2_z= pi/4;pLocal.phiT3_z= pi/4;
            %Index
            pLocal.phiI2_x= 0;pLocal.phiI2_z= 0;pLocal.phiI3_x= 0;pLocal.phiI4_x= 0;
            %Middle
            pLocal.phiM2_x= pi/2;pLocal.phiM2_z= 0;pLocal.phiM3_x= pi/2;pLocal.phiM4_x= pi/2;
            %Ring
            pLocal.phiR2_x= pi/2;pLocal.phiR2_z= 0;pLocal.phiR3_x= pi/2;pLocal.phiR4_x= pi/2;
            %Little
            pLocal.phiL2_x= pi/2;pLocal.phiL2_z= 0;pLocal.phiL3_x=pi/2;pLocal.phiL4_x= pi/2;
         case {408}%h
            %Global
            pLocal.phi1_x= 0; pLocal.phi1_y= pi;pLocal.phi1_z= pi/4; pLocal.T1_x= 0;pLocal.T1_y= 0;pLocal.T1_z= 0;
            %Thumb
            pLocal.phiT1_x= 0;pLocal.phiT1_z= -pi/4;pLocal.phiT2_x= 0;pLocal.phiT2_z= 0;pLocal.phiT3_z= 0;
            %Index
            pLocal.phiI2_x= 0;pLocal.phiI2_z= 0;pLocal.phiI3_x= 0;pLocal.phiI4_x= 0;
            %Middle
            pLocal.phiM2_x= 0;pLocal.phiM2_z= pi/12;pLocal.phiM3_x= 0;pLocal.phiM4_x= 0;
            %Ring
            pLocal.phiR2_x= pi/2;pLocal.phiR2_z= 0;pLocal.phiR3_x= pi/2;pLocal.phiR4_x= pi/2;
            %Little
            pLocal.phiL2_x= pi/2;pLocal.phiL2_z= 0;pLocal.phiL3_x=pi/2;pLocal.phiL4_x= pi/2;
         case {409}%i
            %Global
            pLocal.phi1_x= 0; pLocal.phi1_y= pi/4;pLocal.phi1_z= 0; pLocal.T1_x= 0;pLocal.T1_y= 0;pLocal.T1_z= 0;
            %Thumb
            pLocal.phiT1_x= pi/4;pLocal.phiT1_z= -pi/8;pLocal.phiT2_x= 0;pLocal.phiT2_z= pi/4;pLocal.phiT3_z= pi/4;
            %Index
            pLocal.phiI2_x= pi/2;pLocal.phiI2_z= 0;pLocal.phiI3_x= pi/2;pLocal.phiI4_x= pi/2;
            %Middle
            pLocal.phiM2_x= pi/2;pLocal.phiM2_z= 0;pLocal.phiM3_x= pi/2;pLocal.phiM4_x= pi/2;
            %Ring
            pLocal.phiR2_x= pi/2;pLocal.phiR2_z= 0;pLocal.phiR3_x= pi/2;pLocal.phiR4_x= pi/2;
            %Little
            pLocal.phiL2_x= 0;pLocal.phiL2_z= 0;pLocal.phiL3_x=0;pLocal.phiL4_x= 0;
         case {410}%j
            %Global
            pLocal.phi1_x= 0; pLocal.phi1_y= pi;pLocal.phi1_z= 0; pLocal.T1_x= 0;pLocal.T1_y= 0;pLocal.T1_z= 0;
            %Thumb
            pLocal.phiT1_x= pi/4;pLocal.phiT1_z= -pi/8;pLocal.phiT2_x= 0;pLocal.phiT2_z= pi/4;pLocal.phiT3_z= pi/4;
            %Index
            pLocal.phiI2_x= pi/2;pLocal.phiI2_z= 0;pLocal.phiI3_x= pi/2;pLocal.phiI4_x= pi/2;
            %Middle
            pLocal.phiM2_x= pi/2;pLocal.phiM2_z= 0;pLocal.phiM3_x= pi/2;pLocal.phiM4_x= pi/2;
            %Ring
            pLocal.phiR2_x= pi/2;pLocal.phiR2_z= 0;pLocal.phiR3_x= pi/2;pLocal.phiR4_x= pi/2;
            %Little
            pLocal.phiL2_x= 0;pLocal.phiL2_z= 0;pLocal.phiL3_x=0;pLocal.phiL4_x= 0;
         case {411}%k
            %Global
            pLocal.phi1_x= 0; pLocal.phi1_y= pi/4;pLocal.phi1_z= 0; pLocal.T1_x= 0;pLocal.T1_y= 0;pLocal.T1_z= 0;
            %Thumb
            pLocal.phiT1_x= pi/8;pLocal.phiT1_z= -pi/8;pLocal.phiT2_x= 0;pLocal.phiT2_z= pi/8;pLocal.phiT3_z= pi/4;
            %Index
            pLocal.phiI2_x= 0;pLocal.phiI2_z= 0;pLocal.phiI3_x= 0;pLocal.phiI4_x= 0;
            %Middle
            pLocal.phiM2_x= pi/2;pLocal.phiM2_z= 0;pLocal.phiM3_x= 0;pLocal.phiM4_x= 0;
            %Ring
            pLocal.phiR2_x= pi/2;pLocal.phiR2_z= 0;pLocal.phiR3_x= pi/2;pLocal.phiR4_x= pi/2;
            %Little
            pLocal.phiL2_x= pi/2;pLocal.phiL2_z= 0;pLocal.phiL3_x=pi/2;pLocal.phiL4_x= pi/2;
         case {412}%l
             %Global
            pLocal.phi1_x= 0; pLocal.phi1_y= 0;pLocal.phi1_z=0 ; pLocal.T1_x= 0;pLocal.T1_y= 0;pLocal.T1_z= 0;
            %Thumb
            pLocal.phiT1_x= 0;pLocal.phiT1_z= -pi/4;pLocal.phiT2_x= 0;pLocal.phiT2_z= -3*pi/16;pLocal.phiT3_z= 0;
            %Index
            pLocal.phiI2_x= 0;pLocal.phiI2_z= 0;pLocal.phiI3_x= 0;pLocal.phiI4_x= 0;
            %Middle
            pLocal.phiM2_x= pi/2;pLocal.phiM2_z= 0;pLocal.phiM3_x= pi/2;pLocal.phiM4_x= pi/2;
            %Ring
            pLocal.phiR2_x= pi/2;pLocal.phiR2_z= 0;pLocal.phiR3_x= pi/2;pLocal.phiR4_x= pi/2;
            %Little
            pLocal.phiL2_x= pi/2;pLocal.phiL2_z= 0;pLocal.phiL3_x=pi/2;pLocal.phiL4_x= pi/2;
         case {413}%m
            %Global
            pLocal.phi1_x= pi; pLocal.phi1_y= 0;pLocal.phi1_z= 0; pLocal.T1_x= 0;pLocal.T1_y= 0;pLocal.T1_z= 0;
            %Thumb
            pLocal.phiT1_x= pi/4;pLocal.phiT1_z= 0;pLocal.phiT2_x= 0;pLocal.phiT2_z= pi/4;pLocal.phiT3_z= pi/4;
            %Index
            pLocal.phiI2_x= 0;pLocal.phiI2_z= 0;pLocal.phiI3_x= 0;pLocal.phiI4_x= 0;
            %Middle
            pLocal.phiM2_x= 0;pLocal.phiM2_z= 0;pLocal.phiM3_x= 0;pLocal.phiM4_x= 0;
            %Ring
            pLocal.phiR2_x= 0;pLocal.phiR2_z= 0;pLocal.phiR3_x= 0;pLocal.phiR4_x= 0;
            %Little
            pLocal.phiL2_x= pi/2;pLocal.phiL2_z= 0;pLocal.phiL3_x=pi/2;pLocal.phiL4_x= pi/2;
        case {414,415}%n, n-tilde
            %Global
            pLocal.phi1_x= pi; pLocal.phi1_y= 0;pLocal.phi1_z= 0; pLocal.T1_x= 0;pLocal.T1_y= 0;pLocal.T1_z= 0;
           %Thumb
            pLocal.phiT1_x= pi/4;pLocal.phiT1_z= 0;pLocal.phiT2_x= 0;pLocal.phiT2_z= pi/4;pLocal.phiT3_z= pi/4;
            %Index
            pLocal.phiI2_x= 0;pLocal.phiI2_z= 0;pLocal.phiI3_x= 0;pLocal.phiI4_x= 0;
            %Middle
            pLocal.phiM2_x= 0;pLocal.phiM2_z= pi/12;pLocal.phiM3_x= 0;pLocal.phiM4_x= 0;
            %Ring
            pLocal.phiR2_x= pi/2;pLocal.phiR2_z= 0;pLocal.phiR3_x= pi/2;pLocal.phiR4_x= pi/2;
            %Little
            pLocal.phiL2_x= pi/2;pLocal.phiL2_z= 0;pLocal.phiL3_x=pi/2;pLocal.phiL4_x= pi/2;
        case {416}%o
            %Global
            pLocal.phi1_x= 0; pLocal.phi1_y= pi/2;pLocal.phi1_z= 0; pLocal.T1_x= 0;pLocal.T1_y= 0;pLocal.T1_z= 0;
            %Thumb
            pLocal.phiT1_x= pi/4;pLocal.phiT1_z= -pi/8;pLocal.phiT2_x= 0;pLocal.phiT2_z= pi/4;pLocal.phiT3_z= pi/8;
            %Index
            pLocal.phiI2_x= pi/4;pLocal.phiI2_z= 0;pLocal.phiI3_x= 3*pi/8;pLocal.phiI4_x=pi/8;
            %Middle
            pLocal.phiM2_x= pi/4;pLocal.phiM2_z= 0;pLocal.phiM3_x= 3*pi/8;pLocal.phiM4_x= pi/8;
            %Ring
            pLocal.phiR2_x= pi/4;pLocal.phiR2_z= 0;pLocal.phiR3_x= 3*pi/8;pLocal.phiR4_x= pi/8;
            %Little
            pLocal.phiL2_x= pi/8;pLocal.phiL2_z= 0;pLocal.phiL3_x=pi/8;pLocal.phiL4_x=pi/4;
        case {417}%p
            %Global
            pLocal.phi1_x= 0; pLocal.phi1_y= 0;pLocal.phi1_z=0 ; pLocal.T1_x= 0;pLocal.T1_y= 0;pLocal.T1_z= 0;
            %Thumb
            pLocal.phiT1_x= pi/4;pLocal.phiT1_z= -pi/8;pLocal.phiT2_x= 0;pLocal.phiT2_z= pi/4;pLocal.phiT3_z= pi/4;
            %Index
            pLocal.phiI2_x= 0;pLocal.phiI2_z= -phiI ;pLocal.phiI3_x=0;pLocal.phiI4_x= 0;
            %Middle
            pLocal.phiM2_x= 0;pLocal.phiM2_z= -phiM;pLocal.phiM3_x=0;pLocal.phiM4_x= 0;
            %Ring
            pLocal.phiR2_x= 0;pLocal.phiR2_z= -phiR;pLocal.phiR3_x=0;pLocal.phiR4_x= 0;
             %Little
            pLocal.phiL2_x= pi/2;pLocal.phiL2_z= 0;pLocal.phiL3_x=pi/2;pLocal.phiL4_x= pi/2;
          case {418}%q
             %Global
            pLocal.phi1_x= pi/2; pLocal.phi1_y= pi;pLocal.phi1_z= 0; pLocal.T1_x= 0;pLocal.T1_y= 0;pLocal.T1_z= 0;
            %Thumb
            pLocal.phiT1_x= pi/4;pLocal.phiT1_z= -pi/8;pLocal.phiT2_x= 0;pLocal.phiT2_z= pi/4;pLocal.phiT3_z= pi/8;
            %Index
            pLocal.phiI2_x= pi/4;pLocal.phiI2_z= 0;pLocal.phiI3_x= 3*pi/8;pLocal.phiI4_x=pi/8;
            %Middle
            pLocal.phiM2_x= pi/4;pLocal.phiM2_z= 0;pLocal.phiM3_x= 3*pi/8;pLocal.phiM4_x= pi/8;
            %Ring
            pLocal.phiR2_x= pi/4;pLocal.phiR2_z= pi/32;pLocal.phiR3_x= 3*pi/8;pLocal.phiR4_x= pi/8;
            %Little
            pLocal.phiL2_x= pi/4;pLocal.phiL2_z= pi/20;pLocal.phiL3_x=3*pi/8;pLocal.phiL4_x= pi/8;
        case {419}%r
            %Global
            pLocal.phi1_x= 0; pLocal.phi1_y= 0;pLocal.phi1_z=0 ; pLocal.T1_x= 0;pLocal.T1_y= 0;pLocal.T1_z= 0;
            %Thumb
            pLocal.phiT1_x= pi/4;pLocal.phiT1_z= -pi/8;pLocal.phiT2_x= 0;pLocal.phiT2_z= pi/4;pLocal.phiT3_z= pi/4;
            %Index
            pLocal.phiI2_x= pi/12;pLocal.phiI2_z= -3*phiI ;pLocal.phiI3_x=0;pLocal.phiI4_x= 0;
            %Middle
            pLocal.phiM2_x= 0;pLocal.phiM2_z= -phiM;pLocal.phiM3_x=0;pLocal.phiM4_x= 0;
            %Ring
            pLocal.phiR2_x= pi/2;pLocal.phiR2_z= -phiR;pLocal.phiR3_x=pi/2;pLocal.phiR4_x= pi/2;
             %Little
            pLocal.phiL2_x= pi/2;pLocal.phiL2_z= 0;pLocal.phiL3_x=pi/2;pLocal.phiL4_x= pi/2;
         case {420}%s
            %Global
            pLocal.phi1_x= 0; pLocal.phi1_y= 3*pi/8;pLocal.phi1_z= 0; pLocal.T1_x= 0;pLocal.T1_y= 0;pLocal.T1_z= 0;
            %Thumb
            pLocal.phiT1_x= pi/4;pLocal.phiT1_z= -pi/8;pLocal.phiT2_x= 0;pLocal.phiT2_z= pi/4;pLocal.phiT3_z= pi/4;
            %Index
            pLocal.phiI2_x= 0;pLocal.phiI2_z= 0;pLocal.phiI3_x= 0;pLocal.phiI4_x= 0;
            %Middle
            pLocal.phiM2_x= 0;pLocal.phiM2_z= 0;pLocal.phiM3_x= 0;pLocal.phiM4_x= 0;
            %Ring
            pLocal.phiR2_x= 3*pi/8;pLocal.phiR2_z= -pi/8;pLocal.phiR3_x= 3*pi/8;pLocal.phiR4_x= 0;
            %Little
            pLocal.phiL2_x= 0;pLocal.phiL2_z= pi/20;pLocal.phiL3_x=0;pLocal.phiL4_x= 0;
        case {421}%t
            %Global
            pLocal.phi1_x= 0; pLocal.phi1_y= 3*pi/8;pLocal.phi1_z= 0; pLocal.T1_x= 0;pLocal.T1_y= 0;pLocal.T1_z= 0;
            %Thumb
            pLocal.phiT1_x= pi/4;pLocal.phiT1_z= -pi/8;pLocal.phiT2_x= 0;pLocal.phiT2_z= pi/4;pLocal.phiT3_z= pi/4;
            %Index
            pLocal.phiI2_x= 3*pi/8;pLocal.phiI2_z= 0;pLocal.phiI3_x= 3*pi/8;pLocal.phiI4_x= 0;
            %Middle
            pLocal.phiM2_x= 0;pLocal.phiM2_z= 0;pLocal.phiM3_x= 0;pLocal.phiM4_x= 0;
            %Ring
            pLocal.phiR2_x= 0;pLocal.phiR2_z= pi/32;pLocal.phiR3_x= 0;pLocal.phiR4_x= 0;
            %Little
            pLocal.phiL2_x= 0;pLocal.phiL2_z= pi/20;pLocal.phiL3_x=0;pLocal.phiL4_x= 0;            
        case 424%w
           	%Global
            pLocal.phi1_x= 0; pLocal.phi1_y= 0;pLocal.phi1_z= 0; pLocal.T1_x= 0;pLocal.T1_y= 0;pLocal.T1_z= 0;
            %Thumb
            pLocal.phiT1_x= pi/4;pLocal.phiT1_z= pi/16;pLocal.phiT2_x= 0;pLocal.phiT2_z= pi/4;pLocal.phiT3_z= pi/4;
            %Index
            pLocal.phiI2_x= 0;pLocal.phiI2_z= 0;pLocal.phiI3_x= 0;pLocal.phiI4_x= 0;
            %Middle
            pLocal.phiM2_x= 0;pLocal.phiM2_z= 0;pLocal.phiM3_x= 0;pLocal.phiM4_x= 0;
            %Ring
            pLocal.phiR2_x= 0;pLocal.phiR2_z= pi/32;pLocal.phiR3_x= 0;pLocal.phiR4_x= 0;
             %Little
            pLocal.phiL2_x= pi/2;pLocal.phiL2_z= 0;pLocal.phiL3_x=pi/2;pLocal.phiL4_x= pi/2;
        case {425}%x
          %Global
            pLocal.phi1_x= 0; pLocal.phi1_y= pi/4;pLocal.phi1_z= 0; pLocal.T1_x= 0;pLocal.T1_y= 0;pLocal.T1_z= 0;
            %Thumb
            pLocal.phiT1_x= pi/4;pLocal.phiT1_z= -pi/8;pLocal.phiT2_x= 0;pLocal.phiT2_z= pi/4;pLocal.phiT3_z= pi/4;
            %Index
            pLocal.phiI2_x= 0;pLocal.phiI2_z= pi/12;pLocal.phiI3_x= pi/4;pLocal.phiI4_x= pi/8;
            %Middle
            pLocal.phiM2_x= pi/2;pLocal.phiM2_z= 0;pLocal.phiM3_x= pi/2;pLocal.phiM4_x= pi/2;
            %Ring
            pLocal.phiR2_x= pi/2;pLocal.phiR2_z= 0;pLocal.phiR3_x= pi/2;pLocal.phiR4_x= pi/2;
            %Little
            pLocal.phiL2_x= pi/2;pLocal.phiL2_z= 0;pLocal.phiL3_x=pi/2;pLocal.phiL4_x= pi/2;
         case {426}%y
             %Global
            pLocal.phi1_x= 0; pLocal.phi1_y= 0;pLocal.phi1_z= 0; pLocal.T1_x= 0;pLocal.T1_y= 0;pLocal.T1_z= 0;
            %Thumb
            pLocal.phiT1_x= pi/4;pLocal.phiT1_z= -pi/8;pLocal.phiT2_x= 0;pLocal.phiT2_z= pi/4;pLocal.phiT3_z= pi/4;
            %Index
            pLocal.phiI2_x= pi/2;pLocal.phiI2_z= 0;pLocal.phiI3_x= pi/2;pLocal.phiI4_x= pi/2;
            %Middle
            pLocal.phiM2_x= pi/2;pLocal.phiM2_z= 0;pLocal.phiM3_x= pi/2;pLocal.phiM4_x= pi/2;
            %Ring
            pLocal.phiR2_x= pi/2;pLocal.phiR2_z= 0;pLocal.phiR3_x= pi/2;pLocal.phiR4_x= pi/2;
            %Little
            pLocal.phiL2_x= pi/8;pLocal.phiL2_z= 0;pLocal.phiL3_x=pi/4;pLocal.phiL4_x= pi/8;
         case {427}%z
             %Global
            pLocal.phi1_x= 0; pLocal.phi1_y= 0;pLocal.phi1_z= 0; pLocal.T1_x= 0;pLocal.T1_y= 0;pLocal.T1_z= 0;
            %Thumb
            pLocal.phiT1_x= pi/4;pLocal.phiT1_z= -pi/8;pLocal.phiT2_x= 0;pLocal.phiT2_z= pi/4;pLocal.phiT3_z= pi/4;
            %Index
            pLocal.phiI2_x= pi/2;pLocal.phiI2_z= 0;pLocal.phiI3_x= pi/2;pLocal.phiI4_x= pi/2;
            %Middle
            pLocal.phiM2_x= pi/2;pLocal.phiM2_z= 0;pLocal.phiM3_x= pi/2;pLocal.phiM4_x= pi/2;
            %Ring
            pLocal.phiR2_x= pi/2;pLocal.phiR2_z= 0;pLocal.phiR3_x= pi/2;pLocal.phiR4_x= pi/2;
            %Little
            pLocal.phiL2_x= 0;pLocal.phiL2_z= 0;pLocal.phiL3_x=0;pLocal.phiL4_x= 0;
        end
    p{i}= pLocal;
    pplainLocal = [pLocal.phi1_x pLocal.phi1_y pLocal.phi1_z pLocal.T1_x pLocal.T1_y pLocal.T1_z];
    pplainLocal = [pplainLocal pLocal.phiT1_x pLocal.phiT1_z pLocal.phiT2_x pLocal.phiT2_z pLocal.phiT3_z];
    pplainLocal = [pplainLocal pLocal.phiI2_x pLocal.phiI2_z pLocal.phiI3_x pLocal.phiI4_x];
    pplainLocal = [pplainLocal pLocal.phiM2_x pLocal.phiM2_z pLocal.phiM3_x pLocal.phiM4_x];
    pplainLocal = [pplainLocal pLocal.phiR2_x pLocal.phiR2_z pLocal.phiR3_x pLocal.phiR4_x];
    pplainLocal = [pplainLocal pLocal.phiL2_x pLocal.phiL2_z pLocal.phiL3_x pLocal.phiL4_x];
    pplain(i,:)=pplainLocal;
end
