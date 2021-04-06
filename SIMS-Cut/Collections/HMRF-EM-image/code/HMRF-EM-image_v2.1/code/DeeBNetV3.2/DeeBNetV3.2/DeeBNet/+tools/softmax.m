%****************************In the Name of God****************************
%softmax function
% Thannks to matlabtools.googlecode.com
% Permission is granted for anyone to copy, use, modify, or distribute this
% program and accompanying programs and documents for any purpose, provided
% this copyright notice is retained and prominently displayed, along with
% a note saying that the original programs are available from our web page.
%
% The programs and documents are distributed without any warranty, express
% or implied.  As the programs were written for research purposes only,
% they have not been tested to the degree that would be advisable in any
% important application.  All use of these programs is entirely at the
% user's own risk.

% CONTRIBUTORS
%	Created by:
%   	Mohammad Ali Keyvanrad (http://ceit.aut.ac.ir/~keyvanrad)
%   	1/2016
%           LIMP(Laboratory for Intelligent Multimedia Processing),
%           AUT(Amirkabir University of Technology), Tehran, Iran
%**************************************************************************
%softmax function
%eta: input matrix
%mu: matrix of the softmax function
function mu = softmax(eta)
% This file is from 
    tmp = exp(eta);
    denom = sum(tmp, 1);
    mu = bsxfun(@rdivide, tmp, denom);
end
