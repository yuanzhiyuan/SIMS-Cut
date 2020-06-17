function [sEnergy] = computeSubPairwiseEnergyForLabeling(PE, labeling)
%     [idx nIdx values] = find(subPairwiseTerms);
%     sEnergy = sum(values(currLabeling(idx)~=currLabeling(nIdx)))/2;
%     the algebraic expression above is correct but numerically is not robust with
%     respect to the order of summation
%     alternative expression
%     w for (0,1) and for (1,0) are the same, but only one of them is correct. 
%     This is why we need to devide by 2.    
    tempLabeling = (labeling(:) == 2);
    sEnergy = ((1-tempLabeling)' * PE *(tempLabeling) + ...
        (tempLabeling)' * PE *(1-tempLabeling))/2;

end