% HANDS_DEMO  Render a contact sheet of synthetic depth hands.
%   Writes one PNG per posture to ./output and a montage to
%   ./output/contact_sheet.png. Runs in MATLAB and GNU Octave.
setup_paths;
postures = [1 2 3 4 5 6 7 8 201 202 205 401 402 404 405 413];
outDir = 'output';
if ~exist(outDir, 'dir'), mkdir(outDir); end
tiles = cell(1, numel(postures));
for k = 1:numel(postures)
    d = renderDepthHand(postures(k), 'Rotation', [pi/16 0 0]);
    imwrite(d, fullfile(outDir, sprintf('posture_%03d.png', postures(k))));
    % stretch the depth range of the hand for display
    v = double(d); fg = v > 0;
    v(fg) = 60 + 195 * (v(fg) - min(v(fg))) / max(1, max(v(fg)) - min(v(fg)));
    tiles{k} = uint8(v(25:120, 41:136));  % crop around the centred hand
end
cols = 4;
rows = ceil(numel(tiles) / cols);
[h, w] = size(tiles{1});
sheet = zeros(rows * h, cols * w, 'uint8');
for k = 1:numel(tiles)
    r = floor((k-1) / cols); c = mod(k-1, cols);
    sheet(r*h + (1:h), c*w + (1:w)) = tiles{k};
end
imwrite(sheet, fullfile(outDir, 'contact_sheet.png'));
fprintf('Wrote %d postures to %s/\n', numel(postures), outDir);
