% EXPORT_POSTURES  Embed the posture dictionary in the web viewer.
%   Run from the repository root after changing generateHandParameters:
%     octave --no-gui --eval "run('viewer/export_postures.m')"
%   Rewrites the JSON block between the POSTURES markers of
%   viewer/hand-viewer.html.
root = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(root, 'src'));
if exist('OCTAVE_VERSION', 'builtin'), enye = char([195 177]); else, enye = char(241); end
dicts = {
    'Molina et al. 2011', [1:5 7 8 11 12 6], ...
        {'Enum1', 'Enum2', 'Enum3', 'Enum4', 'Enum5', 'Stop', 'Fist', 'OkLeft', 'OkRight', 'Ok'}
    'Kollorz et al. 2008', 301:312, num2cell('ABCDEFGHIJKL')
    'Soutschek et al. 2008', 201:205, {'a (Stop)', 'b (Jedi)', 'c (Two)', 'd (Fist)', 'e (Ok)'}
    'Miscellaneous', 101:104, {'m1', 'm2', 'm3', 'm4'}
    'Spanish Sign Language', 401:427, [num2cell('abcdefghijklmn') {enye} num2cell('opqrstuvwxyz')]
};
lines = {};
for k = 1:size(dicts, 1)
    [~, P] = generateHandParameters(dicts{k,2});
    items = cell(1, numel(dicts{k,2}));
    for i = 1:numel(items)
        items{i} = sprintf('{"id":%d,"name":"%s","p":[%s]}', dicts{k,2}(i), ...
            dicts{k,3}{i}, strjoin(arrayfun(@(v) sprintf('%.17g', v), P(i,:), ...
            'UniformOutput', false), ','));
    end
    lines{end+1} = sprintf('{"name":"%s","postures":[\n%s]}', dicts{k,1}, ...
                           strjoin(items, ',\n'));                     %#ok<SAGROW>
end
json = ['[' strjoin(lines, ',\n') ']'];
file = fullfile(root, 'viewer', 'hand-viewer.html');
html = fileread(file);
a = strfind(html, '/*POSTURES*/'); b = strfind(html, '/*END POSTURES*/');
html = [html(1:a+11) json html(b:end)];
fid = fopen(file, 'w'); fwrite(fid, html); fclose(fid);
fprintf('Wrote %d dictionaries to %s\n', size(dicts, 1), file);
