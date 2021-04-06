% batch_files = {
% 'A-H_0610_274.mat',
% 'AB-A_274.mat',
% 'AB-A_0521_274.mat',
% 'AB-H-1_274.mat',
% 'AB-H-3_0604_274.mat',
% 'AB-H-4_0604_274.mat',
% 'AB-H_274.mat',
% 'H-A-M_0610_274.mat',
% 'H-M_0610_274.mat',
% 'HB-A-2_0604_274.mat',
% 'HB-A-3_0604_274.mat',
% 'HB-A_0521_274.mat',
% 'HB-H_0521_274.mat',
% 'MIX-BRDU_all.mat'
% 
% }
i=1;
batch_files = {
% '181001_10a_20.mat',
% '181109_liver_highres_20.mat'
% 'three_mix_withlabel_181031_20.mat'
'181111_liver_free_20.mat',
'181111_liver_hoechst_blood_20.mat'
}
cur_batch =  batch_files{i}(1:end-4);
load('181109_liver_highres_223.mat');
test_samples_all = test_samples;
load('181109_liver_highres_20.mat');
test_samples_20 = test_samples;

test_samples_20_processed = bsxfun(@rdivide,test_samples_20,test_samples_all(:,175));
 test_samples_20_processed(isinf(test_samples_20_processed))=0;
 test_samples_20_processed(isnan(test_samples_20_processed))=0;
 test_sample_20_tmp = zeros(65536,20);
 for j=1:20
     img = reshape(test_samples_20_processed(:,j),256,256);
    Iblur = imgaussfilt(img,2);
    test_sample_20_tmp(:,j) = Iblur(:);
 end
 test_samples_20_processed = test_sample_20_tmp;
%    load('C:\Users\Yuan Zhiyuan\Documents\MATLAB\SIMS_0820\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\274\cor_sort_ind.mat');
%     test_samples_processed = test_samples+1;
%     test_samples_processed = bsxfun(@rdivide,test_samples_processed,prctile(test_samples_processed,80,2));
%     test_samples_processed = log(test_samples_processed);
%     test_samples_processed = test_samples_processed(:,cur_sort_ind(1:20));
%     test_samples_processed = test_samples(:,cur_sort_ind(1:20));
%     test_samples_processed = (test_samples_processed-min(test_samples_processed(:)))/(max(test_samples_processed(:))-min(test_samples_processed(:)));
% %     
%     edge_auto = get_BK_pairwise(test_samples,1,256,256);
%     save(['edges/edges_ori_auto_',batch_files{i}],'edge_auto');
%    edge_ada = adaptive_constrast2(edge_auto,21,256,256);
%    save(['edges/edges_ori_ada_',batch_files{i}],'edge_ada');
% if(i==1)
load(['edges/edges_ori_auto_median',batch_files{i}]);
load(['edges/edges_ori_ada_median',batch_files{i}]);
% % else
%         edge_auto = get_BK_pairwise(test_samples_20_processed,1,256,256);
%     save(['edges/edges_ori_auto_median',batch_files{i}],'edge_auto');
%    edge_ada = adaptive_constrast2(edge_auto,21,256,256);
%    save(['edges/edges_ori_ada_median',batch_files{i}],'edge_ada');
% end

%     load(['edges_ori_auto_',batch_files{i}]);

%     edge_auto = get_BK_pairwise(test_samples,1,256,256);
%     save(['edges_ori_auto_',batch_files{i}],'edge_auto');
%    USIS_EM2(test_samples,cur_batch,0.8,10,edge_auto,40);
% USIS_EM2(test_samples,cur_batch,0.5,5,edge_ada,50);
%    USIS_EM2(test_samples,cur_batch,0.65,5,edge_ada,50);
%    USIS_EM2(test_samples,cur_batch,0.8,5,edge_auto,80);
%    USIS_EM2(test_samples,cur_batch,0.8,2.5,edge_auto,80);
% USIS_EM2(test_samples,[cur_batch,'_auto'],0.5,5,edge_auto,80);
% USIS_EM2(test_samples,[cur_batch,'_auto'],0.5,10,edge_auto,80);
% 
%    USIS_EM2(test_samples,[cur_batch,'_ada'],0.5,5,edge_ada,80);
%     USIS_EM2(test_samples,[cur_batch,'_ada'],0.5,10,edge_ada,80);
    
%    USIS_EM2(test_samples,[cur_batch,'_auto'],0.8,5,edge_auto,80);
%    USIS_EM2(test_samples,[cur_batch,'_auto'],0.8,10,edge_auto,150);
%    USIS_EM2(test_samples,[cur_batch,'_auto'],0.8,15,edge_auto,150);
%    USIS_EM2(test_samples,[cur_batch,'_ada'],0.8,5,edge_ada,80);
%    USIS_EM2(test_samples,[cur_batch,'_ada'],0.8,10,edge_ada,150);
iter_max= 200;
beta_list = [0.4,0.5];
save_pref = 'C:\Users\Yuan Zhiyuan\Documents\MATLAB\SIMS_0820\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\zuzhi\1109';
   USIS_EM2(test_samples_20_processed,[cur_batch,'_ada_median'],beta_list(1),25,edge_ada,iter_max,save_pref);
   USIS_EM2(test_samples_20_processed,[cur_batch,'_ada_median'],beta_list(1),15,edge_ada,iter_max,save_pref);
   USIS_EM2(test_samples_20_processed,[cur_batch,'_ada_median'],beta_list(1),20,edge_ada,iter_max,save_pref);
   USIS_EM2(test_samples_20_processed,[cur_batch,'_auto_median'],beta_list(1),25,edge_auto,iter_max,save_pref);
   USIS_EM2(test_samples_20_processed,[cur_batch,'_auto_median'],beta_list(1),15,edge_auto,iter_max,save_pref);
   USIS_EM2(test_samples_20_processed,[cur_batch,'_auto_median'],beta_list(1),20,edge_auto,iter_max,save_pref)
   
   USIS_EM2(test_samples_20_processed,[cur_batch,'_ada_median'],beta_list(2),25,edge_ada,iter_max,save_pref);
   USIS_EM2(test_samples_20_processed,[cur_batch,'_ada_median'],beta_list(2),15,edge_ada,iter_max,save_pref);
   USIS_EM2(test_samples_20_processed,[cur_batch,'_ada_median'],beta_list(2),20,edge_ada,iter_max,save_pref);
   USIS_EM2(test_samples_20_processed,[cur_batch,'_auto_median'],beta_list(2),25,edge_auto,iter_max,save_pref);
   USIS_EM2(test_samples_20_processed,[cur_batch,'_auto_median'],beta_list(2),15,edge_auto,iter_max,save_pref);
   USIS_EM2(test_samples_20_processed,[cur_batch,'_auto_median'],beta_list(2),20,edge_auto,iter_max,save_pref);

%    USIS_EM2(test_samples,cur_batch,1,5,edge_auto,80);
   
