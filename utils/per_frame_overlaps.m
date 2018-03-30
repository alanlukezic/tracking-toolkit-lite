function overlaps = per_frame_overlaps(bboxes1, bboxes2, converter)
% bboxes1 and bboxes2 must be per-frame bboxes: each row is a bbox on a
% specific frame
% converter is a function handle to convert polygon-based regions to the
% axis aligned bounding-boxes

if size(bboxes1, 2) ~= 4
    bboxes1 = converter(bboxes1);
end
if size(bboxes2, 2) ~= 4
    bboxes2 = converter(bboxes2);
end

area1 = bboxes1(:,3) .* bboxes1(:,4);
area2 = bboxes2(:,3) .* bboxes2(:,4);

overlaps = zeros(size(bboxes1,1), 1);
for i=1:size(bboxes1,1)
    area = rectint(bboxes1(i,:), bboxes2(i,:));
    overlaps(i) = double(area) / double(area1(i) + area2(i) - area);
end

end  % endfunction