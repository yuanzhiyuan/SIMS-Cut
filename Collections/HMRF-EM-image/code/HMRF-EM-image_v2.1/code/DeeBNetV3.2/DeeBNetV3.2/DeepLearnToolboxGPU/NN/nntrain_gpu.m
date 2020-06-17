function [hnn, L,hloss]  = nntrain_gpu(hnn, htrain_x, htrain_y, opts, hval_x, hval_y)
%NNTRAIN trains a neural net on cpu
% [nn, L] = nnff(nn, x, y, opts) trains the neural network nn with input x and
% output y for opts.numepochs epochs, with minibatches of size
% opts.batchsize. Returns a neural network nn with updated activations,
% errors, weights and biases, (nn.a, nn.e, nn.W, nn.b) and L, the sum
% squared error for each training minibatch.
%
% hVARNAME is a variable on the host
% dVARNAME is a varibale on the gpu device
%
% ####TODO#####
%
%  FIX FRAGMENTION OF MEMORY, I.E CLEAR INTERMEDIATE VARIABLES
%       * SEE http://www.mathworks.se/help/matlab/matlab_prog/strategies-for-efficient-use-of-memory.html
%       * http://www.mathworks.com/matlabcentral/answers/28500
%       * A easy fix would be to reset gpu device and reload data every 100
%       ish epoch.
%   
gpu = gpuDevice();

%change by keyvarad
% reset(gpu);
% wait(gpu);

disp(['GPU memory available (Gb): ', num2str(gpu.FreeMemory / 10^9)]);
cast = hnn.cast;
caststr = hnn.caststr;
assert(nargin == 4 || nargin == 6,'number ofinput arguments must be 4 or 6')


hnn.isGPU = 0; % tell code that variables are not on gpu (this is the HOSTnn)


m = size(htrain_x, 1);

if ~isempty(hnn.errfun)   %determine number of returned error values
 nerrfun =  numel(hnn.errfun(hnn, htrain_x(1,:), htrain_y(1,:)));
 dloss.train.e_errfun        = gpuArray.zeros(opts.numepochs,nerrfun);
 dloss.val.e_errfun          = gpuArray.zeros(opts.numepochs,nerrfun);
else
dloss.train.e_errfun        = [];
 dloss.val.e_errfun         = [];
end


dloss.train.e               = gpuArray.zeros(opts.numepochs,1);
dloss.val.e                 = gpuArray.zeros(opts.numepochs,1);

corrfoeff_old = -999999999;

if nargin == 6
    opts.validation = 1;
else
    opts.validation = 0;
end


fhandle = [];
if isfield(opts,'plot') && opts.plot == 1
    fhandle = figure();
    %check if plotting function is supplied, else use nnupdatefigures
    if ~isfield(opts,'plotfun')  || isempty(opts.plot)
        opts.plotfun = @nnupdatefigures;
    end
    
end

if isfield(opts, 'outputfolder') && ~isempty(opts.outputfolder)
    save_nn_flag = 1;
else
    save_nn_flag = 0;
end

%variable momentum
if isfield(opts, 'momentum_variable') && ~isempty(opts.momentum_variable)
    if length(opts.momentum_variable) ~= opts.numepochs
        error('opts.momentum_variable must specify a momentum value for each epoch ie length(opts.momentum_variable) == opts.numepochs')
    end
    var_momentum_flag = 1;
else
    var_momentum_flag = 0;
end

%variable learningrate
if isfield(opts, 'learningRate_variable') && ~isempty(opts.learningRate_variable)
    if length(opts.learningRate_variable) ~= opts.numepochs
        error('opts.learningRate_variable must specify a learninrate value for each epoch ie length(opts.learningRate_variable) == opts.numepochs')
    end
    var_learningRate_flag = 1;
else
    var_learningRate_flag = 0;
end

batchsize = opts.batchsize;
numepochs = opts.numepochs;
numbatches = floor(m / batchsize);
L = zeros(numepochs*numbatches,1);
n = 1;
              
