function nnupdatefigures(nn,fhandle,L,opts,i)
%NNUPDATEFIGURES updates figures during training
    

    %    plotting
    figure(fhandle); 
    x_ax = 1:i;
    if opts.validation == 1 
        p = semilogy(x_ax, L.train.e(x_ax), 'b', ...
                 x_ax, L.val.e(x_ax), 'r');
        legend(p, {'Training', 'Validation'},'Location','NorthEast');
    else
        p = semilogy(x_ax,L.train.e(x_ax),'b');
        legend(p, {'Training'},'Location','NorthEast');
    end    
    xlabel('Number of epochs'); ylabel('Error');title('Error');    
    set(gca, 'Xlim',[0,opts.numepochs + 1])

    if i ==1 % speeds up plotting by factor of ~2
        set(gca,'LegendColorbarListeners',[]);
        setappdata(gca,'LegendColorbarManualSpace',1);
        setappdata(gca,'LegendColorbarReclaimSpace',1);

    end
    drawnow;
end