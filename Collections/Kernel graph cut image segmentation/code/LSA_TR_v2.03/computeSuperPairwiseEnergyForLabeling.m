function pairwiseEterm = computeSuperPairwiseEnergyForLabeling(pairwiseTerms, labeling)
    pairwiseEterm = (double((labeling(:)==2)')*pairwiseTerms*double((labeling(:)==2)));
end