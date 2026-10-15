function pM = generatePointOfViewVariations(p0,phixR,phiyR,phizR)
%GENERATEPOINTOFVIEWVARIATIONS Copies of a pose seen from a grid of views.
%   pM = generatePointOfViewVariations(p0, phixR, phiyR, phizR) returns a
%   cell array with p0 rotated by every combination of the offsets in
%   phixR, phiyR and phizR (radians) added to its global rotation.
pM = {};
pLocal = p0;
for i=1:length(phixR)
    pLocal.phi1_x = p0.phi1_x + phixR(i);
    for j=1:length(phiyR)
        pLocal.phi1_y = p0.phi1_y + phiyR(j);
        for k=1:length(phizR)
            pLocal.phi1_z = p0.phi1_z + phizR(k);
            pM{end+1} = pLocal; %#ok<AGROW>
        end
    end
end
