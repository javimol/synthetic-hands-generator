function setup_paths()
%SETUP_PATHS Add the generator sources to the MATLAB/Octave path.
addpath(fullfile(fileparts(mfilename('fullpath')), 'src'));
