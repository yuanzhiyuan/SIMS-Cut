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
function [data] = prepareMNIST_Small(mnistFolder)
% Creating an object to store train and test data and their labels
data=DataClasses.DataStore();
% Data value type is gaussian because the value can be consider a real
% value [0 +1]
data.valueType=ValueType.probability;

dataFile=load(strrep([mnistFolder 'mnist_small.mat'], '\', filesep));
data.trainData=dataFile.data;
data.trainLabels=dataFile.labels-1;
data.testData=dataFile.testdata;
data.testLabels=dataFile.testlabels-1;
end %End of prepareMNIST_Small funcrion

