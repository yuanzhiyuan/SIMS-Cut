function [newUE, newSubPE, newSuperPE, newConst] = reparamEnergy(UE, PE)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     IN:
%
%     UE - 2xN array of unary terms for N nodes, the first row for bg and the second for fg
%
%     PE - Mx6 array is a list of M arbitrary pairwise potentials.
%     Each row in PE is of the format [i,j,e00,e01,e10,e11] where i and j 
%     are neighbours and the four coefficients define the interaction 
%     potential. 
%     The same pair (i,j) can be repeated several times in PE,
%     but I assume that there are NO SELF-LOOPS. Namely: i~=j
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This function reparameterizes the input energy:
% 1. multiple pairwise terms with the same nodes are accumulated, 
% 2. submodular pairwise terms are transformed into a sparse symmetric
% matrix subPE which represents Potts model. This yields additional linear and
% constant terms. Each subPE(i,j)+subPE(j,i) is the the positive cost for
% assigning node i and j different labels.
% 3. supermodular terms are transformed into a sparse matrix superPE. This yields 
% additional linear and constant terms. Each superPE(i,j)+ superPE(j,i) is the positive 
% cost for having both i and j assigned label 2
% 
% The transformation is as follows:
%
% Any pairwise potential in PE is reparameterized
% A row [x y a b c d] in PE corresponds to the following energy terms
% a(1-x)(1-y) + b(1-x)y + c(1-y)x + dxy.
% These terms are rearranged into a constant, unary(for fg) and
% pairwise terms
% a + (c-a)x + (b-a)y + (a-b-c+d)xy.
% In order to reduce the number of edges in a graph, 
% any pairwise potential for a  pair i,j 00 01 10 11, such that j<i,
% is transformed into j,i 00 10 01 11 and combined with other rows j,i
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     OUT:
%
%     newUE - 2xN array of unary terms, the first row for bg and the second for fg
%
%     newSubPE - sparse symmertic NxN matrix of submodular terms in a form of potts model. 
%     m_ij=m_ji>0.
%     m_ij is the cost of assigning nodes (xi,xj) labels (1,0) 
%     m_ji is the cost of assigning nodes (xi,xj) labels (0,1)
%   
%     newSuperPE - sparse symmertic NxN matrix of supermodular terms. 
%     m_ij=m_ji>0, m_ij + m_ji is the cost 
%     of assigning nodes i and j labels xi = xj = 2. 
%
%     newConst - the constant term to make the reparameterized energy
%     equivalent
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% first lets make sure that all rows have indexes i,j such that i<j
idx = PE(:,1)>PE(:,2);
PE(idx,:) = PE(idx,[2 1 3 5 4 6]);

% if the same pair appears several times, lets accumulate the 
% corresponding rows into one pairwise term
% here are 4 sparse matrices
PE00 = accumarray(PE(:,1:2),PE(:,3),[],[],[],true);
PE01 = accumarray(PE(:,1:2),PE(:,4),[],[],[],true);
PE10 = accumarray(PE(:,1:2),PE(:,5),[],[],[],true);
PE11 = accumarray(PE(:,1:2),PE(:,6),[],[],[],true);



% reparameterize the rows in PE

numNodes = size(UE,2);
newUE = UE;
% c-a is unary term for i
[i, ~, c_minus_a] = find(PE10 - PE00);
newUE(2,:) = newUE(2,:) + (accumarray(i,c_minus_a,[numNodes,1]))'; % c-a
% b-a is unary terms for j
[~, j, b_minus_a] = find(PE01 - PE00);
newUE(2,:) = newUE(2,:) + (accumarray(j,b_minus_a,[numNodes,1]))'; % b-a
newConst = full(sum(PE00(:))); % a


testE11 = PE00 - PE01 - PE10 + PE11;
% this is the list of submodular reparameterized pairwise potentials
% here I'll make them in a form of potts model
% that means istead of
% (e00 e01 e10 e11) = (0,0,0,s) I reparameterize 
% (e00 e01 e10 e11) = (0,-s/2,-s/2,0) + s/2x + s/2y
[i, j] = find(testE11<0);
e11 = testE11(testE11<0);
% here are the unary terms
newUE(2,:) = newUE(2,:) + (accumarray(i,e11/2,[numNodes,1]))'; % e11/2
newUE(2,:) = newUE(2,:) + (accumarray(j,e11/2,[numNodes,1]))'; % e11/2
newSubPE = sparse(numNodes, numNodes);
newSubPE(sub2ind([numNodes, numNodes],i,j)) = -e11;
% make it symmetric
newSubPE = (newSubPE + newSubPE')/2;

% numSubTerms = length(i);
% newSubPE = [i,j, zeros(numSubTerms,1), zeros(numSubTerms,1), zeros(numSubTerms,1), full(testE11(testE11<0))];

% this is the list of supermodular reparameterized pairwise potentials
newSuperPE = sparse(numNodes, numNodes);
[i, j] = find(testE11>0);
e11 = testE11(testE11>0);
newSuperPE(sub2ind([numNodes, numNodes],i,j)) = e11;
% make it symmetric
newSuperPE = (newSuperPE + newSuperPE')/2;

end