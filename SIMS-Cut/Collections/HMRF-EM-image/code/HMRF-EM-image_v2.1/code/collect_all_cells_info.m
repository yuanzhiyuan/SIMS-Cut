% Labeling_pref = 'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\EM_mid_rst\';
Labeling_pref = 'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\';
% Labeling_path = {'cur_labeling_0319_10a_Fmeasure_0.5_15.mat',
% %     'cur_labeling_hela10a_10a_Fmeasure_0.5_20.mat',
%     
%     'cur_labeling_0319_hela_Fmeasure_0.5_8.mat',
% %      'cur_labeling_hela10a_hela_Fmeasure_0.5_18.mat',
%      
%     'cur_labeling_0319_mcf_Fmeasure_0.5_19.mat',
%    
%     
%     'cur_labeling_hela10a_a549_Fmeasure_0.5_13.mat',
%     'cur_labeling_0326_a549r1_no_Fmeasure_0.5_12.mat',
%     'cur_labeling_0326_a549r2_no_Fmeasure_0.5_12.mat',
%     'cur_labeling_0326_a549r3_no_Fmeasure_0.5_11.mat'
% %     'cur_labeling_0326_a549r1_brdu_Fmeasure_0.5_10.mat',
% %     'cur_labeling_0326_a549r2_brdu_Fmeasure_0.5_12.mat'
%     };
Labeling_path = {
    'hela\hela_no_labeling.mat',
    'hela\hela_brdu_labeling',
    '549\549_no_labeling.mat',
    '549\549_brdu_labeling.mat'



}
%     'cur_labeling_A549_brdu-549-1-1_Fmeasure_0.5_10.mat'};

% total_li = [2.586,2.788,1.910,2.642,2.297,1.933,1.658];
% % total_li = [2.586,1.910,2.297,1.933,2.073,1.689,2.161,1.944,2.001];
% total_li = total_li./total_li(1);
% C_li = [1486647,1571767,1258101,2101430,2236403,1342260,1512464];
% % C_li = [1486647,1258101,2236403,1342260,2052346,1444038,2330108,1793248,1807514];
% C_li = C_li./C_li(1);

% total_li = [2.586,2.788,1.910,2.642,2.297,1.933,2.073,1.689,2.161,1.944,2.001];
% total_li = total_li./total_li(1);
% % C_li = [1486647,1571767,1258101,2101430,2236403,1342260,1512464];
% C_li = [1486647,1571767,1258101,2101430,2236403,1342260,2052346,1444038,2330108,1793248,1807514];
% C_li = C_li./C_li(1);

% testsamples_pref = 'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\0319\';
% testsamples_path = {'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\0319\10a_no_testsamples_mod_dim15mul2_dim11plus.mat',
% %     'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\+hela10a\10a_testsample_mod_dim11plus.mat',
%     
%     'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\0319\hela_no_testsamples.mat',
% %     'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\+hela10a\hela_testsample_mod_dim11plus.mat',
%     
%     'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\0319\mcf_no_testsamples_mod_dim11plus.mat',
%     
%     'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\+hela10a\a549_testsample_mod_dim11_1.mat',
%     
%     'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\0326\180326_a549_nobrdu_r1_20.mat',
%     
%      'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\0326\180326_a549_nobrdu_r2_20.mat',
%  'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\0326\180326_a549_nobrdu_r3_20.mat',
% %   'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\0326\180326_a549_brdu_r1_20_mod_dim11plus.mat',
% %   'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\0326\180326_a549_brdu_r2_20.mat'
%  
%  
% 
%     
%     }
%     'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\+A549\A549_brdu_testsamples.mat'};

% testsamples_path = {'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\nobrdu\0319_10a_500_.mat',
%     'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\nobrdu\0319_hela_500_.mat',
%     'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\nobrdu\0319_mcf_500_.mat',
%     'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\nobrdu\0227_a549_500_.mat',
%     
%     
%     };


% testsamples_path = {
%    'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\nobrdu\7bat_0319_10a_500_.mat',
%     'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\nobrdu\7bat_0319_hela_500_.mat',
%  'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\nobrdu\7bat_0319_mcf_500_.mat',
%  'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\nobrdu\7bat_0227_a549_500_.mat',
%  'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\nobrdu\7bat_0326_a549_r1_500_.mat',
%  'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\nobrdu\7bat_0326_a549_r2_500_.mat',
%  'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\nobrdu\7bat_0326_a549_r3_500_.mat',
% 
%     };


testsamples_path = {
    'hela\hela_nobrdu_20.mat',
    'hela\hela_brdu_20.mat',
    '549\a549_nobrdu_r1_20.mat',
    '549\a549_brdu_r1_20.mat'


}
cells = {};
group = [];
cells_mean = [];
% cells_mean_div_total = [];
% cells_mean_div_C = [];
cells_mean_normed = [];
for i=1:4
    load([Labeling_pref,Labeling_path{i}]);
    load([Labeling_pref,testsamples_path{i}]);
%     label_img = reshape(cur_labeling,256,256)';
%     real_img = reshape(test_samples(:,1),256,256)';
%     imshowpair(label_img,real_img);
%     load(testsamples_path{i},'test_samples');
    [cur_cells_info,cur_cells_mean,sep_labeling] = get_each_cell_finger(cur_labeling,test_samples);
%     cur_cells_mean_div_total = cur_cells_mean/total_li(i);
%     cur_cells_mean_div_C = cur_cells_mean/C_li(i);
%     cur_cells_mean_normed = normr(cur_cells_mean);
    group = [group;i*ones(size(cur_cells_mean,1),1)];
    cells_mean = [cells_mean;cur_cells_mean];
%     cells_mean_div_total = [cells_mean_div_total;cur_cells_mean_div_total];
%      cells_mean_div_C = [cells_mean_div_C;cur_cells_mean_div_C];
%      cells_mean_normed = [cells_mean_normed;cur_cells_mean_normed];
    cells = cat(2,cells,cur_cells_info);
end

col_134 = cells_mean(:,1);
% col_134 = cur_cells_mean(:,183);
 cells_mean_normed= bsxfun(@rdivide,cells_mean,col_134(:));