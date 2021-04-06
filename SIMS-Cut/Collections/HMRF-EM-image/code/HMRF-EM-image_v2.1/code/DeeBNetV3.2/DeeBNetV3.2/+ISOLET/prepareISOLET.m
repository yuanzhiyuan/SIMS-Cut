%****************************In the Name of God****************************
%prepareISOLET function prepares ISOLET dataset to be usable.
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
% Prepare ISOLET dataset to be usable
% isoletFolder: String that determine ISOLET path folder
function [data] = prepareISOLET(isoletFolder)
% Creating an object to store train and test data and their labels
data=DataClasses.DataStore();
% Data value type is gaussian because the value can be consider a real
% value [-Inf +Inf]
data.valueType=ValueType.gaussian;

fprintf(1,'Beginning to convert\n'); 

dTemp=load(strrep([isoletFolder 'isolet1+2+3+4.data'], '\', filesep));
data.trainData=dTemp(:,1:end-1);
data.trainLabels=dTemp(:,end)-1;
dTemp=load(strrep([isoletFolder 'isolet5.data'], '\', filesep));
data.testData=dTemp(:,1:end-1);
data.testLabels=dTemp(:,end)-1;

fprintf(1,'End of conversion\n');
end %End of prepareISOLET function

