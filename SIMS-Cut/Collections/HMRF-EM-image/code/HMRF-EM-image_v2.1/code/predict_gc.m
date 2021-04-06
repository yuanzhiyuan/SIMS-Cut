function[labeling] = predict_gc(Height,Width,rbm,label_prior,test_samples)

addpath('C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\Kernel graph cut image segmentation\code\Bk_matlab');
% Height = 128;
% Width = 128;
% A549_pref = 'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\+A549\';
% trained_rbm = 'trained_rbm_10_20_200.mat'
% load([A549_pref,trained_rbm]);
% x = train_samples/max(train_samples(:));
x = test_samples/max(test_samples(:));
Num_Sites = Height*Width;
h = BK_Create(Num_Sites);
%Num_sites表示像素点的数量

neighbor_weight = 0.2;
% neighbor_weight = 0;
Weights = get_BK_neighbor_weights(Width,Height,neighbor_weight);
BK_SetNeighbors(h,Weights);
%Weights类似于GCO_SetNeighbors
%setNeighbors和SetPairwise只用其中一个

% Edges = get_BK_pairwise(Width,Height,0.15,x);
% BK_SetPairwise(h,Edges);
%     BK_SetPairwise(Handle,Edges) determines which sites are neighbors
%     and what their specific interaction potential is. 
%     Edges is a dense NumEdges-by-6 matrix of doubles 
%     (or int32 of CostType is 'int32'; see BK_BuildLib). 
%     Each row is of the format [i,j,e00,e01,e10,e11] where i and j 
%     are neighbours and the four coefficients define the interaction 
%     potential.
%     SetNeighbors cannot currently be called after Minimize. 
Costs = get_BK_unary_costs(rbm,x,label_prior);
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
labeling = BK_GetLabeling(h);


imshow(reshape(labeling,Height,Width)',[])

