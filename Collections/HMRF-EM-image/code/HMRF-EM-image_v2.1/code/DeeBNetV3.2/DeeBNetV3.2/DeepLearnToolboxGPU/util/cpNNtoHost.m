function [ hnn ] = cpNNtoHost( dnn )
fld = fields(dnn);
for i=1:numel(fld)
    fieldName = fld{i};
    switch fieldName
        case 'W'
            for j=1:numel(dnn.W)
                hnn.W{j} = gather(dnn.W{j});
            end
        case 'b'
            for j=1:numel(dnn.b)
                hnn.b{j} = gather(dnn.b{j});
            end
        case 'vW'
            for j=1:numel(dnn.vW)
                hnn.vW{j} = gather(dnn.vW{j});
            end
        case 'vb'
            for j=1:numel(dnn.vb)
                hnn.vb{j} = gather(dnn.vb{j});
            end
        case 'dW'
            for j=1:numel(dnn.dW)
                hnn.dW{j} = gather(dnn.dW{j});
            end
        case 'db'
            for j=1:numel(dnn.db)
                hnn.db{j} = gather(dnn.db{j});
            end
        case 'p'
            for j=1:numel(dnn.p)
                hnn.p{j} = gather(dnn.p{j});
            end
        case 'a'
            for j=1:numel(dnn.p)
                hnn.a{j} = gather(dnn.a{j});
            end
        case 'isGPU'
            hnn.(fieldName) = 0;
        otherwise
            hnn.(fieldName) = gather(dnn.(fieldName));
            
    end
end