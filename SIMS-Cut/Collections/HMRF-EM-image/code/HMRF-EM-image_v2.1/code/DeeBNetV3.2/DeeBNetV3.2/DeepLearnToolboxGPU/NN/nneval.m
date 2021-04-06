function loss = nneval(nn, loss,i,train_x, train_y, val_x, val_y)
%NNEVAL evaluates performance of neural network
% updates loss struct
if nn.isGPU  % check if neural network is on gpu or not
    nnfeedforward = @nnff_gpu;
else
    nnfeedforward = @nnff;
end
   
assert(nargin == 5 || nargin == 7,'Wrong number of arguments');

% training performance
nn           = nnfeedforward(nn, train_x, train_y);
loss.train.e(i) = nn.L;

% validation performance
if nargin == 7
    nn           = nnfeedforward(nn, val_x, val_y);
    loss.val.e(i)= nn.L;
end

%If error function is supplied apply it
if ~isempty(nn.errfun)
    [er_train, ~]               = nn.errfun(nn, train_x, train_y);
    loss.train.e_errfun(i,:)    = er_train;
    
    if nargin == 7
        [er_val, ~]             = nn.errfun(nn, val_x, val_y);
        loss.val.e_errfun(i,:)  = er_val;
    end
end

end
