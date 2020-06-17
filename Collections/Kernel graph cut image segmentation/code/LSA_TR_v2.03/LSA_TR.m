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
% % version 2.01 (17 July, 2014)
% This version uses a different input format for the energy for faster optimization
% Reparametrerization of the energy provided outside of the optimizer
%
% version 2.02 (8 October, 2014)
% In this version I switched the order of updating the solution and updating the step size
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



function [currLabeling, E, iteration ] = LSA_TR(energy, visualFlag, initLabeling, img)
tic;
currLabeling = [];
E = 0;
iteration = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% validate the input and determine the distance, init and visualization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~exist('visualFlag','var')
    visualFlag = 0;
end

% check validity of the initLabeling if provided
if exist('initLabeling','var')
    if ~isempty(initLabeling)
        % is it all background? That is an invalid init labeling
        if all(initLabeling==1)
            disp('initial labeling cannot all be background, in this case distances are not defined');
            disp('changing to trivial solution - all foreground');
            initLabeling = initLabeling + 1;
        end
    end
end

% energy is on image
if exist('img','var')
    % if the img is not empty, we can use it to visualize intermediate
    % results
    if ~isempty(img)
        [numRows, numCols,~] = size(img);
        % set Trust Region options (can be modified in setOptimizationOptions.m)
        optOptions = setOptimizationOptions(numRows, numCols, 'LSA-TR');
        optOptions.SHOW_FLAG = true;
        optOptions.distance = 'eucledian';
        disp('using eucledian');
    % the img is empty, do not visualize results    
    else
        % is there initLabeling provided?
        if exist('initLabeling','var')
            % is it empty?
            if ~isempty(initLabeling)
                numRows = size(initLabeling,1);
                numCols = size(initLabeling,2);
            else
                numRows = size(energy.UE,2);
                numCols = 1;
            end
        else
            numRows = size(energy.UE,2);
            numCols = 1;
        end
        optOptions = setOptimizationOptions(numRows, numCols, 'LSA-TR');
        % use hamming distance
        if (numRows == 1) || (numCols == 1)
            optOptions.distance = 'hamming';
            disp('using hamming');
        % use eucledian distance
        else
            optOptions.distance = 'eucledian';
            disp('using eucledian');
        end
        optOptions.SHOW_FLAG = false;
    end
        
%  do not visualize the results    
else
    % is there initLabeling provided?
    if exist('initLabeling','var')
        % is it empty?
        if ~isempty(initLabeling)
            numRows = size(initLabeling,1);
            numCols = size(initLabeling,2);
        else
            numRows = size(energy.UE,2);
            numCols = 1;
        end
    else
        numRows = size(energy.UE,2);
        numCols = 1;
    end
    optOptions = setOptimizationOptions(numRows, numCols, 'LSA-TR');
    % use hamming distance
    if (numRows == 1) || (numCols == 1)
        optOptions.distance = 'hamming';
        disp('using hamming');
        % use eucledian distance
    else
        optOptions.distance = 'eucledian';
        disp('using eucledian');
    end
    optOptions.SHOW_FLAG = false;
end

optOptions.SHOW_FLAG = optOptions.SHOW_FLAG & visualFlag;
if (optOptions.SHOW_FLAG)
    disp('visualizing results');
else
    disp('not visualizing results');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% begin optimization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic;
% create graph
BKhandle = BK_Create(optOptions.numNodes,2);
BK_SetNeighbors(BKhandle, energy.subPE);

% init labeling
if exist('initLabeling','var')
    % is provided
    if ~isempty(initLabeling)
        currLabeling = initLabeling;
    % empty init labeling    
    else
        % if no initialization provided use the unary terms to init
        [~,initLabeling] = min(energy.UE);
        initLabeling = reshape(initLabeling, numRows, numCols);
        currLabeling = initLabeling;
        
    end
% init labeling is not provided    
else
    % if no initialization provided use the unary terms to init
    [~,initLabeling] = min(energy.UE);
    initLabeling = reshape(initLabeling, numRows, numCols);
    currLabeling = initLabeling;
end

stopFlag = 0;
iteration = 1;

