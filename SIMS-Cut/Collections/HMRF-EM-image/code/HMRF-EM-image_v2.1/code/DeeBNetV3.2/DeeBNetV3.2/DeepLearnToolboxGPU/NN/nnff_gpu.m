function nn = nnff_gpu(nn, x, y)
%NNFF performs a feedforward pass
% nn = nnff(nn, x, y) returns an neural network structure with updated
% layer activations, error and loss (nn.a, nn.e and nn.L)

n = nn.n;
m = size(x, 1);
nn.a{1} = x;
cast = @nn.cast;
cstr = nn.caststr;
%feedforward pass
for i = 2 : n-1
    
    %calculate activation of each layer, except output layer
    z = bsxfun(@plus, nn.a{i - 1} * nn.W{i - 1}',nn.b{i-1}'); %input to each layer
    switch nn.activation_function
        case 'sigm'
            % Calculate the unit's outputs (including the bias term)
            nn.a{i} = sigm(z);
        case 'tanh_opt'
            nn.a{i} = tanh_opt(z);
        case 'ReLU'  % linear rectified units max(0,x)
            nn.a{i} = ReLU(z);
    end
    
    %dropout hidden layers
    if(nn.dropoutFraction > 0)
        if(nn.testing)
            nn.a{i} = nn.a{i}.*(1 - nn.dropoutFraction);
        else
            nn.dropOutMask{i} = gpuArray.rand(size(nn.a{i}),cstr)>nn.dropoutFraction;
            nn.a{i} = nn.a{i}.*nn.dropOutMask{i};
        end
    end
    
    
    %calculate running exponential activations for use with sparsity
    if(nn.nonSparsityPenalty>0)
        nn.p{i} = 0.99 * nn.p{i} + 0.01 * mean(nn.a{i}, 1);
    end
    
end

% Calculate output of NN
z = bsxfun(@plus,nn.a{n - 1} * nn.W{n - 1}',nn.b{n-1}');
switch nn.output
    case 'sigm'
        nn.a{n} = sigm(z);
    case 'linear'
        nn.a{n} = z;
    case 'nnsoftmax'
        %numerically stable calc of softmax
        class_normalizer = log_sum_exp_over_cols(z);
        log_class_prob = bsxfun(@minus,z,class_normalizer);
        nn.a{n} = exp(log_class_prob);
        %%%OLD CODE
        %nn.a{n} = nn.a{n - 1} * nn.W{n - 1}';
        %nn.a{n} = exp(bsxfun(@minus, nn.a{n}, max(nn.a{n},[],2)));
        %nn.a{n} = bsxfun(@rdivide, nn.a{n}, sum(nn.a{n}, 2));
        
end

%error and loss
nn.e = y - nn.a{n};

switch nn.output
    case {'sigm', 'linear'}
        nn.L = 1/2 * sum(sum(nn.e .^ 2)) / m; % MSE
    case 'nnsoftmax'
        %nn.L = -sum(sum(y .* log(nn.a{n}))) / m; %OLD CODE
        nn.L = -sum(sum(y.*log_class_prob)) / m; %mean cross entropy
end
end
