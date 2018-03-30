function bboxes = poly2bboxes(regions)

if size(regions, 2) == 8
    x = regions(:,1:2:end);
    y = regions(:,2:2:end);
    x0 = min(x, [], 2);
    y0 = min(y, [], 2);
    x1 = max(x, [], 2);
    y1 = max(y, [], 2);
    w = x1 - x0 + 1;
    h = y1 - y0 + 1;
    bboxes = [x0, y0, w, h];
elseif size(regions, 2) == 4
    bboxes = regions;
else
    error('Polygons must have 8 elements to convert them to bboxes.');
end

end  % endfunction