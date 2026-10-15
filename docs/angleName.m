function s = angleName(a)
%ANGLENAME Short label for a multiple of pi/8 (used by make_figures).
names = {'-\pi/4', '-\pi/8', '0', '\pi/8', '\pi/4'};
s = names{round(a / (pi/8)) + 3};
end
