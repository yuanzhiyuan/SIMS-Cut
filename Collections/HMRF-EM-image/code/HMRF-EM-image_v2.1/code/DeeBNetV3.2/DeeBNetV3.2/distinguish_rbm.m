function[pred] = distinguish_rbm(rbm1,rbm2,test_data)
FE1 = SamplingClasses.freeEnergy(rbm1.rbmParams,test_data);
FE2 = SamplingClasses.freeEnergy(rbm2.rbmParams,test_data);

FE = [FE1,FE2];
[~,pred] = max(FE,[],2);