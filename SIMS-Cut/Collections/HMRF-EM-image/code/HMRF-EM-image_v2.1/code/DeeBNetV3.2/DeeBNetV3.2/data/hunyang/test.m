labeling_files = {
    
   'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\中间结果\AB-A_labeling.mat',
   'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\中间结果\AB-H_labeling.mat',
   'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\中间结果\AB-H-1_labeling.mat',
   'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\中间结果\AB-A_0521_labeling.mat',
   'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\中间结果\HB-A_0521_labeling.mat',
   
   'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\中间结果\HB-H_0521_labeling.mat',
   
   
   
   'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\中间结果\AB-H-3_0604_labeling.mat',
   'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\中间结果\AB-H-4_0604_labeling.mat',
   'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\中间结果\HB-A-2_0604_labeling.mat',
   'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\中间结果\HB-A-3_0604_labeling.mat',
   'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\中间结果\A-H_0610_labeling.mat',
   'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\中间结果\H-M_0610_labeling.mat',
   'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\中间结果\H-A-M_0610_labeling.mat'
   
}
group_cell = {};

%AB-A,全是1
group = ones(100,1);
group_cell{1} = group;
%AB-H
% group = 2*ones(37,1);
% group([9,4,8,5,7,23,22,24,16,14,17,26,21,13,18,29,32,34,37])=1;
group = 2*ones(47,1);
group([9,4,8,5,11,20,15,16,18,21,23,29,25,26,27,36,33,40,42,44,6,38,45,43,46,47])=1;

group_cell{2} = group;
%AB-H-1
% group = 2*ones(43,1);
% group([8,17,25,38,41,2,10,14,5,26,35,31,34,22,27,28,43]) = 1;
group = 2*ones(49,1);
group([9,19,23,2,12,7,15,4,28,29,37,33,36,24,30,31,42,45,48,49,46]) = 1;
group_cell{3} = group;
%0521 AB-A,全是1
group = ones(100,1);
group_cell{4} = group;
% 0521 HB-A
% group = ones(61,1);
% group([2,4,6,9,12,14,15,16,17,5,11,22,23,21,20,24,25,26,18,27,28,29,30,35,41,31,36,40,34,48,52,42,49,51,46,47,44,50,45,54,58,56,57,59,61]) = 2;
group = 2*ones(71,1);
group([2,4,7,14,10,19,8,38,45,32,39,40,34,41,55,58,68,62,64,65]) = 1;

group_cell{5} = group;
%0521 HB-H，全是2
group = 2*ones(100,1);
group_cell{6} = group;

% 0604 AB-H-3
% group = 2*ones(200,1);
% group([1,6,10,12,14,22,9,19,26,30,31,44,45,18,23,27,29,11,13,32,38,47,39,16,24,7])=1;
group = 2*ones(58,1);
group([7,40,2,11,12,9,10,13,17,19,24,23,28,25,33,37,38,34,35,39,31,20,18,16,45,46,57,52,55])=1;
group_cell{7} = group;

% 0604 AB-H-4
% group = 2*ones(200,1);
% group([4,7,9,6,13,2,8,15,20,21,25,28,27,30,31,34,36,42])=1;
group = 2*ones(47,1);
group([28,2,8,9,15,3,10,13,17,22,23,29,31,32,34,35,37,40,47])=1;
group_cell{8} = group;

% 0604 HB-A-2
% group = ones(200,1);
% group([9,11,12,13,14,19,24,29,33,5,41,44,39,46,52,54,50,53,56,6,47,55])=2;
group = ones(58,1);
group([42,38,45,47,53,55,54,51,57,9,11,12,13,5,6,15,18,22,29,33,56,58,48])=2;
group_cell{9} = group;

% 0604 HB-A-3
% group = ones(200,1);
%  group([2,7,12,14,3,11,16,18,19,21,24,26,38,43,44,45])=2;
group = ones(56,1);
 group([4,12,3,9,13,15,17,22,19,23,27,28,40,45,47,48])=2;
group_cell{10} = group;

% 0610 A-H
group = ones(200,1);
% group([2,4,6,9,12,14,15,16,17,5,11,22,23,21,20,24,25,26,18,27,28,29,30,35,41,31,36,40,34,48,52,42,49,51,46,47,44,50,45,54,58,56,57,59,61]) = 2;
group_cell{11} = group;

% 0610 H-M
group = ones(200,1);
% group([2,4,6,9,12,14,15,16,17,5,11,22,23,21,20,24,25,26,18,27,28,29,30,35,41,31,36,40,34,48,52,42,49,51,46,47,44,50,45,54,58,56,57,59,61]) = 2;
group_cell{12} = group;

% 0610 H-A-M
group = ones(200,1);
% group([2,4,6,9,12,14,15,16,17,5,11,22,23,21,20,24,25,26,18,27,28,29,30,35,41,31,36,40,34,48,52,42,49,51,46,47,44,50,45,54,58,56,57,59,61]) = 2;
group_cell{13} = group;

batch_num = 7;
load(labeling_files{batch_num});

group = group_cell{batch_num};
[sep_labeling] = get_each_cell_pos(final_labeling);

num_cells = max(sep_labeling);
colored_label = zeros(65536,1);
for i=1:num_cells
    colored_label(sep_labeling==i) = group(i);
end
test_path = 'C:\Users\Yuan Zhiyuan\Documents\MATLAB\SIMS_0820\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\274\labeling\';
load([test_path,'labeling_AB-H-3-0604.mat']);
colored_img = reshape(colored_label,256,256)';
colored_img(colored_img==2)=0;
test_img = reshape(final_labeling,256,256)';
test_img = (test_img-1)*3;
[sep_labeling] = get_each_cell_pos(final_labeling);
num_cells = max(sep_labeling);
imshowpair(test_img,colored_img);

for i=1:num_cells
        pixel_li = find(sep_labeling==i);
        [text_i,text_j] = ind2ij(min(pixel_li),256,256);
        text(text_i,text_j,num2str(i),'Color','red');
%         subplot(num_cells,1,i);
%         b = bar(cur_cells_mean(i,:),0.1);
        
    end