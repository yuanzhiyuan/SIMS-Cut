%****************************In the Name of God****************************
% Different methods are proposed to build sparse RBMs. In all proposed
% methods, learning algorithm in RBM has been changed to enforce RBM to
% learn sparse representation. The goal of sparsity in RBM is that the most
% of hidden units has zero values and this is equivalent to tend activation
% probability of hidden units to zero. Sparse discriminative RBM is an
% sparse RBM for classification purpose.

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
%   	01/2016
%           LIMP(Laboratory for Intelligent Multimedia Processing),
%           AUT(Amirkabir University of Technology), Tehran, Iran
%**************************************************************************
%SparseDiscriminativeRBM Class
classdef SparseDiscriminativeRBM<DiscriminativeRBM & SparseRBM
    
    %% PUBLIC METHODS ------------------------------------------------------
    methods (Access=public)
        %Constructor
        function obj=SparseDiscriminativeRBM(rbmParams)
            obj=obj@DiscriminativeRBM(rbmParams);
            obj=obj@SparseRBM(rbmParams);
        end %End of Constructor function
        
    end %End PUBLIC METHODS
    
    %% PROTECTED METHODS --------------------------------------------------
    methods (Access=protected)
        
        function [deltaWeightReg,deltaVisBiasReg,deltaHidBiasReg]=getRegularizationGradient(obj,batchData,posHid)
            switch obj.rbmParams.sparsityMethod
                % based on paper [1]
                case 'quadratic'
                    term1=obj.rbmParams.sparsityTarget-posHid;
                    term2=1/size(batchData,1)*(batchData'*((posHid).*(1-posHid)));
                    term3=mean((posHid).*(1-posHid));
                    deltaHidBiasReg=obj.rbmParams.sparsityCost.*mean(term1).*term3;
                    deltaWeightReg=obj.rbmParams.sparsityCost*repmat(mean(term1),size(batchData,2),1).*term2;
                    % based on paper [2]
                case 'rateDistortion'
                    term2=-1/size(batchData,1)*(batchData'*((posHid).*(1-posHid)));
                    term3=-mean((posHid).*(1-posHid));
                    deltaHidBiasReg=obj.rbmParams.sparsityCost*term3;
                    deltaWeightReg=obj.rbmParams.sparsityCost*term2;
                    % based on our paper
                case 'normal'
                    term1=obj.rbmParams.sparsityTarget-posHid;
                    term2=1/size(batchData,1)*(batchData'*((posHid).*(1-posHid)));
                    term3=mean((posHid).*(1-posHid));
                    term4=normpdf(mean(posHid),obj.rbmParams.sparsityTarget,sqrt(obj.rbmParams.sparsityVariance));
                    deltaHidBiasReg=obj.rbmParams.sparsityCost*mean(term1).*term3.*term4;
                    deltaWeightReg=obj.rbmParams.sparsityCost*repmat(mean(term1),size(batchData,2),1).*term2.*repmat(term4,size(batchData,2),1);
                otherwise
                    error('Your sparsity method is not defined');
            end
            deltaVisBiasReg=0;
        end %End of getRegularizationGradient function
        
    end %End PROTECTED METHODS
    
    
end %End SparseDiscriminativeRBM class

