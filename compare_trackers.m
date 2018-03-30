function compare_trackers(trackers)
% trackers: cell-array with strings - each element represents name of the tracker
% this script generates A-R plot and a latex table with including all trackers

if nargin < 1
    error('No input arguments given. Give tracker names as string in a single cellarray.');
elseif nargin > 1
    error('More than one input arguments given. Give tracker names as string in a single cellarray.');
end

add_paths();

config_w = workspace_config();
configuration = toolkit_config();

dataset_path = config_w.dataset_path;

sequence_list = textread(fullfile(dataset_path, 'list.txt'), '%s');

overlaps = zeros(numel(sequence_list), numel(trackers));
failures = zeros(numel(sequence_list), numel(trackers));
lengths = zeros(numel(sequence_list), 1);
times = zeros(numel(sequence_list), numel(trackers));

for i=1:numel(sequence_list)
    
    sequence = sequence_list{i};
    
    % read ground-truth and tracking results
    gt = dlmread(fullfile(dataset_path, sequence, 'groundtruth.txt'));
    % sequence length
    lengths(i) = size(gt,1);
    
    for j=1:numel(trackers)
        
        tracker_name = trackers{j};
        
        bboxes = dlmread(fullfile('results', tracker_name, 'baseline', ...
            sequence, sprintf('%s_001.txt', sequence)));
        time = dlmread(fullfile('results', tracker_name, 'baseline', ...
            sequence, sprintf('%s_time.txt', sequence)));

        if size(gt,1) ~= size(bboxes,1)
            warning('Size of the ground-truth and results is not the same.');
        end

        % count number of failures
        fail_idxs = find(bboxes(:,1)==2 & bboxes(:,2)==0 & ...
            bboxes(:,3)==0 & bboxes(:,4)==0);
        failures(i,j) = numel(fail_idxs);

        % indicator vector - which frames are used for average overlap
        % ignore initialization, failure and skip frames
        indicator = ones(size(bboxes,1), 1, 'logical');
        ignore_idxs = find(...
            (bboxes(:,1)==0 | bboxes(:,1)==1 | bboxes(:,1)==2) & ...
            bboxes(:,2)==0 & bboxes(:,3)==0 & bboxes(:,4)==0);
        indicator(ignore_idxs) = 0;

        % average per-frame overlaps
        o_ = per_frame_overlaps(gt, bboxes, configuration.convert_regions);
        overlaps(i,j) = mean(o_(indicator));
        
    end
    
end

for i=1:numel(trackers)
    fprintf('Tracker: %s: Av. overlap = %.2f, failures = %.2f\n', ...
        trackers{i}, mean(overlaps(:,i)), mean(failures(:,i)));
end

generate_ar_plot(failures, overlaps, lengths, trackers, configuration);
generate_tex_table(sequence_list, failures, overlaps, lengths, trackers);

end  % endfunction
