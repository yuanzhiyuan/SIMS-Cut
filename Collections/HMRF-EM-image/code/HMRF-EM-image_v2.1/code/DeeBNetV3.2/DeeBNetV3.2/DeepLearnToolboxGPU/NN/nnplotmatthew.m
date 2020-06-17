function nnplotmatthew(nn,fhandle,L,opts,i)
%NNPLOTMATTHEW Used with matthew correlation coefficient. 
% Plots all coefficients and training error. Used with opts.errfun set to
% @matthew.

%

    nclassplots = size(L.train.e_errfun,2);
    nplots = nclassplots + 1;
    
    n_cols = 4.0;
    n_rows = ceil(nplots / n_cols);
    

    %    plotting
    figure(fhandle); 
    
    x_ax = 1:i;     %create axis
    
    if opts.validation == 1
        
        % tranining error plot
        subplot(n_rows,n_cols,1);
        p = plot(x_ax, L.train.e(x_ax), 'b', ...
                 x_ax, L.val.e(x_ax), 'r');
        legend(p, {'Training', 'Validation'},'Location','SouthWest');
        xlabel('Number of epochs'); ylabel('Error');title('Error');    
        set(gca, 'Xlim',[0,opts.numepochs + 1])
        %create subplots of correlations
        
        for b = 1:nclassplots-1
            subplot(n_rows,n_cols,b+1);
            p = plot(x_ax, L.train.e_errfun(x_ax,b), 'b', ...
                     x_ax, L.val.e_errfun(x_ax,b),   'm');
            
            
            title(sprintf('Matthew correlation: Class %i',b))
            legend(p, {'Training', 'Validation'},'Location','Best');
            set(gca, 'Xlim',[0,opts.numepochs + 1])
        end
            
        %plot total MCC
            subplot(n_rows,n_cols,nplots);
            p = plot(x_ax, L.train.e_errfun(x_ax,nclassplots), 'b', ...
                     x_ax, L.val.e_errfun(x_ax,nclassplots),   'm');
            ylabel('MCC'); xlabel('Epoch'); 
            title(sprintf('Matthew correlation: ALL CLASSES'))
            legend(p, {'Training', 'Validation'},'Location','Best');
            set(gca, 'Xlim',[0,opts.numepochs + 1])  
        
        
    else  % no validation
        subplot(n_rows,n_cols,1);
        p = plot(x_ax,L.train.e(x_ax),'b');
        legend(p, {'Training'},'Location','NorthEast');
        xlabel('Number of epochs'); ylabel('Error');title('Error');    
        set(gca, 'Xlim',[0,opts.numepochs + 1])
        
        for b = 1:nclassplots-1
            
            
            
            subplot(n_rows,n_cols,b+1);
            p = plot(x_ax, L.train.e_errfun(x_ax,b), 'b');
            ylabel('MCC'); xlabel('Epoch'); 
            title(sprintf('Matthew correlation: Class %i',b))
            legend(p, {'Training'},'Location','Best');
            set(gca, 'Xlim',[0,opts.numepochs + 1])
            
        end
        % plot total mcc
            subplot(n_rows,n_cols,nplots);
            p = plot(x_ax, L.train.e_errfun(x_ax,nclassplots), 'b');
            ylabel('MCC'); xlabel('Epoch'); 
            title(sprintf('Matthew correlation: ALL CLASSES'))
            legend(p, {'Training'},'Location','Best');
            set(gca, 'Xlim',[0,opts.numepochs + 1])
        
    end    
    
    drawnow;
    

    
end