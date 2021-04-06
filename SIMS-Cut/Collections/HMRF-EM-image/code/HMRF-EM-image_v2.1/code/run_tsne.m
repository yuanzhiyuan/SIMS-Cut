D_eu = squareform(pdist(cells_mean,'euclidean'));
D_eu_normed = squareform(pdist(cells_mean_normed,'euclidean'));


Y_eu = tsne_d(D_eu,group,2,10);
Y_eu_normed = tsne_d(D_eu_normed,group,2,10);

gscatter(Y_eu_normed(:,1),Y_eu_normed(:,2),group);
% D_eu_total = squareform(pdist(cells_mean_div_total,'euclidean'));
% D_eu_C = squareform(pdist(cells_mean_div_C,'euclidean'));
% D_eu_normed = squareform(pdist(cells_mean_normed,'euclidean'));
% D_cos_C = squareform(pdist(cells_mean_div_C,'cosine'));
% D_cos_total = squareform(pdist(cells_mean_div_total,'cosine'));
% D_cos = squareform(pdist(cells_mean,'cosine'));
% D_cos_normed = squareform(pdist(cells_mean_normed,'cosine'));
% 
% D_seu_C = squareform(pdist(cells_mean_div_C,'seuclidean'));
% D_seu_total = squareform(pdist(cells_mean_div_total,'seuclidean'));
% D_seu = squareform(pdist(cells_mean,'seuclidean'));
% 
% D_corr_C = squareform(pdist(cells_mean_div_C,'correlation'));
% D_corr_total = squareform(pdist(cells_mean_div_total,'correlation'));
% D_corr = squareform(pdist(cells_mean,'correlation'));
% 
% D_spearman_C = squareform(pdist(cells_mean_div_C,'spearman'));
% D_spearman_total = squareform(pdist(cells_mean_div_total,'spearman'));
% D_spearman = squareform(pdist(cells_mean,'spearman'));
% 
% D_cityblock_C = squareform(pdist(cells_mean_div_C,'cityblock'));
% D_cityblock_total = squareform(pdist(cells_mean_div_total,'cityblock'));
% D_cityblock = squareform(pdist(cells_mean,'cityblock'));
% 
% 
% cells_1 = cells_mean(group==1,:);
% cells_2 = cells_mean(group==2,:);
% cells_3 = cells_mean(group==3,:);
% cells_4 = cells_mean(group==4,:);
% cells_5 = cells_mean(group==5,:);
% cells_6 = cells_mean(group==6,:);
% cells_7 = cells_mean(group==7,:);
% % cells_8 = cells_mean(group==8,:);
% % cells_9 = cells_mean(group==9,:);
% 
% mean_cells_1 = mean(cells_1);
% mean_cells_2 = mean(cells_2);
% mean_cells_3 = mean(cells_3);
% mean_cells_4 = mean(cells_4);
% mean_cells_5 = mean(cells_5);
% mean_cells_6 = mean(cells_6);
% mean_cells_7 = mean(cells_7);
% % mean_cells_8 = mean(cells_8);
% % mean_cells_9 = mean(cells_9);
% 
% compare_567 = [mean_cells_1;mean_cells_2;mean_cells_3;mean_cells_4;mean_cells_5;mean_cells_6;mean_cells_7];
% compare567_total = [mean_cells_1/total_li(1);mean_cells_2/total_li(2);mean_cells_3/total_li(3);mean_cells_4/total_li(4);mean_cells_5/total_li(5);mean_cells_6/total_li(6);mean_cells_7/total_li(7)];
% compare567_C = [mean_cells_1/C_li(1)*C_li(1);mean_cells_2/C_li(2)*C_li(1);mean_cells_3/C_li(3)*C_li(1);mean_cells_4/C_li(4)*C_li(1);mean_cells_5/C_li(5)*C_li(1);mean_cells_6/C_li(6)*C_li(1);mean_cells_7/C_li(7)*C_li(1)];

% compare_567 = [mean_cells_1;mean_cells_2;mean_cells_3;mean_cells_4;mean_cells_5;mean_cells_6;mean_cells_7;mean_cells_8;mean_cells_9];
% compare567_total = [mean_cells_1/total_li(1);mean_cells_2/total_li(2);mean_cells_3/total_li(3);mean_cells_4/total_li(4);mean_cells_5/total_li(5);mean_cells_6/total_li(6);mean_cells_7/total_li(7);mean_cells_8/total_li(8);mean_cells_9/total_li(9)];
% compare567_C = [mean_cells_1/C_li(1)*C_li(1);mean_cells_2/C_li(2)*C_li(1);mean_cells_3/C_li(3)*C_li(1);mean_cells_4/C_li(4)*C_li(1);mean_cells_5/C_li(5)*C_li(1);mean_cells_6/C_li(6)*C_li(1);mean_cells_7/C_li(7)*C_li(1);mean_cells_8/C_li(8)*C_li(1);mean_cells_9/C_li(9)*C_li(1)];



% Y_eu = tsne_d(D_eu,group,2,10);
% Y_eu_total = tsne_d(D_eu_total,group,2,10);
% Y_eu_C = tsne_d(D_eu_C,group,2,10);
% Y_eu_normed = tsne_d(D_eu_normed,group,2,10);

% 
% Y_cos = tsne_d(D_cos,group,2,10);
% Y_cos_total = tsne_d(D_cos_total,group,2,10);
% Y_cos_C = tsne_d(D_cos_C,group,2,10);

% Y_seu = tsne_d(D_seu,group,2,10);
% Y_seu_total = tsne_d(D_seu_total,group,2,10);
% Y_seu_C = tsne_d(D_seu_C,group,2,10);

% Y_corr = tsne_d(D_corr,group,2,10);
% Y_corr_total = tsne_d(D_corr_total,group,2,10);
% Y_corr_C = tsne_d(D_corr_C,group,2,10);

% Y_spearman = tsne_d(D_spearman,group,2,10);
% Y_spearman_total = tsne_d(D_spearman_total,group,2,10);
% Y_spearman_C = tsne_d(D_spearman_C,group,2,10);

% Y_cityblock = tsne_d(D_cityblock,group,2,10);
% Y_cityblock_total = tsne_d(D_cityblock_total,group,2,10);
% Y_cityblock_C = tsne_d(D_cityblock_C,group,2,10);

% gscatter(Y_eu_total(:,1),Y_eu_total(:,2),group);
