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
%   	1/2016
%           LIMP(Laboratory for Intelligent Multimedia Processing),
%           AUT(Amirkabir University of Technology), Tehran, Iran
%**************************************************************************
% Prepare MNIST dataset to be usable
% mnistFolder: String that determine MNIST path folder
function [data] = prepareMNIST(mnistFolder)
% Creating an object to store train and test data and their labels
data=DataClasses.DataStore();
% Data value type is gaussian because the value can be consider a real
% value [-Inf +Inf]
data.valueType=ValueType.gaussian;

% Prepare test data
fprintf(1,'Beginning to convert\n'); 
f = fopen(strrep([mnistFolder 't10k-images.idx3-ubyte'], '\', filesep),'r');
[a,count] = fread(f,4,'int32');


g = fopen(strrep([mnistFolder 't10k-labels.idx1-ubyte'], '\', filesep),'r');
[l,count] = fread(g,2,'int32');

n = 10000;
data.testData = fread(f,28*28*n,'uchar');
data.testLabels = fread(g,n,'uchar');
data.testData = reshape(data.testData,28*28,n)';

fclose(f);
fclose(g);

% Prepare train data
f = fopen(strrep([mnistFolder 'train-images.idx3-ubyte'], '\', filesep),'r');
[a,count] = fread(f,4,'int32');

g = fopen(strrep([mnistFolder 'train-labels.idx1-ubyte'], '\', filesep),'r');
[l,count] = fread(g,2,'int32');

n = 60000;
data.trainData = fread(f,28*28*n,'uchar');
data.trainLabels = fread(g,n,'uchar');
data.trainData = reshape(data.trainData,28*28,n)';

fclose(f);
fclose(g);
fprintf(1,'End of conversion\n');
end %End of prepareMNIST function

