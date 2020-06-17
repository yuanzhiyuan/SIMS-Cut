function mcc =  matthew(confusion)
%% MATTHEW Calculates matthew correlation coefficient
% http://bioinformatics.oxfordjournals.org/content/16/5/412.full.pdf+html
% input format:
%                preduction
%  ____________________________
%             |   pos     neg
%   __________|_________________
%   true | pos| 1,1 TP | 1,2 FN
%   clas | neg| 2,1 FP | 2,2 TN
%
% Nb. If denominator is zero, then the denominator is set to 1
tp = confusion(1,1);
fn = confusion(1,2);
fp = confusion(2,1);
tn = confusion(2,2);

%check if mcc denominator is belew zero, set to 1 if so
mcc_denom = (tp+fp) * (tp+fn) * (tn+fp) * (tn + fn);
mcc = (tp * tn - fp * fn) ./ sqrt(mcc_denom);
end