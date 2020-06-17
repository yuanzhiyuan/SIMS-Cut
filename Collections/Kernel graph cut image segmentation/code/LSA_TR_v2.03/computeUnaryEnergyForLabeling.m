function U = computeUnaryEnergyForLabeling(UE,labeling)
    U = sum(UE(sub2ind(size(UE), labeling(:)', 1:numel(labeling))));
return