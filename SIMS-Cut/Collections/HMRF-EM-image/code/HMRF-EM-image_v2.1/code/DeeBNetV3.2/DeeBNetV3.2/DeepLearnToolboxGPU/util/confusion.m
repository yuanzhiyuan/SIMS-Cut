function confusion =  confusion(pred_class,true_class)
%% CONFUSION Calculates confusion matrix
% pred_class should be a column vector specifying the predicted class
% true_class should be a column vector specifying the corresponding correct
% class.
% Positive class is 0
% Negative class is 1
% http://bioinformatics.oxfordjournals.org/content/16/5/412.full.pdf+html
% Output format:
%                preduction
%  ____________________________
%             |   pos     neg
%   __________|_________________
%   true | pos| 1,1 TP | 1,2 FN
%   clas | neg| 2,1 FP | 2,2 TN


positives = 0;  % definition for readability
negatives = 1;  % definition for readability
% http://en.wikipedia.org/wiki/Confusion_matrix
% read this as First parentesis: ~=  -> false, == -> true
% second parentesis: positives / negatives
% example (~=)   and (...== negatives) = false negatives
TP = sum( (pred_class == true_class) .* (true_class == positives) ); %True positive
TN = sum( (pred_class == true_class) .* (true_class == negatives) ); %True negative
FN = sum( (pred_class ~= true_class) .* (pred_class == negatives) ); %False negatives
FP = sum( (pred_class ~= true_class) .* (pred_class == positives) ); %False positives

confusion = [TP FN; FP TN];
end