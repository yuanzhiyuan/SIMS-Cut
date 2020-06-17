%Test getFeature function for autoEncoder DBN in MNIST data set
clc
clear;
addpath('DeeBNet');
data = MNIST.prepareMNIST('H:\DataSets\Image\MNIST\');%using MNIST dataset completely.
% data = MNIST.prepareMNIST_Small('+MNIST\');%uncomment this line to use a small part of MNIST dataset.
data.normalize('minmax');
data.validationData=data.testData;
data.validationLabels=data.testLabels;

dbn=DBN();
dbn.dbnType='autoEncoder';
% RBM1
rbmParams=RbmParameters(1000,ValueType.binary);
rbmParams.maxEpoch=50;
rbmParams.gpu=1;
rbmParams.samplingMethodType=SamplingClasses.SamplingMethodType.CD;
rbmParams.performanceMethod='reconstruction';
dbn.addRBM(rbmParams);
% RBM2
rbmParams=RbmParameters(500,ValueType.binary);
rbmParams.maxEpoch=50;
rbmParams.gpu=1;
rbmParams.samplingMethodType=SamplingClasses.SamplingMethodType.CD;
rbmParams.performanceMethod='reconstruction';
dbn.addRBM(rbmParams);
% RBM3
rbmParams=RbmParameters(250,ValueType.binary);
rbmParams.maxEpoch=50;
rbmParams.gpu=1;
rbmParams.samplingMethodType=SamplingClasses.SamplingMethodType.CD;
rbmParams.performanceMethod='reconstruction';
dbn.addRBM(rbmParams);
% RBM4
rbmParams=RbmParameters(3,ValueType.gaussian);
rbmParams.maxEpoch=50;
rbmParams.gpu=1;
rbmParams.samplingMethodType=SamplingClasses.SamplingMethodType.CD;
rbmParams.performanceMethod='reconstruction';
dbn.addRBM(rbmParams);

dbn.train(data);
useGPU='yes';
dbn.backpropagation(data,useGPU);
%% plot
figure;
plotFig=[{'mo' 'go' 'm+' 'r+' 'ro' 'k+' 'g+' 'ko' 'bo' 'b+'}];
for i=0:9
    img=data.testData(data.testLabels==i,:);
    ext=dbn.getFeature(img);
    plot3(ext(:,1),ext(:,2),ext(:,3),plotFig{i+1});hold on;
end
legend('0','1','2','3','4','5','6','7','8','9');
hold off;