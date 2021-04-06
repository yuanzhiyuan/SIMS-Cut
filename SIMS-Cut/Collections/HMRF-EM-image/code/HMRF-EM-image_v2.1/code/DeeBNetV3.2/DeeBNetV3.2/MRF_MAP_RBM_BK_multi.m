function[Labeling] =MRF_MAP_RBM_BK_multi(Height,Width,bg_rbm,fg_rbm,x,PF,hard_constraint,batch_name,iters)
addpath('C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\Kernel graph cut image segmentation\code\Bk_matlab');
Height = 256;
Width = 256;

% hela_pref = 'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\hela10a_seg_result\'
% bg_rbm = 'hela_bg_rbm.mat';
% fg_rbm = 'hela_fg_rbm.mat';
% load([hela_pref,bg_rbm]);
% load([hela_pref,fg_rbm]);






Num_Sites = Height*Width;
h = BK_Create(Num_Sites);
%Num_sites表示像素点的数量

neighbor_weight = 0.2;
% neighbor_weight = 0;
global edges;
% Weights = get_BK_neighbor_weights(Width,Height,neighbor_weight);
% load('qiepian_seg_result/bk_weights.mat');
% load('C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\BK_neighbor_weight\Weights_256_0.2.mat');
% BK_SetNeighbors(h,Weights);
%Weights类似于GCO_SetNeighbors
%setNeighbors和SetPairwise只用其中一个

% Edges = get_BK_pairwise(Width,Height,0.15,x);
BK_SetPairwise(h,edges);
%     BK_SetPairwise(Handle,Edges) determines which sites are neighbors
%     and what their specific interaction potential is. 
%     Edges is a dense NumEdges-by-6 matrix of doubles 
%     (or int32 of CostType is 'int32'; see BK_BuildLib). 
%     Each row is of the format [i,j,e00,e01,e10,e11] where i and j 
%     are neighbours and the four coefficients define the interaction 
%     potential.
%     SetNeighbors cannot currently be called after Minimize. 
Costs = get_BK_unary_costs3(bg_rbm,fg_rbm,x,PF,hard_constraint,batch_name,iters);
Costs = Costs';
BK_SetUnary(h,Costs)
% BK_SetUnary   Set the unary cost of individual variables.
%    BK_SetUnary(Handle,Costs) accepts a 2-by-NumVars 
%    int32 matrix where Costs(k,i) is the cost of assigning
%    label k to site i. In this case, the MATLAB matrix is pointed to 
%    by the C++ code, and so a DataCost array is not copied.
%
%    TODO: document behaviour for dynamic graph cuts
%
Energy = BK_Minimize(h);
Labeling = BK_GetLabeling(h);

img = reshape(Labeling,Height,Width)';
% imshow(reshape(Labeling,Height,Width)',[])

