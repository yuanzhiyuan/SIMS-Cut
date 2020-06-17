function[Costs] = get_BK_unary_costs(RBM,Y,label_prior)

U1 = cal_free_energy(RBM,Y,[0,1]);
p_l = label_prior;
U1 = U1 + repmat(log(p_l),[size(Y,1),1]);
Costs = U1;