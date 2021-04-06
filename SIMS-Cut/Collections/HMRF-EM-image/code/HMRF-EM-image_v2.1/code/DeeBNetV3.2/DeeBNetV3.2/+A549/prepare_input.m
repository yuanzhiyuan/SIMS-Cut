%****************************In the Name of God****************************
%prepareMNIST function prepares MNIST dataset to be usable.
%
% Permission is granted for anyone to copy, use, modify, or distribute this
% program and accompanying programs and documents for any purpose, provided
% this copyright notice is retained and prominently displayed, along with
% a note saying that the original programs are available from our web page.
%
% The programs and documents are distributed without any warranty, express
% or implied.  As the programs were written for research purposes only,
% they have not been tested to the degree that would be advisable in any
% important application.  All use of these programs is entirely at the
% user's own risk.

% The code is inspired from paper: Hinton, Geoffrey E., and Ruslan R.
% Salakhutdinov. "Reducing the dimensionality of data with neural
% networks." Science 313.5786 (2006): 504-507.
% CONTRIBUTORS 
%	Created by:
%   	Mohammad Ali Keyvanrad (http://ceit.aut.ac.ir/~keyvanrad)
%   	01/2016
%           LIMP(Laboratory for Intelligent Multimedia Processing),
%           AUT(Amirkabir University of Technology), Tehran, Iran
%**************************************************************************
% Prepare a part of MNIST dataset to be usable
% mnistFolder: String that determine MNIST path folder
function [data] = prepare_input()
% Creating an object to store train and test data and their labels
data=DataClasses.DataStore();
% Data value type is gaussian because the value can be consider a real
% value [0 +1]
% data.normalize('minmax')

data.valueType=ValueType.probability;

% dataFile=load(strrep([folder 'mnist_small.mat'], '\', filesep));
% load('+ESBR/ESBR_20_7_input.mat');
load('+A549/A549_samples_4_1_0.mat');

% neg_samples = neg_samples(:,1:100);
% pos_samples = pos_samples(:,1:100);
% bg_x = ceil(rand(1000,40)*5);
% bg_y = 2*ones(size(bg_x,1),1);
rdpm = randperm(size(neg_samples,1));
neg_samples = neg_samples(rdpm(1:size(pos_samples)),:);

data.trainData=[neg_samples;pos_samples];
data.trainLabels = [zeros(size(neg_samples,1),1);ones(size(pos_samples,1),1)];
data.dataMin = min(min(data.trainData));
data.dataMax = max(max(data.trainData));
data.trainData = (data.trainData-data.dataMin)/(data.dataMax-data.dataMin);
data.shuffle();
train_ratio = 0.1
test_ratio = (1-train_ratio)/2;
vali_ratio = (1-train_ratio)/2;
test_num = floor(test_ratio*size(data.trainData,1));
vali_num = floor(vali_ratio*size(data.trainData,1));
trainData_tmp = data.trainData(1:end-test_num-vali_num,:);
trainLabels_tmp = data.trainLabels(1:end-test_num-vali_num);
testData_tmp = data.trainData(end-test_num-vali_num+1:end-vali_num,:);
testLabels_tmp = data.trainLabels(end-test_num-vali_num+1:end-vali_num,:);
valiData_tmp = data.trainData(end-vali_num+1:end,:);
valiLabels_tmp = data.trainLabels(end-vali_num+1:end,:);
data.trainData = trainData_tmp;
data.trainLabels = trainLabels_tmp;
data.testData = [testData_tmp;valiData_tmp];
data.testLabels = [testLabels_tmp;valiLabels_tmp];
data.validationData = data.testData;
data.validationLabels = data.testLabels;

% data.trainData=dataFile.data;
% data.trainLabels=dataFile.labels-1;
% data.testData=dataFile.testdata;
% data.testLabels=dataFile.testlabels-1;
end %End of prepareMNIST_Small funcrion

