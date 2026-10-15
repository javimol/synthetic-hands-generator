function pplain = struct2plain(p)
%STRUCT2PLAIN Hand parameters from a struct to a 1x27 vector.
%   Global rotation and translation, then the thumb, index, middle, ring
%   and little finger angles. plain2struct does the inverse.
pplain = [p.phi1_x p.phi1_y p.phi1_z p.T1_x p.T1_y p.T1_z];
pplain = [pplain p.phiT1_x p.phiT1_z p.phiT2_x p.phiT2_z p.phiT3_z];
pplain = [pplain p.phiI2_x p.phiI2_z p.phiI3_x p.phiI4_x];
pplain = [pplain p.phiM2_x p.phiM2_z p.phiM3_x p.phiM4_x];
pplain = [pplain p.phiR2_x p.phiR2_z p.phiR3_x p.phiR4_x];
pplain = [pplain p.phiL2_x p.phiL2_z p.phiL3_x p.phiL4_x];
