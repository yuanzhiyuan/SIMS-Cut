function[PF] = train_softmax2(bg_train_samples,bg_test_samples,bg_rbm,fg_train_samples,fg_test_samples,fg_rbm,beta)


init_minus_log_PF_bg = 0;
init_minus_log_PF_fg = 0;

% bg_train_samples = bg_train_samples(randperm(size(fg_train_samples,1)),:);

sz_bg_train = size(bg_train_samples,1);
sz_bg_test = size(bg_test_samples,1);
sz_fg_train = size(fg_train_samples,1);
sz_fg_test = size(fg_test_samples,1);

train_samples = [bg_train_samples;fg_train_samples];
train_labels = [ones(sz_bg_train,1);2*ones(sz_fg_train,1)];
test_samples = [bg_test_samples;fg_test_samples];
test_labels = [ones(sz_bg_test,1);2*ones(sz_fg_test,1)];

randperm_train = randperm(sz_bg_train+sz_fg_train);
train_samples_shuffle = train_samples(randperm_train,:);
train_labels_shuffle = train_labels(randperm_train);
randperm_test = randperm(sz_bg_test+sz_fg_test);
test_samples_shuffle = test_samples(randperm_test,:);
test_labels_shuffle = test_labels(randperm_test);

%先算自由能
% train_sample_shuffle在rbm_bg上的自由能
FE_bg_train = SamplingClasses.freeEnergy(bg_rbm.rbmParams,train_samples_shuffle);
% train_sample_shuffle在rbm_fg上的自由能
FE_fg_train = SamplingClasses.freeEnergy(fg_rbm.rbmParams,train_samples_shuffle);


%diff 小的为bg，大的为fg
diff = FE_bg_train-FE_fg_train;

diff_label = [diff,train_labels_shuffle];
sort_diff_label = sortrows(diff_label,1);

confusion = zeros(size(diff,1),12);
parfor i=1:size(diff,1)
   %小于第1个为1类，大于等于第i个为1类,fg为Positive
   TP = sum(sort_diff_label(i:end,2)==2);
   FP = sum(sort_diff_label(i:end,2)==1);
   TN = sum(sort_diff_label(1:i-1,2)==1);
   FN = sum(sort_diff_label(1:i-1,2)==2);
   AACC=0.5*(TP/(TP+FN)+TN/(TN+50*FP));
   MCC = (TP*TN-FP*FN)/(sqrt((TP+FP)*(FP+FN)*(TN+FP)*(TN+FN)));
   Recall = TP/(TP+FN);
   Specificity = TN/(TN+FP);
   Precision = TP/(TP+FP);
   Gmeans = sqrt(Recall*Specificity);
   Balanced_acc = 0.5*(Recall+Specificity);
%    beta = 0.5;
   Fmeasure = (beta^2+1)*Precision*Recall/(beta^2*Precision+Recall);
%    sort_diff_label(i,3:6) = [TP,FP,TN,FN];
    confusion(i,:) = [TP,FP,TN,FN,AACC,MCC,Recall,Specificity,Precision,Gmeans,Balanced_acc,Fmeasure];
   disp(num2str(i));
end

sort_diff_label_confusion = [sort_diff_label,confusion];

kth_col = 14;
sort_by_k = sortrows(sort_diff_label_confusion,kth_col);

PF = sort_by_k(end,1);
% idx = 1;
% iters = 1;
% jumps = 0;
% max_iters = 50000;
% epoch=0;
% max_epoch=10;
% 
% 
% minus_log_PF_fg = init_minus_log_PF_fg;
% minus_log_PF_bg = init_minus_log_PF_bg;
% prec_li = [];
% minus_log_PF_bg_li = [];
% minus_log_PF_fg_li = [];
% while(epoch<=max_epoch)
% % while(iters<=max_iters)
%     cur_sample = train_samples_shuffle(idx,:);
%     cur_label = train_labels_shuffle(idx,:);
%     
%     exp_1 = exp(-FE_bg_train(idx)+minus_log_PF_bg);
%     exp_2 = exp(-FE_fg_train(idx)+minus_log_PF_fg);
%     sm_1 = exp_1/(exp_1+exp_2);
%     sm_2 = exp_2/(exp_1+exp_2);
%     
%     minus_log_PF_bg_grad = (cur_label==1)*(1-sm_1) - (cur_label==2)*sm_1;
%     minus_log_PF_fg_grad = (cur_label==2)*(1-sm_2) - (cur_label==1)*sm_2;
%     minus_log_PF_bg = minus_log_PF_bg-minus_log_PF_bg_grad*step_size;
%     minus_log_PF_fg = minus_log_PF_fg-minus_log_PF_fg_grad*step_size;
%     
%     minus_log_PF_bg_li = [minus_log_PF_bg_li,minus_log_PF_bg];
%     minus_log_PF_fg_li = [minus_log_PF_fg_li,minus_log_PF_fg];
%     
%     bg_prob = -FE_bg_train+minus_log_PF_bg;
%     fg_prob = -FE_fg_train+minus_log_PF_fg;
%     [~,cur_pred] = max([bg_prob,fg_prob],[],2); 
%     
%     preciesion = sum(cur_pred==train_labels_shuffle)/(sz_bg_train+sz_fg_train);
%     prec_li = [prec_li,preciesion];
%     idx = idx+1;
%     iters = iters+1;
%     if(idx==(sz_bg_train+sz_fg_train+1))
%         idx = 1;
%         epoch=epoch+1;
%     end
%     
%     
% end
% plot(1:iters-1,prec_li);
% plot(1:iters-1,minus_log_PF_bg_li)
% plot(1:iters-1,minus_log_PF_fg_li)
    
    
    