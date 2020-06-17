%Test generateClass function for Discriminative RBM in MNIST data set
clc;
clear;
more off;
addpath('DeeBNet');
% data = MNIST.prepareMNIST('H:\DataSets\Image\MNIST\');%using MNIST dataset completely.
% data = MNIST.prepareMNIST_Small('+MNIST\');%uncomment this line to use a small part of MNIST dataset.
% data.normalize('minmax');
data = ESBR.prepare_input();
% data.validationData=data.testData;
% data.validationLabels=data.testLabels;

% RBM
rbmParams=RbmParameters(50,ValueType.binary);
rbmParams.samplingMethodType=SamplingClasses.SamplingMethodType.FEPCD;
% rbmParams.performanceMethod='freeEnergy';
rbmParams.performanceMethod='classification';
% rbmParams.learningRate=0.5;
rbm=DiscriminativeRBM(rbmParams);
rbmParams.maxEpoch=100;

%train
rbm.train(data);
%Generate data
% L=([0:9]'*ones(10,1)')';
% generatedData=rbm.generateClass(L(:),1000);
% DataClasses.DataStore.plotData({generatedData},1);