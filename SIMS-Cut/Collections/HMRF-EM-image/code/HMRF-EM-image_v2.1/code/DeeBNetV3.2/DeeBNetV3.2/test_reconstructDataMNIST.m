%Test reconstructData function for Generative RBM in MNIST data set
clc;
clear all;
addpath('DeeBNet');
more off;
addpath(genpath('DeepLearnToolboxGPU'));
data = MNIST.prepareMNIST('H:\DataSets\Image\MNIST\');%using MNIST dataset completely.
%data = MNIST.prepareMNIST_Small('+MNIST\');%uncomment this line to use a small part of MNIST dataset.
data.normalize('minmax');
data.validationData=data.testData;
data.validationLabels=data.testLabels;

% RBM
rbmParams=RbmParameters(250,ValueType.binary);
rbmParams.samplingMethodType=SamplingClasses.SamplingMethodType.PCD;
rbmParams.performanceMethod='reconstruction';
rbm=GenerativeRBM(rbmParams);

%train
rbm.train(data);

noisyData=data.testData(1:9,:)+sqrt(0.02).*randn(size(data.testData(1:9,:)));
[reconstructedData]=rbm.reconstructData(noisyData,5);

DataClasses.DataStore.plotData({data.testData(1:9,:),noisyData,reconstructedData},1);
