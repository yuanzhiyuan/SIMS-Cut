function [ hloss ] = cpLossToHost( dloss, opts )

hloss.train.e       = gather(dloss.train.e);
hloss.train.e_errfun  = gather(dloss.train.e_errfun);
if opts.validation == 1
    hloss.val.e         = gather(dloss.val.e);
    hloss.val.e_errfun  = gather(dloss.val.e_errfun);
end

end

