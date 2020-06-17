%****************************In the Name of God****************************
%DataStore class is defined for store all parts of data such as train, test
%and validation. Also this class has some useful function such as normalize
%function for normalizing data and shuffle function to shuffle train data
%and cut function to cut train data for create smaller train data. Finally
%the plotData function can be used for plotting some parts of data that is
%useful for compare data before and after some processing stages.
%
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
%   	12/2015
%           LIMP(Laboratory for Intelligent Multimedia Processing),
%           AUT(Amirkabir University of Technology), Tehran, Iran
%**************************************************************************
%DataStore Class
classdef DataStore<handle
    
    % PUBLIC PROPERTIES ---------------------------------------------------
    properties (Access=public)
        % Type of values that is used in train, test and validation data.
        % valueType get ValueType enumeration values.
        valueType
        
        % m*n matrix of train samples.
        % This Matrix has m samples with n values.
        trainData
        
        % vector of train labels.
        % This vector has m labels of samples.
        trainLabels
        
        % m*n matrix of validation samples.
        % This Matrix has m samples with n values.
        validationData
        
        % vector of validatin labels.
        % This vector has m labels of samples.
        validationLabels
        
        % m*n matrix of test samples.
        % This Matrix has m samples with n values.
        testData
        
        % vector of test labels.
        % This vector has m labels of samples.
        testLabels
        
        % Average vector of training data. This value sets in meanvar
        % normalize method.
        dataMean
        
        % Standard deviation vector of training data. This value sets in
        % meanvar normalize method.
        dataStd
        
        % Minimum vector of training data. This value sets in minmax
        % normalize method.
        dataMin
        
        % Maximum vector of training data. This value sets in minmax
        % normalize method.
        dataMax
        
        % Normalize method can be "minmax" or "meanvar"
        normilizeMethod
    end %End PUBLIC PROPERTIES
    
    % PUBLIC METHODS ------------------------------------------------------
    methods (Access=public)
        
        %Creates a copy from DataStore object
        %DataStoreObj: Copy of DataStore object
        function DataStoreObj=clone(obj)
            DataStoreObj=DataClasses.DataStore();
            DataStoreObj.valueType=obj.valueType;
            DataStoreObj.trainData=obj.trainData;
            DataStoreObj.trainLabels=obj.trainLabels;
            DataStoreObj.validationData=obj.validationData;
            DataStoreObj.validationLabels=obj.validationLabels;
            DataStoreObj.testData=obj.testData;
            DataStoreObj.testLabels=obj.testLabels;
            DataStoreObj.dataMean=obj.dataMin;
            DataStoreObj.dataStd=obj.dataMax;
            DataStoreObj.dataMean=obj.dataMean;
            DataStoreObj.dataStd=obj.dataStd;
            DataStoreObj.normilizeMethod=obj.normilizeMethod;
        end%End of clone function
        
        % Normalizing data
        % method: defines type of normalization such as 'minmax' or 'meanvar'
        function normalize(obj,method)
            obj.normilizeMethod=method;
            batchSize=obj.computeBatchSize();
            % Appling 'minmax' method
            if (strcmp(method,'minmax'))
                %With 'minmax' normalization method, values map in range
                %[0 1] and therefore valueType will be changed.
                obj.valueType=ValueType.probability;
                obj.dataMin=min(min(obj.trainData));
                obj.dataMax=max(max(obj.trainData));
                % Apply to train data
                batchArraySize=ceil(size(obj.trainData,1)/batchSize);
                for i=1:batchArraySize
                    batchData=obj.trainData((i-1)*batchSize+1:min(i*batchSize,end),:);
                    obj.trainData((i-1)*batchSize+1:min(i*batchSize,end),:)=(batchData-obj.dataMin)/...
                        (obj.dataMax-obj.dataMin);
                end
                % Apply to validation data
                if (~isempty(obj.validationData))
                    batchArraySize=ceil(size(obj.validationData,1)/batchSize);
                    for i=1:batchArraySize
                        batchData=obj.validationData((i-1)*batchSize+1:min(i*batchSize,end),:);
                        obj.validationData((i-1)*batchSize+1:min(i*batchSize,end),:)=(batchData-obj.dataMin)/...
                            (obj.dataMax-obj.dataMin);
                    end
                end
                % Apply to test data
                if (~isempty(obj.testData))
                    batchArraySize=ceil(size(obj.testData,1)/batchSize);
                    for i=1:batchArraySize
                        batchData=obj.testData((i-1)*batchSize+1:min(i*batchSize,end),:);
                        obj.testData((i-1)*batchSize+1:min(i*batchSize,end),:)=(batchData-obj.dataMin)/...
                            (obj.dataMax-obj.dataMin);
                    end
                end
            end
            % Appling 'meanvar' method
            if (strcmp(method,'meanvar'))
                %With 'meanvar' normalization method, values map in range
                %mean zero and variance one and therefor valueType will be
                %changed.
                obj.valueType=ValueType.gaussian;
                obj.dataMean=mean(obj.trainData,1);
                obj.dataStd=std(obj.trainData,1)+eps;
                % Apply to train data
                batchArraySize=ceil(size(obj.trainData,1)/batchSize);
                for i=1:batchArraySize
                    batchData=obj.trainData((i-1)*batchSize+1:min(i*batchSize,end),:);
                    obj.trainData((i-1)*batchSize+1:min(i*batchSize,end),:)=(batchData-repmat(obj.dataMean,size(batchData,1),1))./...
                        (repmat(obj.dataStd,size(batchData,1),1));
                end
                % Apply to validation data
                if (~isempty(obj.validationData))
                    batchArraySize=ceil(size(obj.validationData,1)/batchSize);
                    for i=1:batchArraySize
                        batchData=obj.validationData((i-1)*batchSize+1:min(i*batchSize,end),:);
                        obj.validationData((i-1)*batchSize+1:min(i*batchSize,end),:)=(batchData-repmat(obj.dataMean,size(batchData,1),1))./...
                            (repmat(obj.dataStd,size(batchData,1),1));
                    end
                end
                % Apply to test data
                if (~isempty(obj.testData))
                    batchArraySize=ceil(size(obj.testData,1)/batchSize);
                    for i=1:batchArraySize
                        batchData=obj.testData((i-1)*batchSize+1:min(i*batchSize,end),:);
                        obj.testData((i-1)*batchSize+1:min(i*batchSize,end),:)=(batchData-repmat(obj.dataMean,size(batchData,1),1))./...
                            (repmat(obj.dataStd,size(batchData,1),1));
                    end
                end
            end
        end %End of normalize function
        
        %Normalizing new data
        %data: An m*n matrix with m samples and n values that will be
        %normalized with normilizeMethod.
        function normalizedData=normalizeNewData(obj,data)
            %Appling 'minmax' method
            if (strcmp(obj.normilizeMethod,'minmax'))
                normalizedData=(data-obj.dataMin)/...
                    (obj.dataMax-obj.dataMin);
            end
            %Appling 'meanvar' method
            if (strcmp(obj.normilizeMethod,'meanvar'))
                normalizedData=(data-repmat(obj.dataMean,size(data,1),1))./...
                    (repmat(obj.dataStd,size(data,1),1));
            end
        end%End of normalizeNewData function
        
        %Reverse normalizing data
        %dataMatrix: An m*n matrix with m samples and n values that is
        %normalize
        function deNormalizedData=reverseNormalize(obj,dataMatrix)
            deNormalizedData=dataMatrix;
            %Appling reverse of 'minmax' method
            if (strcmp(obj.normilizeMethod,'minmax'))
                deNormalizedData=(dataMatrix*(obj.dataMax-obj.dataMin)+obj.dataMin);
            end
            %Appling reverse of 'meanvar' method
            if (strcmp(obj.normilizeMethod,'meanvar'))
                deNormalizedData=repmat(obj.dataStd,size(dataMatrix,1),1).*dataMatrix+...
                    repmat(obj.dataMean,size(dataMatrix,1),1);
            end
        end%End of reverseNormalize function
        
        % shuffling data
        function shuffle(obj)
            % Creating a random number list and using it for train data.
            randomOrder=randperm(size(obj.trainData,1));
            if(~tools.isoctave)
                filename = ['tempShuffle' num2str(randi(1000)) '.mat'];
                trainData=zeros(1,size(obj.trainData,2));
                save(filename,'trainData','-v7.3');
                m = matfile(filename,'Writable',true);
                %copy train data to matfile
                batchSize=obj.computeBatchSize();
                batchArraySize=ceil(size(obj.trainData,1)/batchSize);
                for i=1:batchArraySize
                    batchDataIndex=randomOrder((i-1)*batchSize+1:min(i*batchSize,end));
                    batchData=obj.trainData(batchDataIndex,:);
                    m.trainData((i-1)*batchSize+1:min(i*batchSize,size(obj.trainData,1)),:)=batchData;
                end
                obj.trainData=[];
                obj.trainData=m.trainData;
                delete(filename);
            else
                obj.trainData=obj.trainData(randomOrder,:);
            end
            if (~isempty(obj.trainLabels))
                obj.trainLabels=obj.trainLabels(randomOrder,:);
            end
        end%End of shuffle function
        
        % compute a suitable batch size
        function batchSize=computeBatchSize(obj)
