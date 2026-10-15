function depthSheet(images, labels, nCols, file, tileSize)
%DEPTHSHEET Save a labelled grid of depth images (used by make_figures).
%   depthSheet(images, labels, nCols, file) crops every image of the cell
%   array images to their common bounding box, stretches the depth range of
%   each hand for display (at most 6 grey levels per voxel, so that a flat
%   hand stays flat) and writes the grid, with labels as titles, to
%   the PNG file. tileSize sets the tile width in pixels (default 110).
if nargin < 5, tileSize = 110; end
mask = false(size(images{1}));
for k = 1:numel(images)
    mask = mask | images{k} > 0;
end
[r, c] = find(mask);
h = max(max(r) - min(r), max(c) - min(c)) + 10;      % square crop
r0 = max(1, round((min(r) + max(r) - h) / 2));
c0 = max(1, round((min(c) + max(c) - h) / 2));
rows = r0:min(size(mask,1), r0 + h);
cols = c0:min(size(mask,2), c0 + h);
nRows = ceil(numel(images) / nCols);
titleH = 22;                                         % pixels per label
W = nCols * tileSize;
H = nRows * (tileSize + titleH);
f = figure('visible', 'off', 'position', [0 0 W H], 'color', 'w');
for k = 1:numel(images)
    v = double(images{k}(rows, cols));
    fg = v > 0;
    range = max(1, max(v(fg)) - min(v(fg)));
    v(fg) = 255 - min(6, 195 / range) * (max(v(fg)) - v(fg));
    i = floor((k-1) / nCols); j = mod(k-1, nCols);
    axes('position', [(j*tileSize + 3) / W, 1 - ((i+1)*(tileSize + titleH) - 3) / H, ...
                      (tileSize - 6) / W, (tileSize - 6) / H]);
    image(uint8(v)); colormap(gray(256)); axis image off;
    title(labels{k}, 'fontsize', 10, 'fontweight', 'normal');
end
print(f, file, '-dpng', '-r100');
close(f);
end
