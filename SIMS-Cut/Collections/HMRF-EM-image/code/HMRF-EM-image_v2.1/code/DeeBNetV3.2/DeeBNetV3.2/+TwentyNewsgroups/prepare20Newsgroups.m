%****************************In the Name of God****************************
%prepare20Newsgroups function prepares 20 Newsgroups dataset to be usable.
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
% Prepare 20 Newsgroups dataset to be usable
% newsgroupsFolder: String that determine 20 Newsgroups path folder
function [data] = prepare20Newsgroups(newsgroupsFolder)
% Creating an object to store train and test data and their labels
data=DataClasses.DataStore();
% Data value type is binary
data.valueType=ValueType.binary;

% Prepare test data
fprintf(1,'Beginning to convert\n'); 

testLabel=load(strrep([newsgroupsFolder 'test.label'], '\', filesep));
data.testLabels=testLabel-1;
testData=load(strrep([newsgroupsFolder 'test.data'], '\', filesep));
testData=sparse(testData(:,1),testData(:,2),testData(:,3),length(testLabel),61188);


% Prepare train data
trainLabel=load(strrep([newsgroupsFolder 'train.label'], '\', filesep));
data.trainLabels=trainLabel-1;
trainData=load(strrep([newsgroupsFolder 'train.data'], '\', filesep));
trainData=sparse(trainData(:,1),trainData(:,2),trainData(:,3),length(trainLabel),61188);

[B,I]=sort(sum(trainData,1),'descend');
testData=testData(:,I(1:5000));
data.testData=sign(full(testData));
trainData=trainData(:,I(1:5000));
data.trainData=sign(full(trainData));
data.shuffle();
fprintf(1,'End of conversion\n');
end %End of prepare20Newsgroups function

