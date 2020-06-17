%%  The MAP algorithm
%---input---------------------------------------------------------
%   X: initial 2D labels
%   Y: image
%   Z: 2D constraints
%   mu: vector of means
%   sigma: vector of standard deviations
%   k: number of labels
%   MAP_iter: maximum number of iterations of the MAP algorithm
%   show_plot: 1 for showing a plot of energy in each iteration
%       and 0 for not showing
%---output--------------------------------------------------------
%   X: final 2D labels
%   sum_U: final energy

%   Copyright by Quan Wang, 2012/04/25
%   Please cite: Quan Wang. HMRF-EM-image: Implementation of the 
%   Hidden Markov Random Field Model and its Expectation-Maximization 
%   Algorithm. arXiv:1207.3510 [cs.CV], 2012.

function [X]=MRF_MAP_RBM_2(X,Y,RBM,k,MAP_iter,show_plot)
%Y:16384*40 

%normalize Y
x_min = 0;
x_max = 81;
% Y = (Y-x_min)/(x_max-x_min);


[m n]=size(X);
x=X(:);
% y=Y(:);
U=zeros(m*n,k);
sum_U_MAP=zeros(1,MAP_iter);
% p_l = [0.2729,0.4889,0.2383];
% p_l = [1,1,1];
% p_l = [0.2,0.5,0.3];
% [p_l] = cal_label_prior(rbm,0.2*ones(1,40),100,10)
% [p_l_init,gdata,glabel] = cal_label_prior(RBM,zeros(1,10),1,20000);
U1 = cal_free_energy(RBM,Y,[0,1]);
p_l = [0.4330,0.5670];
U1 = U1 + repmat(log(p_l),[size(Y,1),1]);
U_sum_list = [];
MAP_iter=10;

% 100*100£¬Ö»Ëãlabelenergy£º97.46Ãë
% 100*100£¬Ö»Ëãdataenergy £º34.32Ãë
% 100*100£¬¶¼Ëã£º129.47Ãë
% m=100;
% n=100;
for it=1:MAP_iter % iterations
%     disp([num2str(it),'th iterates']);
tic;
    for i=1:m
       for j=1:n
            label_energy = zeros(1,3);
            data_energy = zeros(1,3);
            for q=1:k
               X(i,j)=q;
                label_energy(q) = cal_ising_energy(X,1,0);
               data_energy(q) = cal_data_energy(U1,X);
% data_energy(q) = 0;
            end
%             idx = n*(i-1)+j;
idx = m*(i-1)+j;
            [tmp,X(i,j)] = min(label_energy+data_energy);
            U_sum_list = [U_sum_list,tmp];
            disp([num2str(it),'th iterates,',num2str(idx),'th pixel']);
       
       end
    end
    toc;
 
    
   
%     if it>=3 && std(sum_U_MAP(it-2:it))/sum_U_MAP(it)<0.0001
%         break;
%     end
end


if show_plot==1
    figure;
    plot(1:length(U_sum_list),U_sum_list,'r');
    title('sum U MAP');
    xlabel('MAP iteration');
    ylabel('sum U MAP');
    drawnow;
end
