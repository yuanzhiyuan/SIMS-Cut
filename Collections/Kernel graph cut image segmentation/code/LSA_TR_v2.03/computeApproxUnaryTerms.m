function [approxUEall, approxUE, distUE] = computeApproxUnaryTerms(currLabeling, energy, optOptions)

% these are the unary terms in the energy
approxUE = energy.UE;
% these are the unary terms representing the distance from current solution
distUE = zeros(size(approxUE));
distFromCurrLabeling = getDistFromCurrLabeling(currLabeling, optOptions);
distUE(2,currLabeling == 2) = 0;
distUE(1,currLabeling == 2) = distFromCurrLabeling(currLabeling == 2); 
distUE(1,currLabeling == 1) = 0;
distUE(2,currLabeling == 1) = distFromCurrLabeling(currLabeling == 1); 

% this is the approximation of the supermodular pairwise terms in the
% energy
approxUE(2,:) = approxUE(2,:) + 2 * double((currLabeling(:)==2)')*energy.superPE;
% combined together
approxUEall =  double(optOptions.LAMBDA_LAGRANGIAN) * distUE + approxUE;
    
end