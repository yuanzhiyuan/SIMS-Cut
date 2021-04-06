function[Costs] = get_BK_unary_costs3(bg_rbm,fg_rbm,x,PF,hard_constraint,batch_name,iters)
path = 'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\FE\';
path = [path,batch_name];
% if(exist(path))
% else
%     mkdir(path);
% end





FE_bg = SamplingClasses.freeEnergy(bg_rbm.rbmParams,x);
% train_sample_shuffle在rbm_fg上的自由能
FE_fg = SamplingClasses.freeEnergy(fg_rbm.rbmParams,x);

% Costs = [FE_bg-FE_fg,PF*ones(size(x,1),1)];
Costs = [FE_bg,PF*ones(size(x,1),1)+FE_fg];
% save([path,'\FE_',num2str(iters),'.mat'],'Costs');
Costs(hard_constraint,1) = 100;
% U1 = cal_free_energy(RBM,Y,[0,1]);
% p_l = label_prior;
% U1 = U1 + repmat(log(p_l),[size(Y,1),1]);
% Costs = U1;