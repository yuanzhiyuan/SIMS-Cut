function[Acc,rand_index] = hunyang_2(num_dim,nth_row)


% liver_labeling = {
%     'cur_labeling_0403_0328_20_Fmeasure_0.8_lambda_0.25_sigma_5_undirected_10.mat',
%     'cur_labeling_0403_0328_20_Fmeasure_0.8_lambda_0.2_sigma_10_undirected_control_17.mat',
%     'cur_labeling_0403_0328_20_Fmeasure_0.8_lambda_0.2_sigma_5_undirected_11.mat',
%     'cur_labeling_0403_0328_20_Fmeasure_0.8_lambda_0.1_sigma_5_undirected_8n_dist_11.mat',
%     'cur_labeling_0403_0328_20_Fmeasure_0.8_lambda_0.1_sigma_5_undirected_8n_9.mat',
%     'cur_labeling_0403_0328_20_Fmeasure_0.8_grad_div10_22.mat'
%     
% 
% 
% 
% }
labeling_0429 = {
        'cur_labeling_0429_AB-H_20_Fmeasure_0.5_ada21auto_div5_18.mat'
        

};
% labeling_0503 = {
%     'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\中间结果\AB-H-1_labeling.mat';
% }
labeling_0505 = {
    'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\中间结果\A-H-FLUO_labeling.mat',
    'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\中间结果\A-H-FLUO-1_labeling.mat',
   'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\中间结果\AB-A_labeling.mat',
  'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\中间结果\AB-H-1_labeling.mat',
'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\EM_mid_rst\cur_labeling_0429_AB-H_20_Fmeasure_0.5_ada21auto_div5_18.mat'

    };

pref = 'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\EM_mid_rst\';


load('C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\AB-A_274.mat');

% open('hela_brdu.fig');
% % load('final_img.mat')
% % load('m-H_20.mat');
%  h = gcf;
% axesObjs = get(h, 'Children');  %axes handles
% dataObjs = get(axesObjs, 'Children');
% img = get(dataObjs,'CData');
% img = img';
% cur_labeling = img(:);
% load([pref,labeling_0429{1}]);
load(labeling_0505{3});
load('corr_sort_ind_274.mat');
test_samples  =test_samples(:,sort_corr_ind);
test_samples = test_samples(:,1:num_dim);
cur_labeling = final_labeling;
[filtered_img,num_valid_cell,cur_labeling] = filter_cell(cur_labeling,1);
% cur_labeling = filtered_img';
% cur_labeling = cur_labeling(:);



% img = final_img';
%  cur_labeling = img(:);
% load([Labeling_pref,Labeling_path{i}]);
% load('')
%     load(testsamples_path{i},'test_samples');
% imshow(final_img,[]);
    [cur_cells,cur_cells_mean,sep_labeling] = get_each_cell_finger(cur_labeling,test_samples);
    
    num_cells = size(cur_cells_mean,1);
    
    
