function res = ReLU( x )
% Rectified linear unit
% Implementation of rectified linear unit.
% ReLU is f(x) = max(0,x) 
res = x .* (x>0);


end

