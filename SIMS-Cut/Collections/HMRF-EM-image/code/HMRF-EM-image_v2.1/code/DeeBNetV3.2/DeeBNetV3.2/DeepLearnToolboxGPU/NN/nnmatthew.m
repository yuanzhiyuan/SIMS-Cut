function [mcc, bad] = nnmatthew(nn, x, y)
%MATTHEW calculate matthew coefficient for all target classes
%   Calculates the matthew correlation coefficient for all target calasses.
%   for a n-class classification problem the function returns a n
%   dimensional row vector.
%   bad is notused, but returned for compability with rest of code.
bad = [];
n_output = size(y,2);

assert(n_output~=1,'Behavior of matthew correlation not tested with single output')

% predict labels with network

pred = nnpredict(nn, x);


% find correct targets
[~, expected] = max(y,[],2);

if nn.isGPU
    confusionmat = gpuArray.zeros(2,2,n_output);
    mcc = gpuArray.zeros(1,5);
else
    confusionmat = zeros(2,2,n_output);
    mcc = zeros(1,5);
end

for target_class = 1:n_output    % testing: set to four
    
    %create binary vectors for each class. For each class (target_class)
    % match the predition with target class and the expected class with the
    % target class
    pred_class = ~(pred     == target_class);
    true_class = ~(expected == target_class);
    confusionmat(:,:,target_class) =  confusion(pred_class,true_class);
    
    %##### CASPERS CHANGE -PLEASE CHECK!!!
    %err(target_class) =  matthew(confusionmat(:,:,target_class));
    mcc(target_class) = matthew(confusionmat(:,:,target_class));
end
mcc(n_output+1) = matthew(sum(confusionmat,3));  % calculte mcc for whole dataset

end

