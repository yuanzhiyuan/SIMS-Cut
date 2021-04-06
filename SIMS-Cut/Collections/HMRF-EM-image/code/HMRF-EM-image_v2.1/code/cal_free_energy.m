function[FE_mat] = cal_free_energy(rbm,x,y)
%x «16384*40
%y «0,1,2
[data_n,data_d] = size(x);
FE_mat = [];

% label_mat = zeros(data_n,data_d+size(y),size(y));
for i=1:size(y,2)
   label_mat_i =  [zeros(data_n,size(y,2)),x];
   label_mat_i(:,i) = ones(data_n,1);
%    label_mat(:,:,i) = label_mat_i;
    FE=SamplingClasses.freeEnergy(rbm.rbmParams,label_mat_i);
    FE_mat = [FE_mat,FE];
end



