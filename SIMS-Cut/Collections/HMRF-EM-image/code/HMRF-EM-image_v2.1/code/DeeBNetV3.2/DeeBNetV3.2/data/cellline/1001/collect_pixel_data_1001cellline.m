batch_files = {
   '181001_10a_274.mat',
   '181001_a549_274.mat',
   '181001_hela_274.mat',
   '181001_sk_274.mat'
    
}
% labeling_files = {
%     
%    'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\中间结果\AB-A_labeling.mat',
%    'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\中间结果\AB-H_labeling.mat',
%    'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\中间结果\AB-H-1_labeling.mat',
%    'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\中间结果\AB-A_0521_labeling.mat',
%    'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\中间结果\HB-A_0521_labeling.mat',
%    
%    'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\中间结果\HB-H_0521_labeling.mat',
%    
%    
%    
%    'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\中间结果\AB-H-3_0604_labeling.mat',
%    'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\中间结果\AB-H-4_0604_labeling.mat',
%    'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\中间结果\HB-A-2_0604_labeling.mat',
%    'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\中间结果\HB-A-3_0604_labeling.mat',
%    'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\中间结果\A-H_0610_labeling.mat',
%    'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\中间结果\H-M_0610_labeling.mat',
%    'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\中间结果\H-A-M_0610_labeling.mat'
%    
% }
labeling_files = {
  '181001_10A_176_labeling.mat',
  '181001_a549_134_labeling.mat',
  '181001_hela_160_labeling.mat',
  '181001_sk_235_labeling.mat'
    

}

data_mat = [];
for i=1:4
   load(batch_files{i})
    load(labeling_files{i});
%     load('cor_sort_ind.mat');
%     test_samples  =test_samples(:,cur_sort_ind);
%     ith_FE_mat = FE_dict{i};
    cur_labeling = final_labeling;
    [filtered_img,num_valid_cell,cur_labeling] = filter_cell(cur_labeling,1);

    [cur_cells,cur_cells_mean,sep_labeling] = get_each_cell_finger(cur_labeling,test_samples); 
    for j=1:num_valid_cell
       cur_idxs = find(sep_labeling==j);
       cur_pixels = test_samples(cur_idxs,:);
%        cur_FE = ith_FE_mat(cur_idxs,:);
%        cur_pixels = cur_cells{j};
%        cur_group = group_cell{i};
       cur_batch = i;
       cur_cellidx = j;
       cur_celltype = i;
       to_add = [repmat([cur_batch,cur_cellidx,cur_celltype],size(cur_pixels,1),1),cur_idxs,cur_pixels];
       data_mat = [data_mat;to_add];
    end
%     添加地板像素点
cur_idxs = find(sep_labeling==0);
% cur_FE = ith_FE_mat(cur_idxs,:);
    cur_pixels = test_samples(cur_idxs,:);
    cur_batch = i;
    cur_cellidx = 0;
    cur_celltype=0;
    to_add = [repmat([cur_batch,cur_cellidx,cur_celltype],size(cur_pixels,1),1),cur_idxs,cur_pixels];
      data_mat = [data_mat;to_add];
    
end
