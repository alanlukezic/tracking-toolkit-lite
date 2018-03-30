function run_experiment()
% run the tracker specified in the config file on the baseline experiment
% results are stored in the results folder

add_paths();

config_w = workspace_config();
configuration = toolkit_config();

f = fieldnames(config_w);
for i = 1:length(f)
    configuration.(f{i}) = config_w.(f{i});
end

run_tracker(configuration);

end  % endfunction
