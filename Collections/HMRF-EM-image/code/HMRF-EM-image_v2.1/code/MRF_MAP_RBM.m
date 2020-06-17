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

function [X sum_U]=MRF_MAP_RBM(X,Y,Z,RBM,k,MAP_iter,show_plot)
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

for it=1:MAP_iter % iterations
    fprintf('  Inner iteration: %d\n',it);
    U1=U;
    U2=U;
%     U1 = cal_free_energy(RBM,Y,[1,2,3]);
U1 = cal_free_energy(RBM,Y,[0,1]);
    
%     efeature = RBM.getFeature(gdata,1,[],glabel);
%     [p_l,gdata,glabel] = cal_label_prior(RBM,efeature,100,100);
%     p_l = p_l+0.1;
%     p_l = cal_label_prior(RBM,zeros(1,10),100,1000);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%实验二的p
p_l = [0.4330,0.5670];





%%%%%%%%%%%%%%%%%%%%%%%%%%%%下面是试验1的p
% p_l = [0.1400,0.5700,0.2900];     %好
% p_l = [0.1800,0.4400,0.3800];    %不好
% p_l = [0.1500,0.4900,0.3600];  %好
% p_l = [0.1450,0.5080,0.3470];  %好
% p_l = [1,1,1];
    U1 = U1 + repmat(log(p_l),[size(Y,1),1]);
%     for aa=1:size(Y,1)
%        [p_l] = cal_label_prior(RBM,Y(aa,:),10,5);
%        U1(aa,:) = U1(aa,:)+log(p_l);
%     end
%     U1(:,1) = U1(:,1)+log(p_l(1));
%     U1(:,2) = U1(:,2) + log(p_l(2));
%    U1(:,3) = U1(:,3) + log(p_l(3));
    %这里还要加上log(p(l))
    for l=1:k % all labels
%         temp2 = 0;
%         for aa=1:size(mu,2)
%             yi=y-mu(l,aa);
%             temp1=yi.*yi/sigma(l,aa)^2/2;
%             temp1=temp1+log(sigma(l,aa));
%             temp2 = temp2+temp1;
%         end
        
%         yi=y-mu(l);
%         temp1=yi.*yi/sigma(l)^2/2;
%         temp1=temp1+log(sigma(l));
%         U1(:,l)=U1(:,l)+temp2;
        
        
        for ind=1:m*n % all pixels
            [i j]=ind2ij(ind,m);
            u2=0;
            if i-1>=1 && Z(i-1,j)==0
                u2=u2+(l ~= X(i-1,j))/2;
            end
            if i+1<=m && Z(i+1,j)==0
                u2=u2+(l ~= X(i+1,j))/2;
            end
            if j-1>=1 && Z(i,j-1)==0
                u2=u2+(l ~= X(i,j-1))/2;
            end
            if j+1<=n && Z(i,j+1)==0
                u2=u2+(l ~= X(i,j+1))/2;
            end
            U2(ind,l)=u2;
        end
    end
    U=U1+U2*0.2;
%     U = U1/size(mu,2) + U2;
    [temp x]=min(U,[],2);
    sum_U_MAP(it)=sum(temp(:));
    
    X=reshape(x,[m n]);
%     if it>=3 && std(sum_U_MAP(it-2:it))/sum_U_MAP(it)<0.0001
%         break;
%     end
end

sum_U=0;
for ind=1:m*n % all pixels
    sum_U=sum_U+U(ind,x(ind));
end
if show_plot==1
    figure;
    plot(1:it,sum_U_MAP(1:it),'r');
    title('sum U MAP');
    xlabel('MAP iteration');
    ylabel('sum U MAP');
    drawnow;
end
