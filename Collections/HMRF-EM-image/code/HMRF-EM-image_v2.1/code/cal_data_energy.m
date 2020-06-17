function[rst] = cal_data_energy(U,X)
%U:65536*3 
%X:256*256,label mat
x = X(:);
[pixels,labels] = size(U);
rst = 0;
for i=1:pixels
   cur_add = U(i,int16(x(i)));
   rst = rst+cur_add;
end