dnn = cpNNtoGPU(hnn,cast);   % COPY NETWORK TO DEVICE


for i = 1 : numepochs
    epochtime = (tic);
    %update momentum
    if var_momentum_flag
        hnn.momentum = opts.momentum_variable(i);
        dnn.momentum = opts.momentum_variable(i);
    end
    %update learning rate
    if var_learningRate_flag
        hnn.learningRate = opts.learningRate_variable(i);
        dnn.learningRate = opts.learningRate_variable(i);
    end
    
    kk = randperm(m);
    for l = 1 : numbatches
        
        hbatch_x = extractminibatch(kk,l,batchsize,htrain_x);
        
        %Add noise to input (for use in denoising autoencoder)
        if(hnn.inputZeroMaskedFraction ~= 0)
            hbatch_x = hbatch_x.*(gpuArray.rand(size(hbatch_x),caststr)>hnn.inputZeroMaskedFraction);
        end
        
        % COPY BATCHES TO GPU DEVICE
        dbatch_x = gpuArray(cast(hbatch_x));
        dbatch_y = gpuArray(cast(extractminibatch(kk,l,batchsize,htrain_y)));
        
        % use gpu functions to train
        dnn = nnff_gpu(dnn, dbatch_x, dbatch_y);
        dnn = nnbp_gpu(dnn);
        dnn = nnapplygrads(dnn);
        L(n) = gather(dnn.L);
        n = n + 1;
    end
    
    t = toc(epochtime);
    evalt = tic;
    if i==1
        %draws sample from training data
        sample = randsample(m,opts.ntrainforeval);
        dtrain_x = gpuArray(cast(htrain_x(sample,:)));
        dtrain_y = gpuArray(cast(htrain_y(sample,:)));
        
        if opts.validation == 1
            dval_x = gpuArray(hval_x);
            dval_y = gpuArray(hval_y);
        end
    end   
    
    %after each epoch update losses
    if opts.validation == 1
        dloss = nneval(dnn, dloss,i, dtrain_x, dtrain_y, dval_x, dval_y);
    else
        dloss = nneval(dnn, dloss,i, dtrain_x, dtrain_y);
    end
       
    % plot if figure is available
    if ishandle(fhandle)
        hloss = cpLossToHost(dloss,opts);
        opts.plotfun([], fhandle, hloss, opts, i);
        
        
        %save figure to the output folder after every 10 epochs
        if save_nn_flag && mod(i,10) == 0
            save_figure(fhandle,opts.outputfolder,2,[40 25],14);
            disp(['Saved figure to: ' opts.outputfolder]);
        end
        
    end
    
    t2 = toc(evalt);
    disp(['epoch ' num2str(i) '/' num2str(opts.numepochs)  ...
        '. Took ' num2str(t) ' seconds' '. Mean squared error on training set is '...
        num2str(mean(L((n-numbatches):(n-1))))])
    disp(['         Eval time: ' num2str(t2) ...
        '. LearningRate: ', num2str(hnn.learningRate) '.Momentum : ' num2str(hnn.momentum)...
        '. free gpu mem (Gb): ', num2str(gpu.FreeMemory./10^9)]);
    
    %save model after every 100 epochs
    if save_nn_flag && mod(i,100) == 0
            epoch_nr = i;
            hloss = cpLossToHost(dloss,opts);
            hnn = cpNNtoHost(dnn);
            save([opts.outputfolder '_epochnr' num2str(epoch_nr) '.mat'],'hnn','opts','epoch_nr','hloss');
            disp(['Saved weights to: ' opts.outputfolder]);
    end
end

% get network from gpu
hnn = cpNNtoHost(dnn);

%fetch error data from gpu
hloss = cpLossToHost(dloss, opts);

%clear gpu data. nessesary???
clear dnn
clear dbatch_x
clear dbatch_y

%change by keyvarad
% reset(gpu);
% wait(gpu);
end
