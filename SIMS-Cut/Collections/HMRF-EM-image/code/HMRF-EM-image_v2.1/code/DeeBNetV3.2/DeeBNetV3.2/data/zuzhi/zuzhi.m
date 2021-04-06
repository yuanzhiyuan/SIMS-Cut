function[Acc,rand_index] = zuzhi()


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


labeling_0704 = {
        'labeling/0704_liver_labeling.mat'
        

}




% pref = 'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\EM_mid_rst\';




test_samples_0704={
'liver_rela.mat'    

};


% load('C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\AB-A_274.mat');
load(test_samples_0704{1})

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
load(labeling_0704{1});
% load('cor_sort_ind.mat');
% test_samples  =test_samples(:,cur_sort_ind);
% test_samples = test_samples(:,1:num_dim);
cur_labeling = final_labeling;
[filtered_img,num_valid_cell,cur_labeling] = filter_cell(cur_labeling,1);
%  group = ones(num_cells,1);
%  group([8,17,25,38,41,2,10,14,5,26,35,31,34,22,27,28,43]) = 2;
 
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
    
    
    imshow(reshape(cur_labeling,256,256)',[]);
    for i=1:num_cells
        pixel_li = find(sep_labeling==i);
        [text_i,text_j] = ind2ij(min(pixel_li),256,256);
        text(text_i,text_j,num2str(i),'Color','red');
%         subplot(num_cells,1,i);
%         b = bar(cur_cells_mean(i,:),0.1);
        
    end

rows_norm= sqrt(sum(test_samples.^2,2));
normed_data = bsxfun(@rdivide,test_samples,rows_norm);

cols_scale = max(test_samples,1);
scaled_data = bsxfun(@rdivide,test_samples,cols_scale);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%这里是尝试先归一化后算平均
% col_134_pixel = test_samples(:,idx_134);
%  normed_test_samples= bsxfun(@rdivide,test_samples,col_134_pixel(:));
[~,cur_cells_mean_normed,~] = get_each_cell_finger(cur_labeling,scaled_data);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%这里是尝试先zscore后算平均
% col_134_pixel = test_samples(:,idx_134);
%  normed_test_samples= bsxfun(@rdivide,test_samples+1,col_134_pixel(:)+1);
%  normed_test_samples = zscore(normed_test_samples);
% [~,cur_cells_mean_normed6,~] = get_each_cell_finger(cur_labeling,normed_test_samples);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%     cur_cells_mean_normed= bsxfun(@rdivide,cur_cells_mean,col_134(:));
%     cur_cells_mean_normed7 = zscore(cur_cells_mean_normed);
%     cur_cells_mean_normed2 = normr(cur_cells_mean);
    
    %之前有问题：AB-A，分不开，每一列都除以特定的一列，用fold change放大了差异
    
%     cur_cells_mean_normed4 = bsxfun(@rdivide,cur_cells_mean_normed,cur_cells_mean_normed(nth_row,:));
%     cur_cells_mean_normed5 = bsxfun(@rdivide,cur_cells_mean_normed3,cur_cells_mean_normed3(nth_row,:));
%     figure;
%      for i=1:num_cells
%      subplot(4,6,i);
%         b = bar(cur_cells_mean_normed(i,:),0.1);
%         title(num2str(i));
%      end
%AB-H的
%     br_rela = [70,75,170,236,268,277,281];
    
    %AB_A的
%     br_rela = [89,94,195,201,234,273,305,313,317]-1;
    
    
    %AB-H-1的
%     br_rela = [45,84,89,118,192,268,304,308,241,97,29,12,4,7,118,137,173,175,178,211]-1;
%     br_rela =[84,95]-1;
% br_rela = [11,20,22,35]-1;
% br_rela = [];
%     cur_cells_mean_normed=removerows(cur_cells_mean_normed','ind',br_rela)';
%     cur_cells_mean_normed3=removerows(cur_cells_mean_normed3','ind',br_rela)';
%     cur_cells_mean_normed2=removerows(cur_cells_mean_normed2','ind',br_rela)';
% 
% cur_cells_mean_normed4=removerows(cur_cells_mean_normed4','ind',br_rela)';
% cur_cells_mean_normed5=removerows(cur_cells_mean_normed5','ind',br_rela)';

    group = ones(num_cells,1);
    
    %AB-A的
%     group([3,6,10,5,7,11,13,14,15,16,17,18,20,21,22,23,24,25,26,27,29,30,31])=2;
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

%0521 HB-A的
% group([2,4,6,9,12,14,15,16,17,5,11,22,23,21,20,24,25,26,18,27,28,29,30,35,41,31,36,40,34,48,52,42,49,51,46,47,44,50,45,54,58,56,57,59,61]) = 2;

%0521 AB-A的
% group([7,8,9,5,6,11,14,18,19,20,23,25,26,24,27,31,32,28,45,52,56,41,46,49,54,60,59])=2;

% 0521 HB-H的
% group([12,19,20,7,6,11,16,23,26,27,28,35,45,40,57,49,56,41,51,60,61,63])=2;

%0604 AB-H-3的
% group([1,6,10,12,14,22,9,19,26,30,31,44,45,18,23,27,29,11,13,32,38,47,39,16,24,7])=2;

%0604 AB-H-4的
% group([4,7,9,6,13,2,8,15,20,21,25,28,27,30,31,34,36,42])=2;

%0604 HB-A-3的
% group([2,7,12,14,3,11,16,18,19,21,24,26,38,43,44,45])=2;

%0604 HB-A-2的
% group([9,11,12,13,14,19,24,29,33,5,41,44,39,46,52,54,50,53,56,6,47,55])=2;



% rdpm_ratio = 1/3;
% rdpm = randperm(num_cells);
% group(rdpm(1:round(rdpm_ratio*num_cells)))=5;
% group(rdpm(round(rdpm_ratio*num_cells)):round(3/5*num_cells))=3;
% cur_cells_mean_normed5 = [cur_cells_mean_normed5,group];



%     gt_labeling = ones()
    
%     D_eu_ori = squareform(pdist(cur_cells_mean,'euclidean'));
%     D_eu_normed = squareform(pdist(cur_cells_mean_normed5,'euclidean'));
%     
% %     Y_eu_ori = tsne_d(D_eu_ori,[],2,30);
%     Y_eu_normed =  tsne_d(D_eu_normed,[],2,50,10);
Y_eu_normed =  tsne(cur_cells_mean_normed,[],2,10,20);
     dx = 0.1; dy = 0.1;
    a = [1:num_cells]';
    b = num2str(a); 
    c = cellstr(b);
    
    %     gscatter(Y_eu_ori(:,1),Y_eu_ori(:,2),group);
%     scatter(Y_eu_normed(:,1),Y_eu_normed(:,2));
     gscatter(Y_eu_normed(:,1),Y_eu_normed(:,2),ones(num_cells,1));
%       text(Y_eu_normed(:,1)+dx,Y_eu_normed(:,2)+dy,c);
%    
% %     text(Y_eu_ori(:,1)+dx,Y_eu_ori(:,2)+dy,c);
%      text(Y_eu_normed(:,1)+dx,Y_eu_normed(:,2)+dy,c);

    
    
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%用来展示kmeans%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     load('tsned_Y_3_1');
    
%     [IDX,C] = kmeans(cur_cells_mean_normed,2,'Display','final');
% cur_cells_mean_normed(:,end-1:end) = cur_cells_mean_normed(:,end-1:end)*2;
    num_clusters = 5;

for j=3:num_clusters
%     [IDX,C] = kmeans(Y_eu_normed,j,'Display','final');
[IDX,C] = kmeans(cur_cells_mean_normed,j,'Display','final');
     subplot(3,num_clusters-1,j-1);
    gscatter(Y_eu_normed(:,1),Y_eu_normed(:,2),IDX);
    colormap('jet');
     text(Y_eu_normed(:,1)+dx,Y_eu_normed(:,2)+dy,c);
       
    title(['kmeans,k=',num2str(j)]);
    
    cluster_labeling =zeros(size(sep_labeling,1),1);
    gt_labeling =zeros(size(sep_labeling,1),1);
    
    for i=1:num_cells
       cur_cell_pixels = find(sep_labeling==i);
       cluster_labeling(cur_cell_pixels) = IDX(i);
       gt_labeling(cur_cell_pixels) = group(i);
    end
    
   subplot(3,num_clusters-1,j-1+num_clusters-1);
    
    imagesc(reshape(cluster_labeling,256,256)');
    colormap('jet');
     
    subplot(3,num_clusters-1,j-1+2*num_clusters-2);
    imagesc(reshape(gt_labeling,256,256)');
    colormap('jet');
    for i=1:num_cells
        pixel_li = find(sep_labeling==i);
        [text_i,text_j] = ind2ij(min(pixel_li),256,256);
        text(text_i,text_j,num2str(i),'Color','black');
%         subplot(num_cells,1,i);
%         b = bar(cur_cells_mean(i,:),0.1);
        
    end
end
[Acc,rand_index,match]=AccMeasure(group,IDX)
    
       
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