function nnplotsigp(nn,fhandle,L,opts,i)
%NNPLOTSIGP to be used with nnsigp
%      1) signalpeptide MCC
%       2) Cleavage site specificity
%       3) Cleavage site precision
%       4) Cleacage site MCC
%       5) transmembrane MCC
%
nplots = size(L.train.e_errfun,2)+1;
n_cols = 4.0;
n_rows = ceil(nplots / n_cols);

titles{1} = 'Signal peptide MCC';
titles{2} = 'Cleavage site specifity';
titles{3} = 'Cleavage site precision';
titles{4} = 'Cleavage site MCC';
titles{5} = 'Transmembrane MCC';

ytitle{1} = 'MCC';
ytitle{2} = 'Specificity';
ytitle{3} = 'Precision';
ytitle{4} = 'MCC';
ytitle{5} = 'MCC';

%    plotting
figure(fhandle);

x_ax = 1:i;     %create axis

% create training and validation plot
subplot(n_rows,n_cols,1);
p = plot(x_ax, L.train.e(x_ax), 'b', ...
    x_ax, L.val.e(x_ax), 'r');
legend(p, {'Training', 'Validation'},'Location','NorthWest');
xlabel('Number of epochs'); ylabel('Error');title('Error');
set(gca, 'Xlim',[0,opts.numepochs + 1])
%create subplots of correlations


for b = 1:nplots-1
    subplot(n_rows,n_cols,b+1);
    p = plot(x_ax, L.train.e_errfun(x_ax,b), 'b', ...
        x_ax, L.val.e_errfun(x_ax,b),   'm');
    ylabel(ytitle{b}); xlabel('Epoch'); 
    title(titles{b})
    legend(p, {'Training', 'Validation'},'Location','SouthEast');
    set(gca, 'Xlim',[0,opts.numepochs + 1])
    
end

drawnow;

end
