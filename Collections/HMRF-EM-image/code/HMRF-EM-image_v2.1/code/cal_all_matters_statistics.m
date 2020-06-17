load('all_matters.mat');
total_de = [];
total_ds = [];
mean_de = [];
var_de = [];
for m=all_matters_de
%     disp(size(m{1}))
    total_de = [total_de,m{1}(:)];
    mean_de = [mean_de,mean(total_de(total_de(:,end)>=1,end))];
    var_de = [var_de,var(total_de(total_de(:,end)>=1,end))];
end

mean_ds = [];
var_ds = [];
for m=all_matters_ds
%     disp(size(m{1}))
    total_ds = [total_ds,m{1}(:)];
    mean_ds = [mean_ds,mean(total_ds(total_ds(:,end)>=1,end))];
    var_ds = [var_ds,var(total_ds(total_ds(:,end)>=1,end))];
end