%****************************In the Name of God****************************
%ind2vec function Convert indices to vectors.

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
% Thanks to Luiz Angelo Daros de Luca 2009

% CONTRIBUTORS
%	Created by:
%   	Mohammad Ali Keyvanrad (http://ceit.aut.ac.ir/~keyvanrad)
%   	1/2016
%           LIMP(Laboratory for Intelligent Multimedia Processing),
%           AUT(Amirkabir University of Technology), Tehran, Iran
%**************************************************************************
%ind2vec function
%ind: Row vector of indices
%maxValue: equal to or greater than the maximum index
%vector: a sparse matrix of vectors

function [vector]=ind2vec(ind,maxValue)
  % Converts indices to vectors
  if (nargin<2)
    maxValue=max(ind);
  end
  if (~isrow(ind))
      error('ind is not row vector');
  end
  ind=[ind,maxValue];
  vectors = length(ind);
  vector = sparse(ind,1:vectors,ones(1,vectors));
  vector(:,end)=[];
end
