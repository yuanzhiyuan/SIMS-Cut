function [ dnn ] = cpNNtoGPU( hnn,cast)
fld = fields(hnn);
for i=1:numel(fld)
    fieldName = fld{i};
    switch fieldName
        case 'W'
            for j=1:numel(hnn.W)
                dnn.W{j} = gpuArray(cast(hnn.W{j}));
            end
        case 'b'
            for j=1:numel(hnn.b)
                dnn.b{j} = gpuArray(cast(hnn.b{j}));
            end
        
        case 'vW'
            for j=1:numel(hnn.vW)
                dnn.vW{j} = gpuArray(cast(hnn.vW{j}));
            end
        case 'vb'
            for j=1:numel(hnn.vb)
                dnn.vb{j} = gpuArray(cast(hnn.vb{j}));
            end
        case 'p'
            for j=1:numel(hnn.p)
                dnn.p{j} = gpuArray(cast(hnn.p{j}));
            end
        case 'dW'
            for j=1:numel(hnn.dW)
                dnn.dW{j} = gpuArray(cast(hnn.dW{j}));
            end
        case 'e'
                dnn.e = gpuArray(cast(hnn.e));
        case 'a'
            for j=1:numel(hnn.a)
                dnn.a{j} = gpuArray(cast(hnn.a{j}));
            end
            
       % profiling shows that the performance is bestif the following
       % variables are left on the host
        case 'learningRate'
            dnn.(fieldName) = cast(hnn.(fieldName));
        case 'weightPenaltyL2'
            dnn.(fieldName) = cast(hnn.(fieldName));
        case 'dropoutFraction'
            dnn.(fieldName) = cast(hnn.(fieldName)); 
        case 'weightMaxL2norm'
            dnn.(fieldName) = cast(hnn.(fieldName));  
        case 'momentum'
            dnn.(fieldName) = cast(hnn.(fieldName));
        case 'inputZeroMaskedFraction'
            dnn.(fieldName) = cast(hnn.(fieldName));
        case 'isGPU'
            dnn.(fieldName) = 1;
        otherwise
            
            dnn.(fieldName) = hnn.(fieldName);
    end
end