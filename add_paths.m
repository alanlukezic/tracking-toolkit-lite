function toolkit_directory = add_paths()

toolkit_directory = fileparts(mfilename('fullpath'));
include_dirs = cellfun(@(x) fullfile(toolkit_directory, x), ...
    {'', 'utils', 'examples'}, 'UniformOutput', false);

addpath(include_dirs{:});

end  % endfunction
