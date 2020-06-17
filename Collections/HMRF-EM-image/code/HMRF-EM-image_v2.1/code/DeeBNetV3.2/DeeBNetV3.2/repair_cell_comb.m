path = 'C:\Users\yzy\Documents\SIMS\MATLAB\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\EM_mid_rst\';
file_prefix = 'cur_labeling_0704_liver_20_Fmeasure_0.5_ada21auto_div10__';
file_sufix = '.mat';
iters_num = 22;
height = 256;
width = 256;
%指大于0.75分位数的细胞要考虑分裂(75分位数)
attention_threshold = 50;
labeling_mat = zeros(height*width,iters_num);
% 构建labeling_mat，并看哪个图的cell最多
num_cells_li =[];
num_pixels_li = [];
for i=1:iters_num
   cur_file = [path,file_prefix,num2str(i),file_sufix];
   load(cur_file);
  
   [filtered_img,num_valid_cell,filtered_labeling] = filter_cell(cur_labeling,3);
   img = reshape(filtered_labeling,256,256);
    [separated_img]=Separate_cell(img);
%     num_cells = max();
    labeling_mat(:,i) = separated_img(:);
    num_pixels = sum(cur_labeling==2);
    num_cells_li = [num_cells_li,num_valid_cell];
    num_pixels_li = [num_pixels_li,num_pixels];
end
% num_cells_li = num_cells_li/max(num_cells_li);
% num_pixels_li = num_pixels_li/max(num_pixels_li);
% com_li  =num_cells_li+0.05*num_pixels_li;
% subplot(3,1,1);
% plot(1:40,num_cells_li);
% subplot(3,1,2);
% plot(1:40,num_pixels_li);
% subplot(3,1,3);
% plot(1:40,com_li);
[max_cell_num,max_cell_idx] = max(num_cells_li);
% 开始分析初始图中的细胞

%max为细胞个数，min为0（基低）
% max_cell_idx = 6;
init_image_labeling = labeling_mat(:,max_cell_idx);
final_labeling = init_image_labeling;
cell_size_li = [];
for i=1:max_cell_num
    cell_size_li = [cell_size_li,sum(init_image_labeling==i)];
end
attention_cells = find(cell_size_li>prctile(cell_size_li,attention_threshold));

for i=attention_cells
    
    region_idxs = find(init_image_labeling==i);
    in_region_cells_li = [];
    for j=max_cell_idx+1:iters_num
        j_sep_labeling = labeling_mat(:,j);
        j_in_region = j_sep_labeling(region_idxs);
%         去掉0之后，看这个区域里有多少个不同cell
        j_in_region = j_in_region(j_in_region~=0);
        num_cells_in_region = length(unique(j_in_region));
        in_region_cells_li = [in_region_cells_li,num_cells_in_region];
        
    end
    [~,select_j] = max(in_region_cells_li);
    select_j = select_j + max_cell_idx;
    %select_j就是应该替换掉attention的img中第i个cell的图
    j_sep_labeling = labeling_mat(:,select_j);
    j_in_region = j_sep_labeling(region_idxs);
    final_labeling(region_idxs)  =j_in_region;
    
    
end

final_labeling(final_labeling~=0)=1;
final_labeling = final_labeling+1;
subplot(1,2,1);
imshow(reshape(final_labeling,256,256)',[]);
subplot(1,2,2);
imshow(reshape(init_image_labeling,256,256)');
[~,final_num_cells,~] = filter_cell(final_labeling,3);
disp(['有',num2str(final_num_cells),'个有效细胞']);



