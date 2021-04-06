%test sparse classes and plotBases function on MNIST data set
clc;
clear;
more off;
addpath(genpath('DeepLearnToolboxGPU'));
addpath('DeeBNet');
data = MNIST.prepareMNIST('H:\DataSets\Image\MNIST\');%using MNIST dataset completely.
% data = MNIST.prepareMNIST_Small('+MNIST\');%uncomment this line to use a small part of MNIST dataset.
data.normalize('minmax');
data.validationData=data.testData;
data.validationLabels=data.testLabels;

dbn=DBN('autoEncoder');
% RBM
rbmParams=RbmParameters(225,ValueType.binary);
rbmParams.samplingMethodType=SamplingClasses.SamplingMethodType.FEPCD;
rbmParams.performanceMethod='reconstruction';
dbn.addRBM(rbmParams);
%train
dbn.train(data);
figure;
dbn.plotBases(1);
title('RBM bases functiones');

dbn2=DBN('autoEncoder');
% RBM
rbmParams=RbmParameters(225,ValueType.binary);
rbmParams.samplingMethodType=SamplingClasses.SamplingMethodType.FEPCD;
rbmParams.sparsity=1;
rbmParams.sparsityMethod='normal';
rbmParams.sparsityVariance=0.1;
rbmParams.sparsityTarget=0.02;
rbmParams.sparsityCost=3;
rbmParams.performanceMethod='reconstruction';
dbn2.addRBM(rbmParams);
%train
dbn2.train(data);
figure;
dbn2.plotBases(1);
title('Sparse RBM bases functiones');