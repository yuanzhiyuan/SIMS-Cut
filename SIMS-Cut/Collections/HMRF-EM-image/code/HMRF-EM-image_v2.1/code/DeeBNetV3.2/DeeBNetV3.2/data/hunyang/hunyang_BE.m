
times = 3;
load('C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\中间结果\HB-A_0521_BE.mat');
HB_A_mat = cur_cells_mean_normed5;
HB_A_group = group;
HB_A_mat = [HB_A_mat,HB_A_group*times]
load('C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\中间结果\AB-A_0521_BE.mat');
AB_A_mat = cur_cells_mean_normed5;
AB_A_group = group;
AB_A_mat = [AB_A_mat,times*ones(size(AB_A_mat,1),1)];
load('C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\中间结果\HB-H_0521_BE.mat');
HB_H_mat = cur_cells_mean_normed5;
HB_H_group = group;
HB_H_mat = [HB_H_mat,times*2*ones(size(HB_H_mat,1),1)];

mat = [HB_A_mat;HB_H_mat;AB_A_mat];

%每种cell是一类
cell_group = [HB_A_group;2*ones(length(HB_H_group),1);ones(length(AB_A_group),1)];
%有无brdu是一类
br_group = [HB_A_group;HB_H_group;AB_A_group];
%3次batch一共6类
all_group = [HB_A_group;HB_H_group+2;AB_A_group+4];


Y_eu_normed =  tsne(mat,[],2,10,10);
    
    
    %     gscatter(Y_eu_ori(:,1),Y_eu_ori(:,2),group);
%     scatter(Y_eu_normed(:,1),Y_eu_normed(:,2));
     gscatter(Y_eu_normed(:,1),Y_eu_normed(:,2),all_group);
     