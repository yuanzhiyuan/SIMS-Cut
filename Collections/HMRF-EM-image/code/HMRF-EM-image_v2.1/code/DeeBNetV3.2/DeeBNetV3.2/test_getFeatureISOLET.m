%Test getFeature function for autoEncoder DBN in ISOLET data set
clc
clear;
more off;
addpath(genpath('DeepLearnToolboxGPU'));
addpath('DeeBNet');
data = ISOLET.prepareISOLET('H:\DataSets\Voice\ISOLET\');
data.normalize('meanvar');
data.validationData=data.testData;
data.validationLabels=data.testLabels;
data.shuffle();

dbn=DBN();
dbn.dbnType='autoEncoder';
maxEpoch=200;
% RBM1
rbmParams=RbmParameters(2000,ValueType.binary);
rbmParams.maxEpoch=maxEpoch;
rbmParams.samplingMethodType=SamplingClasses.SamplingMethodType.FEPCD;
rbmParams.performanceMethod='reconstruction';
dbn.addRBM(rbmParams);
% RBM2
rbmParams=RbmParameters(1000,ValueType.binary);
rbmParams.maxEpoch=maxEpoch;
rbmParams.samplingMethodType=SamplingClasses.SamplingMethodType.CD;
rbmParams.performanceMethod='reconstruction';
dbn.addRBM(rbmParams);
% RBM3
rbmParams=RbmParameters(500,ValueType.binary);
rbmParams.maxEpoch=maxEpoch;
rbmParams.samplingMethodType=SamplingClasses.SamplingMethodType.CD;
rbmParams.performanceMethod='reconstruction';
dbn.addRBM(rbmParams);
% RBM4
rbmParams=RbmParameters(250,ValueType.binary);
rbmParams.maxEpoch=maxEpoch;
rbmParams.samplingMethodType=SamplingClasses.SamplingMethodType.CD;
rbmParams.performanceMethod='reconstruction';
dbn.addRBM(rbmParams);
% RBM5
rbmParams=RbmParameters(3,ValueType.gaussian);
rbmParams.maxEpoch=maxEpoch;
rbmParams.samplingMethodType=SamplingClasses.SamplingMethodType.CD;
rbmParams.performanceMethod='reconstruction';
dbn.addRBM(rbmParams);

dbn.train(data);
dbn.backpropagation(data);
%% plot
figure;
plotFig=[{'mo' 'go' 'm+' 'r+' 'ro' 'k+' 'g+' 'ko' 'bo' 'b+'}];
pdn=10;
lgVec=cell(1,pdn);
rp=randperm(26)-1;
for i=1:pdn
    img=data.trainData(data.trainLabels==rp(i),:);
    ext=dbn.getFeature(img);
    plot3(ext(:,1),ext(:,2),ext(:,3),plotFig{i});hold on;
    lgVec(i)={int2str(rp(i)+1)};
end
legend(lgVec);
hold off;