%Test getFeature function for autoEncoder DBN on 20 Newsgroups data set
clc
clear;
more off;
addpath(genpath('DeepLearnToolboxGPU'));
addpath('DeeBNet');
data = TwentyNewsgroups.prepare20Newsgroups('H:\DataSets\Text\The 20 Newsgroups data set\20news-bydate-matlab\');
data.validationData=data.testData;
data.validationLabels=data.testLabels;
dbn=DBN();
dbn.dbnType='autoEncoder';
% RBM1
rbmParams=RbmParameters(500,ValueType.binary);
rbmParams.maxEpoch=200;
rbmParams.samplingMethodType=SamplingClasses.SamplingMethodType.CD;
rbmParams.performanceMethod='reconstruction';
dbn.addRBM(rbmParams);
% RBM2
rbmParams=RbmParameters(500,ValueType.binary);
rbmParams.maxEpoch=200;
rbmParams.samplingMethodType=SamplingClasses.SamplingMethodType.CD;
rbmParams.performanceMethod='reconstruction';
dbn.addRBM(rbmParams);
% RBM3
rbmParams=RbmParameters(250,ValueType.binary);
rbmParams.maxEpoch=200;
rbmParams.samplingMethodType=SamplingClasses.SamplingMethodType.CD;
rbmParams.performanceMethod='reconstruction';
dbn.addRBM(rbmParams);
% RBM4
rbmParams=RbmParameters(3,ValueType.gaussian);
rbmParams.maxEpoch=200;
rbmParams.samplingMethodType=SamplingClasses.SamplingMethodType.CD;
rbmParams.performanceMethod='reconstruction';
dbn.addRBM(rbmParams);

dbn.train(data);
dbn.backpropagation(data);
%% plot
figure;
plotFig=[{'mo' 'g+' 'r*' 'ks' 'bx'}];
lgVec=[];
rp=randperm(20)-1;
for i=1:5
    trVecs=data.trainData(data.trainLabels==rp(i),:);
    ext=dbn.getFeature(trVecs);
    plot3(ext(:,1),ext(:,2),ext(:,3),plotFig{i});hold on;
    lgVec=[lgVec;{int2str(rp(i)+1)}];
end
legend(lgVec);
hold off;