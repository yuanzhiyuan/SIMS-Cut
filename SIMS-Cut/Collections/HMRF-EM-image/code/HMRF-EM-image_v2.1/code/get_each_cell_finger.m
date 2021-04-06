%输入separated_img，从Separate_cell得到，0是bg，非零的为idx
%输入test_samples为e.g. 65536*20的数据

function[all_cells_info,all_cells_mean,sep_labeling] = get_each_cell_finger(Labeling,test_samples)

img = reshape(Labeling,256,256);
[separated_img]=Separate_cell(img);
num_cells = max(separated_img(:));
sep_labeling = separated_img(:);
all_cells_info = {};
all_cells_mean = [];
for i=1:num_cells
   idx_vector = find(sep_labeling==i);
   cur_cell_info = test_samples(idx_vector,:);
   all_cells_info{i} = cur_cell_info;
   cur_cell_mean = mean(cur_cell_info);
   all_cells_mean = [all_cells_mean;cur_cell_mean];
%    b = bar(cur_cell_mean,0.1);
%    saveas(b,['each_cell_finger_print/hela_brdu/',num2str(i),'_finger'],'fig');
end

% D = [];
% %D只保存距离矩阵的上三角
% s = 100;
% %s是mmd中gaussian kernel的sigma
% for i=1:num_cells
%    for j=i+1:num_cells
%        D = [D,MMD(all_cells_info{i},all_cells_info{j},s)];
%        disp([i,j]);
%    end
% end
