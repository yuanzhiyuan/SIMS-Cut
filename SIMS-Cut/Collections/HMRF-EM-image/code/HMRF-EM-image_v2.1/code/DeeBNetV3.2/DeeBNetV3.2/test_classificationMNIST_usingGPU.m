%Test classification in DBN in MNIST data set
clc;
clear;
res={};
more off;
addpath(genpath('DeepLearnToolboxGPU'));
addpath('DeeBNet');
data = MNIST.prepareMNIST('H:\DataSets\Image\MNIST\');%using MNIST dataset completely.
% data = MNIST.prepareMNIST_Small('+MNIST\');%uncomment this line to use a small part of MNIST dataset.
data.normalize('minmax');
data.shuffle();
data.validationData=data.testData;
data.validationLabels=data.testLabels;
dbn=DBN('classifier');
maxEpoch=1;
% RBM1
rbmParams=RbmParameters(500,ValueType.binary);
rbmParams.gpu=1;
rbmParams.maxEpoch=maxEpoch;
rbmParams.samplingMethodType=SamplingClasses.SamplingMethodType.PCD;
rbmParams.performanceMethod='reconstruction';
dbn.addRBM(rbmParams);
% RBM2
rbmParams=RbmParameters(500,ValueType.binary);
rbmParams.gpu=1;
rbmParams.maxEpoch=maxEpoch;
rbmParams.samplingMethodType=SamplingClasses.SamplingMethodType.PCD;
rbmParams.performanceMethod='reconstruction';
dbn.addRBM(rbmParams);
% RBM3
rbmParams=RbmParameters(2000,ValueType.binary);
rbmParams.gpu=1;
rbmParams.maxEpoch=maxEpoch;
rbmParams.samplingMethodType=SamplingClasses.SamplingMethodType.PCD;
rbmParams.rbmType=RbmType.discriminative;
rbmParams.performanceMethod='classification';
dbn.addRBM(rbmParams);
%train
ticID=tic;
dbn.train(data);
toc(ticID)
%test train
classNumber=dbn.getOutput(data.testData,'bySampling');
errorBeforeBP=sum(classNumber~=data.testLabels)/length(classNumber)
%prepare dbn for using in other computers without gpu
dbn=gather(dbn);
%BP
ticID=tic;
%using GPU in BP. If you have memory problem in GPU, set it to 'no'
useGPU='yes';
dbn.backpropagation(data,useGPU,0);
toc(ticID);
%test after BP
classNumber=dbn.getOutput(data.testData);
errorAfterBP=sum(classNumber~=data.testLabels)/length(classNumber)