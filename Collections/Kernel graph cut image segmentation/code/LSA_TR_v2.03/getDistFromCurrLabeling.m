function distFromCurrLabeling = getDistFromCurrLabeling(currLabeling, optOptions)
% distance so that the new labeling is not far from the current labeling

if strcmp(optOptions.distance,'eucledian')
    distFromCurrLabeling = double(bwdist(currLabeling==2)-0.5);
    % there should be non empty foreground and background
    temp1 = padarray((currLabeling ==1),[1 1],true,'both');
    distFromCurrLabelingInside = double(bwdist(temp1)-0.5);
    distFromCurrLabelingInside = distFromCurrLabelingInside(2:end-1,2:end-1);
    distFromCurrLabeling(currLabeling==2) = distFromCurrLabelingInside(currLabeling==2);
elseif strcmp(optOptions.distance,'hamming')
    distFromCurrLabeling = ones(size(currLabeling));    
end
end


