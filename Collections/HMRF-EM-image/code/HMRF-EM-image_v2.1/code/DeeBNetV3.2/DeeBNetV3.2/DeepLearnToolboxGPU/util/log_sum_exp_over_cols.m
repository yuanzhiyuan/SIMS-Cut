function ret = log_sum_exp_over_cols(a)
  % This computes log(sum(exp(a), 2)) in a numerically stable way
  maxs = max(a, [], 2);
  ret = log(sum(exp(bsxfun(@minus,a,maxs)),2))+maxs;
    %the above is equivalent to:
    %maxs_big = repmat(maxs_small, [1, size(a, 2)]);
    %ret = log(sum(exp(a - maxs_big), 2)) + maxs_small;
end
