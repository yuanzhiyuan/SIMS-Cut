%Test generateData function in MNIST data set
clc;
clear;
more off;
addpath('DeeBNet');
% data = MNIST.prepareMNIST('H:\DataSets\Image\MNIST\');%using MNIST dataset completely.
data = MNIST.prepareMNIST_Small('+MNIST\');%uncomment this line to use a small part of MNIST dataset.
data.normalize('minmax');
data.validationData=data.testData;
data.validationLabels=data.testLabels;

% RBM1
rbmParams=RbmParameters(250,ValueType.binary);
rbmParams.samplingMethodType=SamplingClasses.SamplingMethodType.PCD;
rbmParams.performanceMethod='reconstruction';
rbm=GenerativeRBM(rbmParams);

%train
rbm.train(data);

[extractedFeature1]=rbm.getFeature(data.testData(1:9,:),1);
[extractedFeature2]=rbm.getFeature(data.testData(1:9,:),10);
[extractedFeature3]=rbm.getFeature(data.testData(1:9,:),100);
[generatedData1]=rbm.generateData(extractedFeature1);
[generatedData2]=rbm.generateData(extractedFeature2);
[generatedData3]=rbm.generateData(extractedFeature3);

DataClasses.DataStore.plotData({data.testData(1:9,:),generatedData1,generatedData2,generatedData3},1);