%     imshow(reshape(cur_labeling,256,256)',[]);
%     for i=1:num_cells
%         pixel_li = find(sep_labeling==i);
%         [text_i,text_j] = ind2ij(min(pixel_li),256,256);
%         text(text_i,text_j,num2str(i),'Color','red');
% %         subplot(num_cells,1,i);
% %         b = bar(cur_cells_mean(i,:),0.1);
%         
%     end
%        col_134 = cur_cells_mean(:,1);
% col_134 = cur_cells_mean(:,201);
idx_134 = 1;
col_134 = cur_cells_mean(:,idx_134);
% col_134 = cur_cells_mean(:,197);
% col_134 = cur_cells_mean(:,160);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%这里是尝试先归一化后算平均
col_134_pixel = test_samples(:,idx_134);
 normed_test_samples= bsxfun(@rdivide,test_samples,col_134_pixel(:));
[~,cur_cells_mean_normed3,~] = get_each_cell_finger(cur_labeling,normed_test_samples);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    cur_cells_mean_normed= bsxfun(@rdivide,cur_cells_mean,col_134(:));
    cur_cells_mean_normed2 = normr(cur_cells_mean);
    
    %之前有问题：AB-A，分不开，每一列都除以特定的一列，用fold change放大了差异
    
    cur_cells_mean_normed4 = bsxfun(@rdivide,cur_cells_mean_normed,cur_cells_mean_normed(nth_row,:));
    cur_cells_mean_normed5 = bsxfun(@rdivide,cur_cells_mean_normed3,cur_cells_mean_normed3(nth_row,:));
%     figure;
%      for i=1:num_cells
%      subplot(4,6,i);
%         b = bar(cur_cells_mean_normed(i,:),0.1);
%         title(num2str(i));
%      end
%AB-H的
    br_rela = [70,75,170,236,268,277,281];
    
    %AB_A的
    br_rela = [89,94,195,201,234,273,305,313,317]-1;
    
    
    %AB-H-1的
    br_rela = [45,84,89,118,192,268,304,308,241,97,29,12,4,7,118,137,173,175,178,211]-1;
%     br_rela =[84,95]-1;
br_rela = [11,20,22,35]-1;
br_rela = [];
    cur_cells_mean_normed=removerows(cur_cells_mean_normed','ind',br_rela)';
    cur_cells_mean_normed3=removerows(cur_cells_mean_normed3','ind',br_rela)';
    cur_cells_mean_normed2=removerows(cur_cells_mean_normed2','ind',br_rela)';
% 
cur_cells_mean_normed4=removerows(cur_cells_mean_normed4','ind',br_rela)';
cur_cells_mean_normed5=removerows(cur_cells_mean_normed5','ind',br_rela)';
    group = ones(num_cells,1);
    
    %AB-A的
    group([3,6,10,5,7,11,13,14,15,16,17,18,20,21,22,23,24,25,26,27,29,30,31])=2;
% %AB-H的
%     group([9,4,8,5,7,23,22,24,16,14,17,26,21,13,18,29,32,34,37])=2;
%AB-H-1的
% group([8,17,25,38,41,2,10,14,5,26,35,31,34,22,27,28,43]) = 2;
%A-H-FLUO的
% group([15,8,5,37,44,38,43,10,13,16,40,25,28]) = 2;
% group([11,6,7,1,2,12,50])=3;

%A-H-FLUO-1的
% group([5,6,9,12,26,21,20,25,32,36,40,46,44,41]) = 2;
% group([4,33,43,37,42])=1;
%     gt_labeling = ones()
    
%     D_eu_ori = squareform(pdist(cur_cells_mean,'euclidean'));
%     D_eu_normed = squareform(pdist(cur_cells_mean_normed5,'euclidean'));
%     
% %     Y_eu_ori = tsne_d(D_eu_ori,[],2,30);
%     Y_eu_normed =  tsne_d(D_eu_normed,[],2,50,10);
% Y_eu_normed =  tsne(cur_cells_mean_normed5,[],2,10,10);
%      dx = 0.1; dy = 0.1;
%     a = [1:num_cells]';
%     b = num2str(a); 
%     c = cellstr(b);
%     
%     %     gscatter(Y_eu_ori(:,1),Y_eu_ori(:,2),group);
% %     scatter(Y_eu_normed(:,1),Y_eu_normed(:,2));
%      gscatter(Y_eu_normed(:,1),Y_eu_normed(:,2),group);
%       text(Y_eu_normed(:,1)+dx,Y_eu_normed(:,2)+dy,c);
%    
% %     text(Y_eu_ori(:,1)+dx,Y_eu_ori(:,2)+dy,c);
%      text(Y_eu_normed(:,1)+dx,Y_eu_normed(:,2)+dy,c);

    
    
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%用来展示kmeans%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     load('tsned_Y_3_1');
    
%     [IDX,C] = kmeans(cur_cells_mean_normed,2,'Display','final');

num_clusters = 2;

for j=2:num_clusters
%     [IDX,C] = kmeans(Y_eu_normed,j,'Display','final');
[IDX,C] = kmeans(cur_cells_mean_normed5,j,'Display','final');
%      subplot(3,num_clusters-1,j-1);
%     gscatter(Y_eu_normed(:,1),Y_eu_normed(:,2),IDX);
%     colormap('jet');
%      text(Y_eu_normed(:,1)+dx,Y_eu_normed(:,2)+dy,c);
%        
%     title(['kmeans,k=',num2str(j)]);
%     
%     cluster_labeling =zeros(size(sep_labeling,1),1);
%     gt_labeling =zeros(size(sep_labeling,1),1);
%     
%     for i=1:num_cells
%        cur_cell_pixels = find(sep_labeling==i);
%        cluster_labeling(cur_cell_pixels) = IDX(i);
%        gt_labeling(cur_cell_pixels) = group(i);
%     end
%     
%    subplot(3,num_clusters-1,j-1+num_clusters-1);
%     
%     imagesc(reshape(cluster_labeling,256,256)');
%     colormap('jet');
%      for i=1:num_cells
%         pixel_li = find(sep_labeling==i);
%         [text_i,text_j] = ind2ij(min(pixel_li),256,256);
%         text(text_i,text_j,num2str(i),'Color','black');
% %         subplot(num_cells,1,i);
% %         b = bar(cur_cells_mean(i,:),0.1);
%         
%     end
%     subplot(3,num_clusters-1,j-1+2*num_clusters-2);
%     imagesc(reshape(gt_labeling,256,256)');
%     colormap('jet');
    
end
[Acc,rand_index,match]=AccMeasure(group,IDX);
    
       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    
    
    
    
    
%     cur_cells_mean_div_total = cur_cells_mean/total_li(i);
%     cur_cells_mean_div_C = cur_cells_mean/C_li(i);
%     cur_cells_mean_normed = normr(cur_cells_mean);
%     group = [group;i*ones(size(cur_cells,2),1)];
%     cells_mean = [cells_mean;cur_cells_mean];
end
function[i,j] = ind2ij(ind,height,width)
i = mod(ind-1,height)+1;
j = floor((ind-1)/height)+1;
end
%     cells_mean_div_total = [cells_mean_div_total;cur_cells_mean_div_total];
%      cells_mean_div_C = [cells_mean_div_C;cur_cells_mean_div_C];
%      cells_mean_normed = [cells_mean_normed;cur_cells_mean_normed];
%     cells = cat(2,cells,cur_cells);