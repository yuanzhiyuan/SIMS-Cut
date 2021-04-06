function[rbm] = train_rbm(fg_samples,bg_samples,fg_labels,bg_labels,n_hidden,n_epoch)

addpath('DeeBNet');

data=DataClasses.DataStore();
% Data value type is gaussian because the value can be consider a real
% value [0 +1]
% data.normalize('minmax')

data.valueType=ValueType.probability;
vali_ratio = 0.1;

sample = [fg_samples;bg_samples];
label = [fg_labels;bg_labels];
n_samples = length(label);
rdpm = randperm(length(label));
vali_idx = rdpm(1:vali_ratio*n_samples);
train_idx = rdpm(vali_ratio*n_samples+1:end);

vali_sample = sample(vali_idx,:);
vali_label = label(vali_idx);

train_sample = sample(train_idx,:);
train_label = label(train_idx);

data.trainData = train_sample;
data.trainLabels = train_label;
data.validationData = vali_sample;
data.validationLabels = vali_label;

data.dataMin = min(min(data.trainData));
data.dataMax = max(max(data.trainData));

data.trainData = (data.trainData-data.dataMin)/(data.dataMax-data.dataMin);
data.validationData = (data.validationData-data.dataMin)/(data.dataMax-data.dataMin);

data.shuffle();

% RBM
rbmParams=RbmParameters(n_hidden,ValueType.binary);
rbmParams.samplingMethodType=SamplingClasses.SamplingMethodType.PCD;
rbmParams.performanceMethod='classification';
rbm=DiscriminativeRBM(rbmParams);
rbmParams.maxEpoch=n_epoch;

%train
rbm.train(data);
%Generate data
% L=([0:9]'*ones(10,1)')';
% generatedData=rbm.generateClass(L(:),1000);
% DataClasses.DataStore.plotData({generatedData},1);