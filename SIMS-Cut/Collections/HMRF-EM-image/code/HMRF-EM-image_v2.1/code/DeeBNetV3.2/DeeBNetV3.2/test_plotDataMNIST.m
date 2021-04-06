%test plotData function in MNIST data set
clc;
clear;
addpath('DeeBNet');
more off;
addpath(genpath('DeepLearnToolboxGPU'));
data = MNIST.prepareMNIST('H:\DataSets\Image\MNIST\');%using MNIST dataset completely.
% data = MNIST.prepareMNIST_Small('+MNIST\');%uncomment this line to use a small part of MNIST dataset.
data.normalize('minmax');
data.validationData=data.testData;
data.validationLabels=data.testLabels;

dbn=DBN('autoEncoder');

% RBM1
rbmParams=RbmParameters(500,ValueType.binary);
rbmParams.samplingMethodType=SamplingClasses.SamplingMethodType.PCD;
rbmParams.performanceMethod='reconstruction';
dbn.addRBM(rbmParams);

%train
dbn.train(data);
rd=dbn.reconstructData(data.testData(1:100,:));
DataClasses.DataStore.plotData({data.testData(1:100,:),rd},1);
