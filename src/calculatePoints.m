function [r,rS,TMS,profile] = calculatePoints(p,profile)
%CALCULATEPOINTS Forward kinematics of the hand model.
%   [r, rS, TMS] = calculatePoints(p, profile) computes the 3D skeleton of
%   the hand with joint parameters p (see generateHandParameters) and the
%   anatomy in profile (see generateUserProfiles; default profile if
%   omitted).
%
%   r    3xN matrix with every joint and fill point
%   rS   the same points by level:
%          wrist        wrist (level 0)
%          r1 ... r5    joints of levels 1-5, one column per finger
%                       (thumb, index, middle, ring, little; the thumb has
%                       no level 5)
%          fill         points interpolated along every segment and across
%                       the palm, which give the hand its volume
%          fill1, fill2 extra points across the palm at levels 1 and 2
%   TMS  homogeneous transformation matrices of every joint
%
%   Note: the scale is built into the segment lengths of the profile, so
%   the transforms are only translations and rotations.
if nargin < 2
    profiles = generateUserProfiles();
    profile = profiles{1};
end

fillSpacing = profile.fillSpacing;

% Transformation matrices
% Global: translation, then rotation about x, y and z
TMS.T0 = translationMatrix(p.T1_x,p.T1_y,p.T1_z)*rotationMatrix(p.phi1_x,p.phi1_y,p.phi1_z);
% Thumb
b = profile.baseT;
TMS.T1_T = translationMatrix(b(1),b(2),b(3))*rotationMatrix(p.phiT1_x,0,p.phiT1_z);
TMS.T2_T = translationMatrix(0,profile.thumbPalmLength,0)*rotationMatrix(p.phiT2_x,0,p.phiT2_z);
TMS.T3_T = translationMatrix(0,profile.thumbProximalLength,0)*rotationMatrix(0,0,p.phiT3_z);
% Other fingers
ids = 'IMRL';
for i=1:length(ids)
    id = ids(i);
    b = profile.(['base' id]);
    TMS.(['T1_' id]) = translationMatrix(b(1),b(2),b(3))*rotationMatrix(0,0,profile.(['phi' id]));
    palmLength = profile.palmLength;
    if id=='L'
        palmLength = profile.littlePalmLength;
    end
    TMS.(['T2_' id]) = translationMatrix(0,palmLength,0)*rotationMatrix(p.(['phi' id '2_x']),0,p.(['phi' id '2_z']));
    TMS.(['T3_' id]) = translationMatrix(0,profile.proximalLength,0)*rotationMatrix(p.(['phi' id '3_x']),0,0);
    TMS.(['T4_' id]) = translationMatrix(0,profile.tipSegmentLength,0)*rotationMatrix(p.(['phi' id '4_x']),0,0);
end

