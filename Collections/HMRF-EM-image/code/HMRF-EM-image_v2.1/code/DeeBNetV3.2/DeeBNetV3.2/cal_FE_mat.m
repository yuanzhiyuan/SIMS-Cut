

batch_files = {
    'AB-A',
    'AB-H',
    'AB-H-1',
    'AB-A_0521',
    'HB-A_0521',
    'HB-H_0521',
    
    'AB-H-3_0604',
    'AB-H-4_0604',
    'HB-A-2_0604',
    'HB-A-3_0604',
    'A-H_0610',
    'H-M_0610',
    'H-A-M_0610'
};
path = 'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\';
labeling_files = {
    
   'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\�м���\AB-A_labeling.mat',
   'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\�м���\AB-H_labeling.mat',
   'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\�м���\AB-H-1_labeling.mat',
   'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\�м���\AB-A_0521_labeling.mat',
   'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\�м���\HB-A_0521_labeling.mat',
   
   'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\�м���\HB-H_0521_labeling.mat',
   
   
   
   'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\�м���\AB-H-3_0604_labeling.mat',
   'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\�м���\AB-H-4_0604_labeling.mat',
   'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\�м���\HB-A-2_0604_labeling.mat',
   'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\�м���\HB-A-3_0604_labeling.mat',
   'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\�м���\A-H_0610_labeling.mat',
   'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\�м���\H-M_0610_labeling.mat',
   'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\�м���\H-A-M_0610_labeling.mat'
   
};

FE_dict = {};



for i=1:13
load([path,batch_files{i},'_20.mat']);
load(labeling_files{1});
Height = 256;
Width = 256;
n_matter = 20;
n_sites = Height*Width;
% suf = '0403_0328_20_Fmeasure_0.8_lambda_0.1_sigma_8_undirected_8n_dist';
% suf = '0403_0328_20_Fmeasure_0.8_2gradmax1_1sigma5_comdiv15';
% suf ='0403_0328_20_Fmeasure_0.8_1gradmax1_1auto2_comdiv20_';
% suf = '0412_0326_20_Fmeasure_sample_1_auto1_div5';
batch_name = batch_files{i}
date = '0614'
% suf = [date,'_',batch_name,'_20_Fmeasure_0.5_ada21auto_div5_'];

%fg:2,bg:1
% test_samples = zeros(n_sites,n_matters);
% rdpm = randperm(n_sites);
% init_labeling = ones(n_sites,1);
% init_labeling(rdpm(1:n_sites/2))=2;

% init_labeling = kmeans(test_samples(:,1),2);
init_labeling = final_labeling;
% init_labeling = cur_labeling;
edges_sigma = 8;
lambda = 1;
beta=0.8;
% edge_suf = ['0328','_','8n_',num2str(Height),'_',num2str(Width),'_',num2str(lambda),'_',num2str(edges_sigma),'_undirected'];
% edge_suf = ['0328','_','8ndist_',num2str(Height),'_',num2str(Width),'_',num2str(lambda),'_',num2str(edges_sigma),'_undirected'];

% init_labeling = cur_labeling;
% global edges;
% edges = ada_edges;
% % [edges] = get_BK_pairwise(Width,Height,lambda,test_samples,edges_sigma);
% % Weights = get_BK_neighbor_weights2(Width,Height,weight_sigma,lambda,test_samples);
% % save(['C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\pairwise_edges\edges_',edge_suf,'.mat'],'edges');
% % load(['C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\pairwise_edges\edges_',edge_suf,'.mat'])
% % Weights = Weights*10;
% edges(:,3:end) = edges(:,3:end)/5;
% edges(:,3:end) = 0;
cur_labeling = init_labeling;
n_hidden = 50;
n_epoch = 50;
normed_data = test_samples/max(test_samples(:));
labeling_li = [];
iters = 1;
num_pos_li = [];
hard_constraint = [];

[bg_rbm,fg_rbm,PF] = train_rbm_multi(normed_data,cur_labeling,n_hidden,n_epoch,beta);
    

Costs=get_BK_unary_costs3(bg_rbm,fg_rbm,normed_data,PF,hard_constraint,batch_name,iters);
FE_dict{i} = Costs;
end