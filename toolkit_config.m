function c = toolkit_config()

% evaluation parameters
c.use_reinitialization = true;

c.skip_after_fail = 5;

c.fail_threshold = 1e-10;

c.robustness_sensitivity = 100;

c.convert_regions = @poly2bboxes;

end  % endfunction
