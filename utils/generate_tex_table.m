function generate_tex_table(sequences, failures, overlaps, lengths, trackers)

if numel(trackers) == 1
    table_dir_path = fullfile('output', trackers{1});
    if ~exist(table_dir_path)
        mkdir(table_dir_path);
    end
else
    table_dir_path = 'output';
    if ~exist(table_dir_path)
        mkdir(table_dir_path);
    end
end

table_path = fullfile(table_dir_path, 'table.tex');
fid = fopen(table_path, 'w');

fprintf(fid, '\\begin{table}\n');
fprintf(fid, '\\begin{center}\n');
fprintf(fid, '\\begin{tabular}{l');
for i=1:numel(trackers)
    fprintf(fid, ' c c');
end
fprintf(fid, '}\n');
fprintf(fid, '\\hline \n');
fprintf(fid, '  ');
for i=1:numel(trackers)
    fprintf(fid, '& \\multicolumn{2}{c}{{\\bf %s}}', upper(trackers{i}));
end
fprintf(fid, '\\\\\n');
fprintf(fid, '{\\bf Sequence}');
for i=1:numel(trackers)
    fprintf(fid, ' & {\\bf Overlap} & {\\bf Failures}');
end
fprintf(fid, ' \\\\\n');
fprintf(fid, '\\hline \n');

for i=1:numel(sequences)
    
    fprintf(fid, '%s', sequences{i});
    for j=1:numel(trackers)
        fprintf(fid, ' & %.2f & %d', overlaps(i,j), failures(i,j));
    end
    fprintf(fid, '\\\\\n');
    
end

fprintf(fid, '\\hline \n');

fprintf(fid, '{\\bf Average}');
for i=1:numel(trackers)
    fprintf(fid, ' & %.2f & %.2f', mean(overlaps(:,i)), mean(failures(:,i)));
end
fprintf(fid, '\\\\\n');

fprintf(fid, '\\hline \n');
fprintf(fid, '\\end{tabular}\n');
fprintf(fid, '\\end{center}\n');
fprintf(fid, '\\end{table}\n');
fclose(fid);

end  % endfunction
