function run_tracker(config)

add_paths();

tracker_name = config.tracker_name;

for i=1:numel(config.additional_paths)
    addpath(config.additional_paths{i});
end

% specify initialize and update function
initialize = str2func(sprintf('%s_initialize', tracker_name));
update = str2func(sprintf('%s_update', tracker_name));

% evaluation protocol parameters
use_reinitialization = config.use_reinitialization;
skip_after_fail = config.skip_after_fail;
fail_threshold = config.fail_threshold;

% specify dataset path and read sequence names
dataset_path = config.dataset_path;
sequence_list = textread(fullfile(dataset_path, 'list.txt'), '%s');

if ~exist(fullfile('results', tracker_name, 'baseline'))
    mkdir(fullfile('results', tracker_name, 'baseline'));
end

for i=1:numel(sequence_list)
    
    sequence = sequence_list{i};
    fprintf('Processing sequence: %s\n', sequence);
    if isOctave, fflush(stdout); end
    
    % define paths where results will be saved
    results_base_dir = fullfile('results', tracker_name, 'baseline', sequence);
    bboxes_path = fullfile(results_base_dir, sprintf('%s_001.txt', sequence));
    time_path = fullfile(results_base_dir, sprintf('%s_time.txt', sequence));
    
    % check if results on this sequence already exist
    if exist(bboxes_path)
        fprintf('Results on this sequence already exist. Skipping...\n');
        if isOctave, fflush(stdout); end
        continue;
    end
    
    if ~exist(results_base_dir)
        mkdir(results_base_dir);
    end
    
    % read all frames in the folder
    base_path = fullfile(dataset_path, sequence);
    img_dir = dir(fullfile(base_path, '*.jpg'));

    % read ground-truth
    % bounding box format: [x,y,width, height]
    gt = dlmread(fullfile(base_path, 'groundtruth.txt'));
    if size(gt,2) > 4
        % ground-truth in format: [x0,y0,x1,y1,x2,y2,x3,y3], convert:
        gt = config.convert_regions(gt);
    end

    start_frame = 1;
    n_failures = 0;
    
    % allocate variables to store results
    bboxes = zeros(numel(img_dir), 4);
    time = zeros(numel(img_dir), 1);

    frame = 1;
    while frame <= numel(img_dir)

        % read frame
        img = imread(fullfile(base_path, img_dir(frame).name));

        t_ = tic();
        if frame == start_frame
            % initialize tracker
            tracker = initialize(img, gt(frame,:));
            bbox = gt(frame, :);
            bboxes(frame, :) = 0;
            bboxes(frame, 1) = 1;
        else
            % update tracker (target localization + model update)
            [tracker, bbox] = update(tracker, img);
            bboxes(frame, :) = bbox;
        end
        
        time(frame) = toc(t_);
        
        % detect failures and reinit
        if use_reinitialization
            overlap = per_frame_overlaps(gt(frame,:), bbox, config.convert_regions);
            if overlap <= fail_threshold && use_reinitialization
                bboxes(frame, :) = 0;
                bboxes(frame, 1) = 2;
                frame = frame + skip_after_fail - 1;  % skip frames at reinit (like VOT)
                start_frame = frame + 1;
                n_failures = n_failures + 1;
            end
        end

        frame = frame + 1;

    end
    
    dlmwrite(bboxes_path, bboxes);
    dlmwrite(time_path, time);
    
end

fprintf('Done.\n');

end  % endfunction

