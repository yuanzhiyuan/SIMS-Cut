function[] = dim_sensitivity()
n = 100;
dim_range = 10:20:274;
nth_row = 1;
num_cells = 32;
% sample = sampling( 1:30, 100 );  

acc_mat=[];
c = categorical(dim_range);
rand_ind_mat = [];
for dim = dim_range
    
    ntimes_rand_ind = [];
     ntimes_acc = [];
    for i = 1:n
        nth_row = mod(i,num_cells)+1;
        disp([num2str(dim),',',num2str(i)]);
        [Acc,rand_index] = hunyang_2(dim,nth_row);
        ntimes_rand_ind = [ntimes_rand_ind,rand_index];
        ntimes_acc = [ntimes_acc,Acc];
    end
    acc_mat = [acc_mat;ntimes_acc];
    rand_ind_mat = [rand_ind_mat;ntimes_rand_ind];
end

boxplot(rand_ind_mat',c);

hold on;
plot(median(rand_ind_mat'))
title('AB-H-1,rand index');

boxplot(acc_mat',c);

hold on;
plot(median(acc_mat'))
title('AB-H-1,acc');
end
function sample = sampling( Lst, m )  
    temp = Lst;  
    l = length(Lst)  
    sample = []  
    %从 a 里面随机采十个样本，存放在 sample 里面  
    for i = 1:m  
        rdm_c = randi(l-i);  
        sample(i) = temp(rdm_c);  
        temp(rdm_c) = [];  
    end  
    sample  
end  