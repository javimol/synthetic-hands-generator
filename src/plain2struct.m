function [ p ] = plain2struct( pplain )
%PLAIN2STRUCT Summary of this function goes here
%   Detailed explanation goes here
  p.phi1_x =pplain(1);
  p.phi1_y=pplain(2);
  p.phi1_z=pplain(3);
  p.T1_x=pplain(4);
  p.T1_y=pplain(5);
  p.T1_z=pplain(6);
  p.phiT1_x=pplain(7);
  p.phiT1_z=pplain(8);
  p.phiT2_x=pplain(9);
  p.phiT2_z=pplain(10);
  p.phiT3_z=pplain(11);
  p.phiI2_x=pplain(12);
  p.phiI2_z=pplain(13);
  p.phiI3_x=pplain(14);
  p.phiI4_x=pplain(15);
  p.phiM2_x=pplain(16);
  p.phiM2_z=pplain(17);
  p.phiM3_x=pplain(18);
  p.phiM4_x=pplain(19);
  p.phiR2_x=pplain(20);
  p.phiR2_z=pplain(21);
  p.phiR3_x=pplain(22);
  p.phiR4_x=pplain(23); 
 p.phiL2_x=pplain(24); 
 p.phiL2_z=pplain(25); 
 p.phiL3_x=pplain(26); 
 p.phiL4_x=pplain(27); 
end

