function nn = nnapplygrads(nn)
%NNAPPLYGRADS updates weights and biases with calculated gradients
% nn = nnapplygrads(nn) returns an neural network structure with updated
% weights and biases

for i = 1 : (nn.n - 1)
    
    %add learning rate
    db = nn.db{i} .* nn.learningRate;
    dW = nn.dW{i} .* nn.learningRate;
    
    % add w2 penalty
    if(nn.weightPenaltyL2>0)
        %Could be optimized ... (NOTE that there is a bug i Rasmus Bergs code here since wd is applied to both weights and bias')
        dW = dW + nn.weightPenaltyL2 * nn.W{i}* nn.learningRate;        
    end

    
    
     %apply momentum
    if(nn.momentum>0) 
        dW = dW + nn.momentum*nn.vW{i};   %add momentum
        nn.vW{i} = dW;                    %save momentum 
        
        db = db + nn.momentum*nn.vb{i};   %add bias momentum
        nn.vb{i} = db;                    %save bias momentum
    end
    
    %Update weights
    nn.W{i} = nn.W{i} - dW;
    nn.b{i} = nn.b{i} - db;
    
    %Max L2 norm of incoming weights to individual neurons
    if nn.weightMaxL2norm > 0;
        L2 = nn.weightMaxL2norm;
        %neruon inputs
        z = sum(nn.W{i}.^2,2)+nn.b{i}.^2;
        %normalization factor
        norm_factor = sqrt(z/L2);
        idx = norm_factor < 1;
        norm_factor(idx) = 1;
        %rescale weights and biases
        nn.W{i} = bsxfun(@rdivide,nn.W{i},norm_factor);
        nn.b{i} = bsxfun(@rdivide,nn.b{i},norm_factor);
    end
    
    
end
end
