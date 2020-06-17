%% This is a demo showing how to use this toolbox

%   Copyright by Quan Wang, 2012/04/25
%   Please cite: Quan Wang. HMRF-EM-image: Implementation of the 
%   Hidden Markov Random Field Model and its Expectation-Maximization 
%   Algorithm. arXiv:1207.3510 [cs.CV], 2012.

% clear;clc;close all;

mex BoundMirrorExpand.cpp;
mex BoundMirrorShrink.cpp;

% I=imread('Beijing World Park 8.JPG');
% I = imread('figure2.JPG');

% x = train_samples_normed(:,idxs==1);
% Y = reshape(x(:,1),256,256);
% Y = m_f1;

% Y=rgb2gray(I);
% Z = edge(Y,'canny',0.75);

% imwrite(uint8(Z*255),'edge.png');

% Y=double(Y);
% Y=gaussianBlur(Y,3);
% imwrite(uint8(Y),'blurred image.png');

k=2;
EM_iter=10; % max num of iterations
MAP_iter=30; % max num of iterations

% mu = [17.0055;9.6542;0.035300237970312];
% sigma = [19.9526;11.5879;0.1247];
% ith_matter = 40;

% tic;
% fprintf('Performing k-means segmentation\n');
% [X, mu, sigma]=image_kmeans(Y,k);
% bg_mean = 0.035300237970312;
% bg_var = 0.1247;
% mu = [mean_de(ith_matter),mean_ds(ith_matter),bg_mean];
% sigma = sqrt([var_de(ith_matter),var_ds(ith_matter),bg_var]);
% mu = [17.0055;9.6542;0.035300237970312];
% sigma = sqrt([19.9526;11.5879;0.1247]);
% mu_all = [mean_de;mean_ds;bg_mean*ones(size(mean_de))];
% sigma_all =sqrt([var_de;var_ds;bg_var*ones(size(mean_de))]);

% ith_matters = [14:14];

% mu_all = mu_all(:,ith_matters);
% sigma_all = sigma_all(:,ith_matters);
%  load('C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\+DEDS\deds_input.mat');
%  x = get_all_matter_merge(all_matters_de,all_matters_ds);
% imwrite(uint8(X*120),'initial labels.png');
x = train_samples_normed(:,idxs==1);

% [X, mu, sigma]=HMRF_EM(X,Y,Z,mu,sigma,k,EM_iter,MAP_iter);
% [X, tmp]=MRF_MAP(X,Y,Z,mu,sigma,k,MAP_iter,1);
% [X, tmp]=MRF_MAP_multi(X,Y,Z,mu_all,sigma_all,k,MAP_iter,1);
ptest = rbm.predictClass(x);
X = reshape(ptest,256,256);
X=X+1;
[X]=MRF_MAP_RBM_2(X,x,rbm,k,MAP_iter,1);

imwrite(uint8(X*120),'final labels.png');
toc;