function[p_l,generatedData,generatedLabel] = cal_label_prior(rbm,x_i,sample_iters,chain_length)
label_li = [];
for k=1:sample_iters
    disp(['running ',num2str(k),' th gibbs chain']);
%     [generatedData,generatedLabel]=rbm.reconstructData(x_i,chain_length);
[generatedData,generatedLabel]=rbm.generateData(x_i,chain_length);
    label_li = [label_li,generatedLabel];
end
p_l = ([sum(label_li==0),sum(label_li==1),sum(label_li==2)]/size(label_li,2));