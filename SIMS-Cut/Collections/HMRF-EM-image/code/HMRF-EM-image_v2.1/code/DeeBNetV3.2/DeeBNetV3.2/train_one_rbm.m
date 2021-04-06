function[rbm] = train_one_rbm(train_samples,test_samples,num_hid,n_epoch)

data = DataClasses.DataStore();

data.valueType = ValueType.probability;






data.trainData = train_samples;
data.validationData = test_samples;
data.testData = test_samples;

data.trainLabels = zeros(size(data.trainData,1),1);
data.validationLabels = zeros(size(data.validationData,1),1);
data.testLabels = zeros(size(data.testData,1),1);

rbmParams = RbmParameters(num_hid,ValueType.binary);
rbmParams.samplingMethodType = SamplingClasses.SamplingMethodType.PCD;
rbmParams.performanceMethod = 'reconstruction';
rbmParams.maxEpoch=n_epoch;
% rbmParams.sparsityMethod = 'quadratic';


% rbm = SparseGenerativeRBM(rbmParams);
rbm = GenerativeRBM(rbmParams);
rbm.train(data);