% Joints
o = [0 0 0 1]';
tip = [0 profile.tipSegmentLength 0 1]';
% Level 0: wrist
wrist = TMS.T0*o;
% Level 1: finger bases
rT1 = TMS.T0*TMS.T1_T*o;
rI1 = TMS.T0*TMS.T1_I*o;
rM1 = TMS.T0*TMS.T1_M*o;
rR1 = TMS.T0*TMS.T1_R*o;
rL1 = TMS.T0*TMS.T1_L*o;
r1 = [rT1 rI1 rM1 rR1 rL1];
fill1 = [(rT1+(rT1+rI1)/2)/2 (rT1+rI1)/2 ((rT1+rI1)/2 +rI1)/2 (rI1+rM1)/2 (rM1+rR1)/2 (rR1+rL1)/2];
% A bit more flesh at the base of the thumb
fill1 = [fill1 (rT1+(rT1+rI1)/2)/2 (rT1+rI1)/2 ((rT1+rI1)/2 +rI1)/2];
% Level 2: knuckles
rT2 = TMS.T0*TMS.T1_T*TMS.T2_T*o;
rI2 = TMS.T0*TMS.T1_I*TMS.T2_I*o;
rM2 = TMS.T0*TMS.T1_M*TMS.T2_M*o;
rR2 = TMS.T0*TMS.T1_R*TMS.T2_R*o;
rL2 = TMS.T0*TMS.T1_L*TMS.T2_L*o;
r2 = [rT2 rI2 rM2 rR2 rL2];
fill2 = [(rT2+(rT2+rI2)/2)/2 (rT2+rI2)/2 ((rT2+rI2)/2 +rI2)/2 (rI2+rM2)/2 (rM2+rR2)/2 (rR2+rL2)/2];
% A bit more flesh at the base of the thumb
fill2 = [fill2 (rT2+(rT2+rM2)/2)/2 (rT2+rM2)/2 ((rT2+rM2)/2 +rM2)/2];
% Level 3
rT3 = TMS.T0*TMS.T1_T*TMS.T2_T*TMS.T3_T*o;
rI3 = TMS.T0*TMS.T1_I*TMS.T2_I*TMS.T3_I*o;
rM3 = TMS.T0*TMS.T1_M*TMS.T2_M*TMS.T3_M*o;
rR3 = TMS.T0*TMS.T1_R*TMS.T2_R*TMS.T3_R*o;
rL3 = TMS.T0*TMS.T1_L*TMS.T2_L*TMS.T3_L*o;
r3 = [rT3 rI3 rM3 rR3 rL3];
% Level 4 (thumb tip)
rT4 = TMS.T0*TMS.T1_T*TMS.T2_T*TMS.T3_T*tip;
rI4 = TMS.T0*TMS.T1_I*TMS.T2_I*TMS.T3_I*TMS.T4_I*o;
rM4 = TMS.T0*TMS.T1_M*TMS.T2_M*TMS.T3_M*TMS.T4_M*o;
rR4 = TMS.T0*TMS.T1_R*TMS.T2_R*TMS.T3_R*TMS.T4_R*o;
rL4 = TMS.T0*TMS.T1_L*TMS.T2_L*TMS.T3_L*TMS.T4_L*o;
r4 = [rT4 rI4 rM4 rR4 rL4];
% Level 5: fingertips (no thumb)
rI5 = TMS.T0*TMS.T1_I*TMS.T2_I*TMS.T3_I*TMS.T4_I*tip;
rM5 = TMS.T0*TMS.T1_M*TMS.T2_M*TMS.T3_M*TMS.T4_M*tip;
rR5 = TMS.T0*TMS.T1_R*TMS.T2_R*TMS.T3_R*TMS.T4_R*tip;
rL5 = TMS.T0*TMS.T1_L*TMS.T2_L*TMS.T3_L*TMS.T4_L*tip;
r5 = [rI5 rM5 rR5 rL5];

rS.wrist = wrist(1:3,:);
rS.r1 = r1(1:3,:);
rS.r2 = r2(1:3,:);
rS.r3 = r3(1:3,:);
rS.r4 = r4(1:3,:);
rS.r5 = r5(1:3,:);
r = [rS.r1 rS.r2 rS.r3 rS.r4 rS.r5];

% Fill points along every segment, level by level
levels = {repmat(rS.wrist,1,5), rS.r1, rS.r2, rS.r3, rS.r4, rS.r5};
fill = [];
for iL=1:5
    rLA = levels{iL};
    rLB = levels{iL+1};
    if size(rLB,2)<size(rLA,2)
        rLA = rLA(:,2:end);   % the thumb has no level 5
    end
    for i=1:size(rLA,2)
        segmentLength = sqrt(sum((rLB(:,i)-rLA(:,i)).^2));
        nPoints = ceil(segmentLength/fillSpacing)-1;
        fill = [fill interpolPoints(rLA(:,i),rLB(:,i),nPoints)]; %#ok<AGROW>
    end
end

% Fill points across the palm, between levels 1 and 2. As in the original
% code, the number of points comes from the last segment above (the tip
% of the little finger), not from the length of each palm segment.
for i=1:size(fill1,2)
    nPoints = ceil(segmentLength/fillSpacing)-1;
    rFill = interpolPoints(fill1(1:3,i),fill2(1:3,i),nPoints);
    fill = [fill rFill(:,1:end-1)]; %#ok<AGROW>
end
rS.fill = fill;
rS.fill1 = fill1;
rS.fill2 = fill2;
r = [r fill];