if optOptions.SHOW_FLAG
    % show initialization
    f2 = figure; hold on; axis equal; axis off;
    figureHandle = f2;
    whichLabel = 2;
    showCurrLabeling(figureHandle, img, whichLabel,currLabeling, [optOptions.myString 'Initialization'])
    f1 = -1;
end


% compute the actual energy of the currLabeling
[ currEactual, ~, ~, ~] = computeEnergy(currLabeling, energy, optOptions,'CURR ');

% compute approximation for the supermodular pairwise terms
% optOptions.LAMBDA_LAGRANGIAN is current lambda step
[DCapprox.approxUEall, DCapprox.approxUE, DCapprox.distUE] = computeApproxUnaryTerms(currLabeling, energy, optOptions);


% Here we begin iterations
while ~stopFlag
    if optOptions.SHOW_FLAG 
        fprintf('Iteration: %d\n',iteration);
    end
    % solve TR sub-problem
    [lambdaLabeling, ~] = findGivenBreakPoint(BKhandle,numRows, numCols, DCapprox, optOptions);
    
    
    % compute the approximate energy of the current labeling
    [ currEapprox, ~, ~] = computeApproxEnergy(currLabeling, DCapprox, energy, optOptions,'CURR ');

    % compute the approximate energy of the lambda labeling
    [ lambdaEapprox, ~, ~] = computeApproxEnergy(lambdaLabeling, DCapprox, energy, optOptions,'LAMBDA ');
        
    
    predictedReduction = currEapprox - lambdaEapprox;
    if (predictedReduction < 0)
         error('predicted reduction is negative');
    end
    
    updateSolutionFlag = false;
    % if zero predicted reduction (in other words if S_lambda == S_0) - check whether the first breaking point
    % will make a reduction in energy
    if all(lambdaLabeling(:) == currLabeling(:)) 

        if optOptions.SHOW_FLAG 
            fprintf('Seg: PREDICTED REDUCTION = 0, S_lambda = S_0  ==> find min change breaking point.\n');
        end
        
        % check the minimal change breaking point (S_{lambda_max})
        [lambda, lambdaLabeling ,~] = findMinimalChangeBreakPoint(BKhandle, numRows, numCols, currLabeling, ....
            DCapprox, optOptions);
        optOptions.LAMBDA_LAGRANGIAN = lambda;

        % compute the approximate energy of the lambda labeling
        [ lambdaEapprox, ~, ~] = computeApproxEnergy(lambdaLabeling, DCapprox, energy, optOptions,'LAMBDA ');


        % compute the actual energy of the lambdaLabeling
        [ lambdaEactual, ~, ~, ~] = computeEnergy(lambdaLabeling, energy, optOptions,'LAMBDA ');

        
        predictedReduction = currEapprox - lambdaEapprox;
        if (predictedReduction < 0)
            error('predicted reduction is negative');
        end
        actualReduction = currEactual - lambdaEactual;
        
        if (actualReduction <= 0) || ...
                all(lambdaLabeling(:)==2) || ... % no bg
                all(lambdaLabeling(:)==1) % no fg 

            stopFlag = true;
            if optOptions.SHOW_FLAG 
                if (actualReduction <= 0)
                    fprintf('Seg: ACTUAL REDUCTION = %f <=0 for the minimal change breaking point S_{lambda_max}\n', actualReduction);
                    fprintf('Converged \n');
                else
                    fprintf('Converged to trivial solution \n');
                end
            end
        else
            if optOptions.SHOW_FLAG 
                fprintf('Seg: ACTUAL REDUCTION = %f >0 for S_{lambda}, ==> update solution\n', actualReduction);
            end
            updateSolutionFlag = true;
            if (optOptions.LAMBDA_LAGRANGIAN == 0)
                fprintf('LAMBDA_LAGRANGIAN is 0, restarting trust region size with optOptions.LAMBDA_LAGRANGIAN_RESTART = %f \n',optOptions.LAMBDA_LAGRANGIAN_RESTART);
                optOptions.LAMBDA_LAGRANGIAN = optOptions.LAMBDA_LAGRANGIAN_RESTART;