%             tmp=obj.trainData(1,:);
%             s=whos('tmp');
%             bytesPerSample=s.bytes;
%             if (ispc && ~tools.isoctave())
%                 [userview systemview] = memory;
%                 bytesAvailable=systemview.PhysicalMemory.Available;
%             elseif (isunix)
%                 [r,w] = unix('free | grep Mem');
%                 stats = str2double(regexp(w, '[0-9]*', 'match'));
%                 bytesAvailable = (stats(3)+stats(end))*1024;
%             else
%                 % using 50 MB
%                 bytesAvailable=50*1e6;
%             end
%             % 1/5 of total free memory
%             batchSize1=floor((bytesAvailable/bytesPerSample)/5);
%             % total train data
%             batchSize2=size(obj.trainData,1);
%             batchSize3=50000;
%             batchSize=min([batchSize1,batchSize2,batchSize3]);
batchSize=50000;
        end%End of computeBatchSize function
        
        % Cutting data
        % cutRatio: Train data is partitioned to cutRatio part and only
        % first part keep and other parts will be removed.
        function cut(obj,cutRatio)
            obj.trainData=obj.trainData(1:floor(end/cutRatio),:);
            obj.trainLabels=obj.trainLabels(1:floor(end/cutRatio),:);
        end%End of cut function
        
    end %End PUBLIC METHODS
    
    % STATIC METHODS ------------------------------------------------------
    methods(Static)
        % Plotting data
        % dataCells: Array of cells that each cell contains a data matrix.
        % isInversed: Invers each data sample befor plot. For example
        % images in MNIST must be inversed befor plotting data.
        % sizeX: Size of data sample in x direction. For example this value
        % is 28 in MNIST data.
        % sizeY: Size of data sample in y direction. For example this value
        % is 28 in MNIST data.
        function plotData(dataCells,isInversed,sizeX,sizeY)
            if nargin<2
                isInversed=0;
            end
            % If sizeX is not assigned, Square root of data sample size
            % will be computed for sizeX
            if nargin<3
                sizeX=sqrt(size(dataCells{1},2));
            end
            % If sizeY is not assigned, Square root of data sample size
            % will be computed for sizeY
            if nargin<4
                sizeY=size(dataCells{1},2)/sizeX;
            end
            %Plotting data matrix in each cell separately in a figure
            for dcl=1:length(dataCells)
                dataMat=dataCells{dcl};
                dataMat=(dataMat-min(min(dataMat)))/(max(max(dataMat))-min(min(dataMat)));
                % numImgDir: Number of data sample in a figure in each direction
                numImgDir=floor(sqrt(size(dataMat,1)));
                % img: An image that contains all data samples in a cell
                img=zeros(numImgDir*sizeY,numImgDir*sizeX);
                counter=0;
                for i=1:numImgDir
                    for j=1:numImgDir
                        counter=counter+1;
                        if (isInversed==0)
                            img((i-1)*sizeY+1:i*sizeY,(j-1)*sizeX+1:j*sizeX)=reshape(dataMat(counter,:),sizeY,sizeX);
                        else
                            img((i-1)*sizeY+1:i*sizeY,(j-1)*sizeX+1:j*sizeX)=reshape(dataMat(counter,:),sizeX,sizeY)';
                        end
                    end
                end
                subplot(1,length(dataCells),dcl);imshow(img);
                xlabel(dcl);
            end
        end %End of plotData function
        
    end %End STATIC METHODS
    
end %End Classdef