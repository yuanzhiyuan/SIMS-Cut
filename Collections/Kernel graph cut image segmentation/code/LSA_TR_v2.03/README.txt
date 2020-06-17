% Copyright (c) 2014, Lena Gorelick
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
%     * Redistributions of source code must retain the above copyright
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright
%       notice, this list of conditions and the following disclaimer in the
%       documentation and/or other materials provided with the distribution.
%     * Neither the name of the University of Western Ontarior nor the
%       names of its contributors may be used to endorse or promote products
%       derived from this software without specific prior written permission.
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
% ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
% WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
% DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
% DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
% (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
% LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
% ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
% (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
% SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
% 
% 
% THIS SOFTWARE IMPLEMENTS THE LSA_TR ALGORITHM 
% FOR OPTIMIZATION OF BINARY PAIRWISE ENERGIES
% PLEASE USE THE FOLLOWING CITATION:
% 
% @inproceedings{cvpr2014LSA,
% 	title	= {Submodularization for Binary Pairwise Energies},
% 	author	= {Gorelick, Lena and Veksler, Olga and Boykov, Yuri and Ben Ayed, Ismail and Delong, Andrew},
% 	booktitle={Conference on Computer Vision and Pattern Recognition},
% 	month	= {June},
% 	year	= {2014}}
% 
% THIS SOFTWARE USES maxflow/min-cut CODE THAT WAS IMPLEMENTED BY VLADIMIR KOLMOGOROV,
% THAT CAN BE DOWNLOADED FROM http://vision.csd.uwo.ca/code/.
% PLEASE USE THE FOLLOWING CITATION:
% 
% @ARTICLE{Boykov01anexperimental,
%     author = {Yuri Boykov and Vladimir Kolmogorov},
%     title = {An Experimental Comparison of Min-Cut/Max-Flow Algorithms for Energy Minimization in Vision},
%     journal = {IEEE TRANSACTIONS ON PATTERN ANALYSIS AND MACHINE INTELLIGENCE},
%     year = {2001},
%     volume = {26},
%     pages = {359--374}}
% 
% 
% 
% version 2.01 (17 July, 2014)
% This version uses a different input format for the energy for faster optimization
% Reparametrerization of the energy provided outside of the optimizer
%
% version 2.02 (8 October, 2014)
% In this version I switched the order of updating the solution and updating the step size

% version 2.03 (27 April, 2016)
% In this version I fixed a bug in initialization when initLabeling is not provided.
% Now, the initLabeling selects a label with MINIMUM unary term and not the maximum unary term.
% This bug did not affect the outcome if the initLabeling was provided as a parameter.
%
% ##################################################################
% 
%  
% 
% USAGE INSTRUCTIONS
% 
% 	[currLabeling, E, iteration] = LSA_TR(energy, [visualFlag, [initLabeling, [img]]]);
% 
% 	INPUT:
%
%   energy           - is a structure with the following fields:
%           
% 	energy.UE        - 2xN matrix of unary terms, where 2 is the number of labels and N is the number of nodes.
%                      First row represents the data costs for label 1 and second row for label 2.
%                      If the energy is given on a graph that represents an image, the nodes are indexed in
%                      columnwise manner. 
%
% 	energy.subPE     - is a sparse NxN matrix of submodular terms in a form of potts model. 
%                      subPE(i,j)=subPE(j,i)>0.
%                      subPE(i,j)is the cost of assigning nodes (xi,xj) labels (2,1) 
%                      subPE(j,i) is the cost of assigning nodes (xi,xj) labels (1,2)
%
%   energy.superPE   - is a sparse NxN matrix, where superPE(i,j) is the positive cost for having 
%                      both i and j assigned label 2
%
%   energy.constTerm - is a constant that needs to be added for the exact
%                      energy evaluation. (It could have been a result of 
%                      energy reparametrization and does not affect optimization)
%
%                      *** IMPORTANT *** 
%                      If your energy is not in this form, you can use the
%                      following command to reparameterize your energy:
%                      [energy.UE, energy.subPE, energy.superPE, energy.constTerm] = reparamEnergy(UE, PE)
%                      where UE (2xN) and PE (Mx6) are arbitrary unary and
%                      pairwise terms respectively. 
%                      Please refer for the documentation of reparamEnergy for the format of UE and PE. 
%                      
%
%   visualFlag       - boolean flag that determines whether to show or not
%                      the intermediate results. It is automatically switched
%                      off if input img on which to visualize the results
%                      is not provided.
%
%  	initLabeling     - array of size N. initLabeling is the initial solution. 
%                      Pixels labeled with 1 belong to background. Pixels labeled with 2 
%                      belong to foreground. If empty [] or not provided, unary terms
%                      are used to initialize. If the energy is defined on an image, 
%                      initLabeling can also be [numRows x numCols] matrix of labels. 
%                      initLabeling cannot be all background, since in this
%                      case distances are not defined.
%
% 	img              - [numRows x numCols x {1,3}] matrix is the input img on which to visualize results. 
%                      Can be either black/white or color image. If empty or not provided, 
%                      the results are not visualized
%
% 	OUTPUT:	
%
% 	currLabeling     - final solution. Pixels labeled with 1 belong to background
%                      pixels labeled with 2 belong to foreground.
%   E                - the value of the energy at the final solution
%   iteration        - number of iterations performed
%
%   EXAMPLES OF USAGE:
%
%       If you have arbitrary unary terms UE(2xN array) 
%       and pairwise terms PE(Mx6 array of [i j e00 e01 e10 e11], no self loops)
%       first reparameterize the energy as follows:
%       [energy.UE, energy.subPE, energy.superPE, energy.constTerm] = reparamEnergy(UE, PE);
%
%       Now you can optimize with any of the following examples of usage
%
%       [currLabeling, E, iteration] = LSA_TR(energy);
%           - hamming distance is used, 
%           - default unary terms (max likelihood per pixel) are used
%             to initialize, since initLabeling is not provided
%           - results are not visualized, since img is not provided 
%
%       [currLabeling, E, iteration] = LSA_TR(energy, visualFlag);
%           - hamming distance is used, 
%           - default unary terms (max likelihood per pixel) are used
%             to initialize, since initLabeling is not provided
%           - results are not visualized even if visualFlag is on, since img is not provided
%
%       [currLabeling, E, iteration] = LSA_TR(energy, visualFlag, [], img);
%           - eucledian distance is used since img is provided
%           - default unary terms (max likelihood per pixel) are used
%             to initialize, since initLabeling is not provided
%           - visualFlag controls visualization
%             
%       [currLabeling, E, iteration] = LSA_TR(energy, visualFlag, initLabeling, []);
%           - eucledian distance is used if initLabeling is a matrix and 
%             hamming distance is used if initLabeling is a vector
%           - initLabeling is used
%           - results are not visualized even if visualFlag is on, since img is not provided
%
%       [currLabeling, E, iteration] = LSA_TR(energy, visualFlag, initLabeling, img);
%           - eucledian distance is used
%           - initLabeling is used
%           - visualFlag controls visualization
