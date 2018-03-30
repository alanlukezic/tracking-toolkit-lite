function generate_ar_plot(failures, overlaps, lengths, trackers, config)

colors = load_colors();
if size(colors,1) < numel(trackers)
    % repeat last color so that number of colors and trackers match
    last_color = colors(end, :);
    n_missing = numel(trackers) - size(colors,1);
    colors(end+1:end+n_missing, :) = repmat(last_color, n_missing, 1);
end

fig = figure(1); clf;
legend_entries = zeros(numel(trackers), 1);
for i=1:numel(trackers)
    
    % average overlap
    o = mean(overlaps(:,i));
    % average number of failures
    f = sum(failures(:,i)) / sum(lengths);
    % convert average failures to robustness
    r = exp(-f * config.robustness_sensitivity);
    
    p_ = plot(r, o , 'o', 'MarkerEdgeColor','k', 'MarkerSize',8, ...
        'MarkerFaceColor',colors(i,:));
    legend_entries(i) = p_;
    hold on;
    
end

hold off;
xlim([0,1]);
ylim([0,1]);
axis square;
ylabel('Accuracy');
xlabel('Robustness');
title('A-R plot');
legend(legend_entries, trackers);

saveas(fig, fullfile('output', 'ar-plot.png'));

close(fig);

end  % endfunction

