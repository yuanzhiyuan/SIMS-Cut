%Test classification in DBN on ISOLET dataset
clc;
clear;
res={};
more off;
addpath(genpath('DeepLearnToolboxGPU'));
addpath('DeeBNet');
data = ISOLET.prepareISOLET('H:\DataSets\Voice\ISOLET\');
data.normalize('meanvar');
data.validationData=data.testData;
data.validationLabels=data.testLabels;
data.shuffle();
dbn=DBN('classifier');

% RBM1
rbmParams=RbmParameters(1000,ValueType.binary);
rbmParams.samplingMethodType=SamplingClasses.SamplingMethodType.PCD;
rbmParams.performanceMethod='reconstruction';
rbmParams.maxEpoch=200;
dbn.addRBM(rbmParams);
% RBM2
rbmParams=RbmParameters(1000,ValueType.binary);
rbmParams.samplingMethodType=SamplingClasses.SamplingMethodType.CD;
rbmParams.performanceMethod='reconstruction';
rbmParams.maxEpoch=200;
dbn.addRBM(rbmParams);
% RBM3
rbmParams=RbmParameters(2000,ValueType.binary);
rbmParams.samplingMethodType=SamplingClasses.SamplingMethodType.CD;
rbmParams.rbmType=RbmType.discriminative;
rbmParams.performanceMethod='classification';
rbmParams.maxEpoch=200;
dbn.addRBM(rbmParams);
%train
ticID=tic;
dbn.train(data);
toc(ticID)
%test train
classNumber=dbn.getOutput(data.testData,'bySampling');
errorBeforeBP=sum(classNumber~=data.testLabels)/length(classNumber)
%BP
ticID=tic;
dbn.backpropagation(data);
toc(ticID);
%test after BP
classNumber=dbn.getOutput(data.testData);
errorAfterBP=sum(classNumber~=data.testLabels)/length(classNumber)