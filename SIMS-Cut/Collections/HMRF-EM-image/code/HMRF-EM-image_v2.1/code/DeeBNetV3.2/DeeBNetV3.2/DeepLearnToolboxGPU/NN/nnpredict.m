function labels = nnpredict(nn, x)
if nn.isGPU  % check if neural network is on gpu or not
    nnfeedforward = @nnff_gpu;
else
    nnfeedforward = @nnff;
end

nn.testing = 1;
nn = nnfeedforward(nn, x, zeros(size(x,1), nn.size(end)));
nn.testing = 0;

[~, i] = max(nn.a{end},[],2);
labels = i;
end
