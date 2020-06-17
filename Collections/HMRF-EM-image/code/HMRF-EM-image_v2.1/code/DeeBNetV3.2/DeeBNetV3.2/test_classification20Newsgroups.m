%Test classification in DBN on 20 newsgroups data set
clc;
res={};
more off;
addpath(genpath('DeepLearnToolboxGPU'));
addpath('DeeBNet');
data = TwentyNewsgroups.prepare20Newsgroups('H:\DataSets\Text\The 20 Newsgroups data set\20news-bydate-matlab\');
data.validationData=data.testData;
data.validationLabels=data.testLabels;
dbn=DBN('classifier');

% RBM1
rbmParams=RbmParameters(500,ValueType.binary);
rbmParams.samplingMethodType=SamplingClasses.SamplingMethodType.CD;
rbmParams.sparsity=1;
rbmParams.sparsityMethod='normal';
rbmParams.sparsityCost=0.2;
rbmParams.sparsityTarget=0.15;
rbmParams.sparsityVariance=0.1;
rbmParams.maxEpoch=200;
rbmParams.performanceMethod='reconstruction';
dbn.addRBM(rbmParams);
% RBM2
rbmParams=RbmParameters(500,ValueType.binary);
rbmParams.samplingMethodType=SamplingClasses.SamplingMethodType.CD;
rbmParams.sparsity=1;
rbmParams.maxEpoch=200;
rbmParams.performanceMethod='reconstruction';
dbn.addRBM(rbmParams);
% RBM3
rbmParams=RbmParameters(2000,ValueType.binary);
rbmParams.samplingMethodType=SamplingClasses.SamplingMethodType.FEPCD;
rbmParams.sparsity=1;
rbmParams.sparsityCost=3;
rbmParams.sparsityTarget=0.03;
rbmParams.sparsityMethod='normal';
rbmParams.maxEpoch=200;
rbmParams.rbmType=RbmType.discriminative;
rbmParams.performanceMethod='classification';
dbn.addRBM(rbmParams);
%train
ticID=tic;
dbn.train(data);
toc(ticID)
%test train
classNumber=dbn.getOutput(data.testData,'byFreeEnergy');
errorBeforeBP=sum(classNumber~=data.testLabels)/length(classNumber)
%BP
ticID=tic;
dbn.backpropagation(data);
toc(ticID);
%test after BP
classNumber=dbn.getOutput(data.testData);
errorAfterBP=sum(classNumber~=data.testLabels)/length(classNumber)