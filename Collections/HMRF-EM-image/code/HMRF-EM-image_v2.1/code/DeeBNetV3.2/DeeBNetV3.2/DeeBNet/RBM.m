%****************************In the Name of God****************************
% RBM class defines all necessary functions and features in all types of
% RBMs. Indeed the RBM class is an abstract class and we can't create an
% object from it.

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
%RBM Class
classdef RBM<handle
    
    % PUBLIC PROPERTIES ---------------------------------------------------
    properties (Access=public)
        %Storing RBM parameters
        rbmParams
    end %End PUBLIC PROPERTIES
    
    % PROTECTED PROPERTIES ------------------------------------------------
    properties (Access=protected)
        %Storing an object of Sampling class
        sampler
        %This parameter is used during training phase for updating weights.
        deltaWeight;
        %This parameter is used during training phase for updating visible
        %bias.
        deltaVisBias;
        %This parameter is used during training phase for updating hidden
        %bias.
        deltaHidBias;
    end %End PROTECTED PROPERTIES
    
    % PUBLIC METHODS ------------------------------------------------------
    methods (Access=public)
        %Constructor
        function obj=RBM(rbmParams)
            obj.rbmParams=rbmParams;
            if(rbmParams.gpu)
                if (~tools.isoctave())
                    gpuDevice(rbmParams.gpu);
                else
                    error('Octave does not support GPU.');
                end
            end
        end %End of constructor
        
        %Training function
        function train(obj,trainData)
            error ('train function must be implement.');
        end
        %Get feature from dataMatrix by RBM model
        function [extractedFeature]=getFeature(obj,dataMatrix)
            error ('getFeature function must be implement.');
        end
        
        % Transfer gpuArray to local workspace
        function [obj]=gather(obj)
            obj.rbmParams=tools.gather(obj.rbmParams);
            obj.sampler=tools.gather(obj.sampler);
            obj.deltaWeight=tools.gather(obj.deltaWeight);
            obj.deltaVisBias=tools.gather(obj.deltaVisBias);
            obj.deltaHidBias=tools.gather(obj.deltaHidBias);
        end %End of gather function
        
        %Create RBM on GPU
        function obj=gpuArray(obj)
            obj.rbmParams.weight=gpuArray(obj.rbmParams.weight);
            obj.rbmParams.gpu=1;
        end %End of gpuArray function
        
    end %End PUBLIC METHODS
    
    % PROTECTED METHODS ---------------------------------------------------
    methods (Access=protected)
        
        function [deltaWeightReg,deltaVisBiasReg,deltaHidBiasReg]=getRegularizationGradient(obj,batchData,posHid)
            %sparsity regularization term
            deltaWeightReg=0;
            deltaVisBiasReg=0;
            deltaHidBiasReg=0;
        end %End of getRegularizationGradient function
        
    end %End PROTECTED METHODS
    
end %End RBM class