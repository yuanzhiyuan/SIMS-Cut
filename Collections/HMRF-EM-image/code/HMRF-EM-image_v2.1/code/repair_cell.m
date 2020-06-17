function[] = repair_cell()
cells = {};
% group = [];
% cells_mean = [];
% cells_mean_div_total = [];
% cells_mean_div_C = [];
% cells_mean_normed = [];
Labeling_pref = 'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\EM_mid_rst\';
Labeling_path_1 = 'cur_labeling_0610_A-H_20_Fmeasure_0.5_ada21auto_div5_5.mat';
Labeling_path_2 = 'cur_labeling_0610_A-H_20_Fmeasure_0.5_ada21auto_div5_10.mat';
Labeling_path_3 = 'cur_labeling_0610_A-H_20_Fmeasure_0.5_ada21auto_div5_13.mat';

load([Labeling_pref,Labeling_path_1]);
cur_labeling1 = cur_labeling;
load([Labeling_pref,Labeling_path_2]);
cur_labeling2 = cur_labeling;
load([Labeling_pref,Labeling_path_3]);
cur_labeling3 = cur_labeling;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[sep_labeling1] = get_each_cell_pos(cur_labeling1);
num_cells1 = max(sep_labeling1);
for i=1:num_cells1
        pixel_li = find(sep_labeling1==i);
        [text_i,text_j] = ind2ij(min(pixel_li),256,256);
end
    
    
    imshow(reshape(cur_labeling1,256,256)',[]);
     
    for i=1:num_cells1
        pixel_li = find(sep_labeling1==i);
        [text_i,text_j] = ind2ij(min(pixel_li),256,256);
        text(text_i,text_j,num2str(i),'Color','red','FontSize',14);
    end
    
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 [sep_labeling2] = get_each_cell_pos(cur_labeling2);
num_cells2 = max(sep_labeling2);
for i=1:num_cells2
        pixel_li = find(sep_labeling2==i);
        [text_i,text_j] = ind2ij(min(pixel_li),256,256);
end
    
    
    imshow(reshape(cur_labeling2,256,256)',[]);
     
    for i=1:num_cells2
        pixel_li = find(sep_labeling2==i);
        [text_i,text_j] = ind2ij(min(pixel_li),256,256);
        text(text_i,text_j,num2str(i),'Color','red');
    end
     
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
     [sep_labeling3] = get_each_cell_pos(cur_labeling3);
num_cells3 = max(sep_labeling3);
for i=1:num_cells3
        pixel_li = find(sep_labeling3==i);
        [text_i,text_j] = ind2ij(min(pixel_li),256,256);
end
    
    
    imshow(reshape(cur_labeling3,256,256)',[]);
     
    for i=1:num_cells3
        pixel_li = find(sep_labeling3==i);
        [text_i,text_j] = ind2ij(min(pixel_li),256,256);
        text(text_i,text_j,num2str(i),'Color','red');
    end

     
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
% cur_labeling_6 = ones(65536,1);
% cur_labeling_6(sep_labeling2==6)=2;
% cur_labeling_6(sep_labeling2==8)=2;
% 
% img_68 = reshape(cur_labeling_6,256,256)';
% a = find(img_68==2);
% img1 = reshape(cur_labeling1,256,256)';
% for i=1:size(a,1)
%     [cur_i,cur_j] = ind2ij(a(i),256,256);
%     
%     
%     img1(cur_i,cur_j-15)=2;
% end

final_labeling = ones(65536,1);
% load('C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\中间结果\A-H-FLUO-1_tmp.mat');
    
%      cur_labeling1(sep_labeling1==2)=1;
%      cur_labeling1(sep_labeling1==5)=1;
     final_labeling(~ismember(sep_labeling1,[0,3,9,28,50,56,60,74,84,95,103,131,142]))=2;
     final_labeling(ismember(sep_labeling2,[2,10,31,52,48,46,54,59,58,75,92,98,115]))=2;
    final_labeling(ismember(sep_labeling3,[3,5,8,15,33,34,35,36,37,43,44,53,55,58,56]))=2;
     imshow(reshape(final_labeling,256,256)',[]);
%      cur_labeling1(sep_labeling2==2)=2;
%      cur_labeling1(sep_labeling2==4)=2;
%      cur_labeling1(sep_labeling2==5)=2;
%      cur_labeling1(sep_labeling2==7)=2;
% imshow(reshape(final_labeling,256,256)',[]);
% final_img = reshape(cur_labeling1,256,256)';
%      imshow(final_img,[]);
     
%     cur_cells_mean_div_total = cur_cells_mean/total_li(i);
%     cur_cells_mean_div_C = cur_cells_mean/C_li(i);
%     cur_cells_mean_normed = normr(cur_cells_mean);
%     group = [group;i*ones(size(cur_cells,2),1)];
%     cells_mean = [cells_mean;cur_cells_mean];
%     cells_mean_div_total = [cells_mean_div_total;cur_cells_mean_div_total];
%      cells_mean_div_C = [cells_mean_div_C;cur_cells_mean_div_C];
%      cells_mean_normed = [cells_mean_normed;cur_cells_mean_normed];
%     cells = cat(2,cells,cur_cells);
% end
end
function[i,j] = ind2ij(ind,height,width)
i = mod(ind-1,height)+1;
j = floor((ind-1)/height)+1;
end