function make_videos(folder, fps)
%MAKE_VIDEOS One AVI per profile and posture from a make_dataset folder.
%   make_videos(folder) reads the <profile>_<posture>_<n>.png images in
%   folder and writes folder/videos/<profile>/depth_<posture>.avi, with the
%   frames in the order they were generated, upscaled to 320x240.
%   make_videos(folder, fps) sets the frame rate (default 5).
%
%   Needs VideoWriter (MATLAB; in GNU Octave, the video package).
if nargin < 2, fps = 5; end
files = dir(fullfile(folder, '*.png'));
keys = zeros(numel(files), 3);
for i = 1:numel(files)
    keys(i,:) = sscanf(files(i).name, '%d_%d_%d')';
end
[keys, order] = sortrows(keys);
files = files(order);

writer = [];
for i = 1:numel(files)
    if i == 1 || any(keys(i,1:2) ~= keys(i-1,1:2))
        if ~isempty(writer), close(writer); end
        outDir = fullfile(folder, 'videos', num2str(keys(i,1)));
        if ~exist(outDir, 'dir'), mkdir(outDir); end
        writer = VideoWriter(fullfile(outDir, sprintf('depth_%d.avi', keys(i,2))));
        writer.FrameRate = fps;
        open(writer);
    end
    frame = imread(fullfile(folder, files(i).name));
    rows = round(linspace(1, size(frame,1), 240));
    cols = round(linspace(1, size(frame,2), 320));
    writeVideo(writer, frame(rows, cols));
end
if ~isempty(writer), close(writer); end
fprintf('Wrote videos for %d frames to %s\n', numel(files), fullfile(folder, 'videos'));
end
