%Test reconstructData function for Discriminative RBM in MNIST data set
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

% RBM
rbmParams=RbmParameters(1000,ValueType.binary);
rbmParams.samplingMethodType=SamplingClasses.SamplingMethodType.PCD;
rbmParams.performanceMethod='classification';
rbm=DiscriminativeRBM(rbmParams);
rbmParams.maxEpoch=200;

%train
rbm.train(data);

noisyData=data.testData(1:9,:)+sqrt(0.2).*randn(size(data.testData(1:9,:)));
noisyData2=noisyData;
for i=1:500
    [reconstructedData]=rbm.reconstructData(noisyData2,2,[],data.testLabels(1:9));
    noisyData2=reconstructedData;
end
DataClasses.DataStore.plotData({data.testData(1:9,:),noisyData,reconstructedData},1);