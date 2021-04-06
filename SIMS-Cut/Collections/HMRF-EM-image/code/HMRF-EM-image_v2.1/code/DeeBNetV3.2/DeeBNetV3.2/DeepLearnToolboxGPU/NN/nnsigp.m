function [err, bad] = nnsigp(nn, x, y)
%NNSIGP Calculate erros for signalP network
% For a network with 4 output classes in the follwing order the error
% measure in [...] is calculated and returned:
%       1) signalpeptide (S)    [MCC]
%       2) cleavage site (C)    [Specificity , precision, MCC]
%       3) transmembrane (T)    [MCC]
%       4) other         (.)    No error calculated
% The errors are returned in the following order
%       1) signalpeptide MCC
%       2) Cleavage site specificity
%       3) Cleavage site precision
%       4) Cleacage site MCC
%       5) transmembrane MCC

bad = [];
n_samples = size(x,1);
n_output = size(y,2);

assert(n_output~=1,'Behavior of matthew correlation not tested with single output')

% predict labels with network

pred = nnpredict(nn, x);


% find correct targets
[~, expected] = max(y,[],2);

if nn.isGPU
    confusionmat = gpuArray.zeros(2,2,n_output);
    err = gpuArray.zeros(1,5);
else
    confusionmat = zeros(2,2,n_output);
    err = zeros(1,5);
end

for target_class = 1:n_output    % testing: set to four
    
    %create binary vectors for each class. For each class (target_class)
    % match the predition with target class and the expected class with the
    % target class
    pred_class = ~(pred     == target_class);
    true_class = ~(expected == target_class); 
    confusionmat(:,:,target_class) =  confusion(pred_class,true_class);
      
end

% fill out errors 
err(1) = matthew(confusionmat(:,:,1));       % 1) signalpeptide(1) MCC
err(2) = specificity(confusionmat(:,:,2));   % 2) Cleavage site(2) specificity
err(3) = precision(confusionmat(:,:,2));   % 3) Cleavage site(2) precision
err(4) = matthew(confusionmat(:,:,2));   % 4) Cleavage site(2) MCC
err(5) = matthew(confusionmat(:,:,3));     % 5) transmembrane(3) MCC


    





    

end


