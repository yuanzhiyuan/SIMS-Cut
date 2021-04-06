function[Costs] = get_BK_unary_costs2(bg_rbm,fg_rbm,x,PF)


FE_bg = SamplingClasses.freeEnergy(bg_rbm.rbmParams,x);
% train_sample_shuffle在rbm_fg上的自由能
FE_fg = SamplingClasses.freeEnergy(fg_rbm.rbmParams,x);
Costs = [FE_bg-FE_fg,PF*ones(size(x,1),1)];
% U1 = cal_free_energy(RBM,Y,[0,1]);
% p_l = label_prior;
% U1 = U1 + repmat(log(p_l),[size(Y,1),1]);
% Costs = U1;