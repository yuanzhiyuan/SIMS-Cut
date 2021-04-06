function opts = nnopts_setup
    %Initilazies the opts struct to default values.
    opts.validation             = 1;     %is overruled by the number of arguments in nntrain - ie. nntrain must have 6 input arguments for opts.validation = 1
    opts.plot                   = 0;     %Plots the training progress if set
    opts.plotfun                = @nnupdatefigures; %alternatives: nnplotmatthews;
    opts.outputfolder           = '';   %If set the network is saved to the path specified by outpufolder after every ten epochs. If plot is enabled the figure is also saved here.  
    opts.learningRate_variable  = [];   %if set specifies a momentum for every epoch. ie length(opts.momentum) == opts.numepochs.
    opts.momentum_variable      = [];   %if set specifies a learning rate for every epoch. ie length(opts.learningRate_variable) == opts.numepochs.
    opts.numepochs              = 1;    %number of runs through the complete training data set
    opts.batchsize              = 100;  %Number of traning examples to average gradient over
    opts.ntrainforeval          = [];   %Only relevant for GPU training. Sets the number of evaluation training datasets to use. Set this parameter to something small if you run into memory problems ?? Better explanation possibly
end