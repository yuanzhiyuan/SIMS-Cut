function[i,j] = ind2ij(ind,height,width)
i = mod(ind-1,height)+1;
j = floor((ind-1)/height)+1;
end