function create_tracker_workspace()

p = add_paths();

copyfile(fullfile(p, 'workspace_config_template.m'), './workspace_config.m');

end  % endfunction
