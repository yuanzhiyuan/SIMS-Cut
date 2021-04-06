function[rst]=strcat(varargin)
rst = [];
for i=1:nargin
rst=[rst,varargin{i}];
end
