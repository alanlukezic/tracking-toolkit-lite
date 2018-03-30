function performance_summary()
% script prints tracking performance summary and generates 
% latex table with per-sequence average overlap and number of failures

if nargin > 0
    error('No arguments should be given.');
end

add_paths();

config_w = workspace_config();
configuration = toolkit_config();

tracker_name = config_w.tracker_name;
dataset_path = config_w.dataset_path;

sequence_list = textread(fullfile(dataset_path, 'list.txt'), '%s');

overlaps = zeros(numel(sequence_list), 1);
failures = zeros(numel(sequence_list), 1);
lengths = zeros(numel(sequence_list), 1);
times = zeros(numel(sequence_list), 1);

for i=1:numel(sequence_list)
    
    sequence = sequence_list{i};
    
    % read ground-truth and tracking results
    gt = dlmread(fullfile(dataset_path, sequence, 'groundtruth.txt'));
    bboxes = dlmread(fullfile('results', tracker_name, 'baseline', ...
        sequence, sprintf('%s_001.txt', sequence)));
    time = dlmread(fullfile('results', tracker_name, 'baseline', ...
        sequence, sprintf('%s_time.txt', sequence)));
    
    % sequence length
    lengths(i) = size(gt,1);
    
    if size(gt,1) ~= size(bboxes,1)
        warning('Size of the ground-truth and results is not the same.');
    end
    
    % count number of failures
    fail_idxs = find(bboxes(:,1)==2 & bboxes(:,2)==0 & ...
        bboxes(:,3)==0 & bboxes(:,4)==0);
    failures(i) = numel(fail_idxs);
    
    % indicator vector - which frames are used for average overlap
    % ignore initialization, failure and skip frames
    indicator = ones(size(bboxes,1), 1, 'logical');
    ignore_idxs = find(...
        (bboxes(:,1)==0 | bboxes(:,1)==1 | bboxes(:,1)==2) & ...
        bboxes(:,2)==0 & bboxes(:,3)==0 & bboxes(:,4)==0);
    indicator(ignore_idxs) = 0;
    
    % average per-frame overlaps
    o_ = per_frame_overlaps(gt, bboxes, configuration.convert_regions);
    overlaps(i) = mean(o_(indicator));
    
    fprintf('%s: overlap = %.2f, failures = %d\n', ...
        sequence, overlaps(i), failures(i));
    
end
fprintf('-------------------------------------\n');
fprintf('Average: overlap = %.2f, failures = %.2f\n', ...
    mean(overlaps), mean(failures));

generate_tex_table(sequence_list, failures, overlaps, lengths, {tracker_name});

end  % endfunction
