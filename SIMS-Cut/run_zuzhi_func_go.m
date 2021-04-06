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
%function[]=run_zuzhi_func(test_sample_path,test_sample_all_file,test_sample20_file,cut_edges_path,save_pref,save_final_labeling_path,use_edges)

function[]=run_zuzhi_func_go(process_path,test_sample_all_file,test_sample20_file,use_edges)
% save_mid_path²»ÒªÓÐ/
save_final_labeling_path = strcat(process_path,'cut/rst/');
test_sample_path = strcat(process_path,'preprocess/');
cut_edges_path = strcat(process_path,'cut/edges/');
EM_mid_path = strcat(process_path,'cut/EM_mid_rst/');
save_pref = strcat(process_path,'cut'); 
test_sample_all_file_simple = test_sample_all_file;
test_sample_all_file = strcat(test_sample_path,test_sample_all_file);
if ~exist(save_pref, 'dir')
       mkdir(save_pref);
end
if ~exist(cut_edges_path, 'dir')
       mkdir(cut_edges_path);
end
if ~exist(save_final_labeling_path, 'dir')
       mkdir(save_final_labeling_path);
end
if ~exist(EM_mid_path, 'dir')
       mkdir(EM_mid_path);
end
batch_files = {
% '181001_10a_20.mat',
% '181109_liver_highres_20.mat'
% 'three_mix_withlabel_181031_20.mat'
% '181111_liver_free_20.mat',
% '181111_liver_hoechst_blood_20.mat'
% '181119_liver_20',
% '181119_lung_20'
% '181126_lung_20.mat'
% '20181126_lung-type2_20.mat'
% '181130_cancer-idu-free_20.mat',
% '181130_cancer-idu-normal_20.mat'
% '20181208_intestine_20.mat'
% '20181208_intestine-1_20.mat',
% '20181208_liver-alb_20.mat'
test_sample20_file
}
for i=1:1

cur_batch =  batch_files{i}(1:end-4);
load(strcat(test_sample_path,batch_files{i}));
% load('181109_liver_highres_223.mat');
% test_samples_all = test_samples;
% load('181109_liver_highres_20.mat');
% test_samples_20 = test_samples;
% 
% test_samples_20_processed = bsxfun(@rdivide,test_samples_20,test_samples_all(:,175));
%  test_samples_20_processed(isinf(test_samples_20_processed))=0;
%  test_samples_20_processed(isnan(test_samples_20_processed))=0;
%  test_sample_20_tmp = zeros(65536,20);
%  for j=1:20
%      img = reshape(test_samples_20_processed(:,j),256,256);
%     Iblur = imgaussfilt(img,2);
%     test_sample_20_tmp(:,j) = Iblur(:);
%  end
%  test_samples_20_processed = test_sample_20_tmp;
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
% load(['edges/edges_ori_auto_',batch_files{i}]);
% load(['edges/edges_ori_ada_',batch_files{i}]);
% % else
test_samples_20 = test_samples;
if(use_edges==0)
        edge_auto = get_BK_pairwise(test_samples_20,1,256,256);
%     save(['edges/edges_ori_auto_',batch_files{i}],'edge_auto');
    save(strcat(cut_edges_path,'edges_ori_auto_',batch_files{i}),'edge_auto');
   edge_ada = adaptive_constrast2(edge_auto,21,256,256);
   save(strcat(cut_edges_path,'edges_ori_ada_',batch_files{i}),'edge_ada');
else
    load(strcat(cut_edges_path,'edges_ori_auto_',batch_files{i}));
    load(strcat(cut_edges_path,'edges_ori_ada_',batch_files{i}));
end
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
iters_max = 200;
beta_list = [0.9];
%beta_list = [0.5];
% save_pref = 'C:\Users\Yuan Zhiyuan\Documents\MATLAB\SIMS_0820\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\zuzhi\1208';
%    USIS_EM2(test_samples_20,[cur_batch,'_ada'],beta_list(1),5,edge_ada,iters_max,save_pref);
data_file = {};
label_file = {};
idx=1;
divn=10;
for beta=beta_list
    date = datestr(now,'HHMMSSFFF')
    USIS_EM2(test_samples_20,strcat(cur_batch,'_ada_test'),beta,divn,edge_ada,iters_max,save_pref,date);

    path = strcat(save_pref,'/EM_mid_rst/');
%    date = datestr(datetime('today'));
   % date = datestr(now,'HHMMSSFFF')
    suf = strcat(date,'_',cur_batch,'_ada_test_20_Fmeasure_',num2str(beta),'_div',num2str(divn),'_');
    file_prefix =strcat('cur_labeling_',suf,'_');
    repair_cell_comb3;
    data_file{idx} = test_sample_all_file;
    label_file{idx} = strcat(save_final_labeling_path,'final_labeling_',num2str(beta),'.mat');
    
end
%idx=length(beta_list);
disp(['idx',num2str(idx)])
collect_pixel_data_1208zuzhi;
disp(['idx',num2str(idx)])
save(strcat(save_final_labeling_path,date,'_datamat_',test_sample_all_file_simple),'data_mat')

%    USIS_EM2(test_samples_20,[cur_batch,'_ada_test'],beta_list(1),10,edge_ada,iters_max,save_pref);
%    USIS_EM2(test_samples_20,[cur_batch,'_ada_test'],beta_list(2),10,edge_ada,iters_max,save_pref);
%    [num_pos_li_7,beta_li_7] = USIS_EM2(test_samples_20,[cur_batch,'_ada_test'],beta_list(3),10,edge_ada,iters_max,save_pref);
%    [num_pos_li_8,beta_li_8]= USIS_EM2(test_samples_20,[cur_batch,'_ada_test'],beta_list(4),10,edge_ada,iters_max,save_pref);
%    [num_pos_li_9,beta_li_9] = USIS_EM2(test_samples_20,[cur_batch,'_ada_test'],beta_list(5),10,edge_ada,iters_max,save_pref);
%    USIS_EM2(test_samples_20,[cur_batch,'_ada'],beta_list(1),15,edge_ada,iters_max,save_pref);
%    USIS_EM2(test_samples_20,[cur_batch,'_auto'],beta_list(1),5,edge_auto,iters_max,save_pref);
%    USIS_EM2(test_samples_20,[cur_batch,'_auto'],beta_list(1),10,edge_auto,iters_max,save_pref);
%    USIS_EM2(test_samples_20,[cur_batch,'_auto'],beta_list(1),15,edge_auto,iters_max,save_pref)
   
%       USIS_EM2(test_samples_20,[cur_batch,'_ada'],beta_list(2),5,edge_ada,iters_max,save_pref);
%    USIS_EM2(test_samples_20,[cur_batch,'_ada'],beta_list(2),10,edge_ada,iters_max,save_pref);
%    USIS_EM2(test_samples_20,[cur_batch,'_ada'],beta_list(2),15,edge_ada,iters_max,save_pref);
%    USIS_EM2(test_samples_20,[cur_batch,'_auto'],beta_list(2),5,edge_auto,iters_max,save_pref);
%    USIS_EM2(test_samples_20,[cur_batch,'_auto'],beta_list(2),10,edge_auto,iters_max,save_pref);
%    USIS_EM2(test_samples_20,[cur_batch,'_auto'],beta_list(2),15,edge_auto,iters_max,save_pref);

%    USIS_EM2(test_samples,cur_batch,1,5,edge_auto,80);
end