%                 error('lambda geo is 0, but I need to update the step size');
            end
        end
    % regular trust region step, check reduction ratio    
    else
        
        if optOptions.SHOW_FLAG 
            fprintf('Seg: PREDICTED REDUCTION = %f>=0 for the S_{lambda}\n', predictedReduction);
        end
   
        % compute the actual energy of the lambdaLabeling
        [ lambdaEactual, ~, ~, ~] = computeEnergy(lambdaLabeling, energy, optOptions,'LAMBDA ');
   
        actualReduction = currEactual - lambdaEactual;
        
        if (actualReduction <= 0)
            updateSolutionFlag = false;
            if optOptions.SHOW_FLAG 
                fprintf('Seg: ACTUAL REDUCTION = %f <=0 for S_{lambda}, no update made\n', actualReduction);
            end
        else
            if optOptions.SHOW_FLAG 
                fprintf('Seg: ACTUAL REDUCTION = %f >0 for S_{lambda}, ==> update solution\n', actualReduction);
            end
            updateSolutionFlag = true;
            if (optOptions.LAMBDA_LAGRANGIAN == 0)
                error('lambda lagrangian should not be 0');
            end
        end
        
    end
    % if we don't stop
    if ~stopFlag    % compute the reduction ratio
        % compute the reduction ratio
        reductionRatio = actualReduction/predictedReduction;
        % print
        if optOptions.SHOW_FLAG
            fprintf('Seg: ActualReduction/predictedReduction = %f/%f = %f\n',actualReduction,predictedReduction,reductionRatio);
        end

        if reductionRatio < optOptions.REDUCTION_RATIO_THRESHOLD
            % reduce the step next time (larger lambda)
             if optOptions.LAMBDA_LAGRANGIAN < optOptions.MAX_LAMBDA_LAGRANGIAN
                optOptions.LAMBDA_LAGRANGIAN = optOptions.LAMBDA_LAGRANGIAN * optOptions.LAMBDA_MULTIPLIER;
             end
            if optOptions.SHOW_FLAG
                fprintf('Seg: Reduce step size (larger lambda), set lambda = %f\n', optOptions.LAMBDA_LAGRANGIAN);
            end
        else
            % make large step next time (smaller Lambda)
            if optOptions.LAMBDA_LAGRANGIAN > optOptions.PRECISION_COMPARE_GEO_LAMBDA
                optOptions.LAMBDA_LAGRANGIAN = optOptions.LAMBDA_LAGRANGIAN/optOptions.LAMBDA_MULTIPLIER;
            end
            if optOptions.SHOW_FLAG
                fprintf('Seg: Increase step size (smaller lambda), set lambda = %f\n', optOptions.LAMBDA_LAGRANGIAN);
            end
        end % reductionRatio

                
        % do we need to update the solution
        if updateSolutionFlag
            % make a step and update curr labeling
            currLabeling = lambdaLabeling;
            currEactual = lambdaEactual;
            
            if optOptions.SHOW_FLAG 
                fprintf('Seg: ACTUAL ENERGY of CURR LABELING is E = %f ************************** best so far\n', currEactual);
            end
       
            % if trivial solution
            if length(unique(currLabeling))==1
                fprintf('Seg: trivial solution, stop!\n');
                stopFlag= true;
            else
                % compute approximation for the supermodular pairwise terms
                % optOptions.LAMBDA_LAGRANGIAN is current lambda step
                [DCapprox.approxUEall, DCapprox.approxUE, DCapprox.distUE] = computeApproxUnaryTerms(currLabeling, energy, optOptions);
                
                
                % show
                if optOptions.SHOW_FLAG
                    if (f1 == -1)
                        f1 = figure;
                    end
                    figureHandle = f1;
                    whichLabel = 2;
                    titleString = [optOptions.myString 'Iteration' num2str(iteration)];
                    showCurrLabeling(figureHandle, img, whichLabel,currLabeling, titleString);
                end
            end
        end   
       
    end
    iteration = iteration + 1;
end % while : iterations

BK_Delete(BKhandle);
% return values
iteration = iteration -1;
E = currEactual;
if optOptions.SHOW_FLAG
    fprintf('LAST energy: E=%f\n',E);
end
toc;
end % end of the segIterations

