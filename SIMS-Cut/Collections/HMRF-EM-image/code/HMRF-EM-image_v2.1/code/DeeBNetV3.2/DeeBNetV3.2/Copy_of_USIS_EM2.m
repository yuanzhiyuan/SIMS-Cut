function[]=USIS_EM2(test_samples,batch_name,beta,divn,ed,niters,save_pref)
Height = 256;
Width = 256;
n_matter = 20;
n_sites = Height*Width;
% suf = '0403_0328_20_Fmeasure_0.8_lambda_0.1_sigma_8_undirected_8n_dist';
% suf = '0403_0328_20_Fmeasure_0.8_2gradmax1_1sigma5_comdiv15';
% suf ='0403_0328_20_Fmeasure_0.8_1gradmax1_1auto2_comdiv20_';
% suf = '0412_0326_20_Fmeasure_sample_1_auto1_div5';
% batch_name = 'A-H_0610_274'
batch_name = batch_name;
date = '1023'
suf = [date,'_',batch_name,'_20_Fmeasure_',num2str(beta),'_div',num2str(divn),'_'];
load('C:\Users\Yuan Zhiyuan\Documents\MATLAB\SIMS_0820\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\274\cor_sort_ind.mat');
test_samples_processed = test_samples+1;
test_samples_processed = bsxfun(@rdivide,test_samples_processed,prctile(test_samples_processed,80,2));
test_samples_processed = log(test_samples_processed);
test_samples_processed = test_samples_processed(:,1:20);
test_samples_processed = test_samples(:,1:20);
%fg:2,bg:1
% test_samples = zeros(n_sites,n_matters);
rdpm = randperm(n_sites);
init_labeling = ones(n_sites,1);
init_labeling(rdpm(1:n_sites/2))=2;

% [init_labeling,C] = kmeans(test_samples_processed(:,1),2);
% if(C(1)>=C(2))
%     init_labeling = -init_labeling+3;
% end


[tmp_labeling,C] =kmeans(test_samples_processed(:,1),4);
[tmp,min_C_ind] = min(C);
init_labeling = tmp_labeling;
init_labeling(tmp_labeling==min_C_ind) = 1;
init_labeling(tmp_labeling~=min_C_ind) = 2;



cur_labeling = init_labeling;

% init_labeling = cur_labeling;
edges_sigma = 8;
lambda = 0.5;
% beta=0.5;
beta = beta;
% divn = divn;
% edge_suf = ['0328','_','8n_',num2str(Height),'_',num2str(Width),'_',num2str(lambda),'_',num2str(edges_sigma),'_undirected'];
edge_suf = ['0328','_','8ndist_',num2str(Height),'_',num2str(Width),'_',num2str(lambda),'_',num2str(edges_sigma),'_undirected'];

% init_labeling = cur_labeling;
global edges;
edges = ed;
% [edges] = get_BK_pairwise(Width,Height,lambda,test_samples,edges_sigma);
% Weights = get_BK_neighbor_weights2(Width,Height,weight_sigma,lambda,test_samples);
% save(['C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\pairwise_edges\edges_',edge_suf,'.mat'],'edges');
% load(['C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\pairwise_edges\edges_',edge_suf,'.mat'])
% Weights = Weights*10;
edges(:,3:end) = edges(:,3:end)/divn;
% edges(:,3:end) = 0;
n_hidden = 50;
n_epoch = 50;
test_samples_processed = (test_samples_processed-min(test_samples_processed(:)))/(max(test_samples_processed(:))-min(test_samples_processed(:)));
normed_data = test_samples_processed;
labeling_li = [];
init_iter = 1;
iters = init_iter
% imshow(reshape(cur_labeling,256,256)',[])
num_pos_li = [];
% hard_constraint = find(test_samples(:,1)>=20);
hard_constraint = [];
while(iters<=niters & sum(cur_labeling==2)>0)
%     disp(['C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\EM_mid_rst\cur_labeling_',num2str(iters),'.mat']);
%      save(['C:\Users\Yuan Zhiyuan\Documents\MATLAB\SIMS_0820\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\EM_mid_rst\cur_labeling_',suf,'_',num2str(iters),'.mat'],'cur_labeling');
save([save_pref,'\EM_mid_rst\cur_labeling_',suf,'_',num2str(iters),'.mat'],'cur_labeling');
   
disp(num2str(sum(cur_labeling==2)));
    num_pos_li = [num_pos_li,sum(cur_labeling==2)];
    labeling_li = [labeling_li,cur_labeling];
    [bg_rbm,fg_rbm,PF] = train_rbm_multi(normed_data,cur_labeling,n_hidden,n_epoch,beta);
    
    
     cur_labeling =MRF_MAP_RBM_BK_multi(Height,Width,bg_rbm,fg_rbm,normed_data,PF,hard_constraint,batch_name,iters);
     plot(init_iter:iters,num_pos_li)
     iters = iters+1;
   
end

