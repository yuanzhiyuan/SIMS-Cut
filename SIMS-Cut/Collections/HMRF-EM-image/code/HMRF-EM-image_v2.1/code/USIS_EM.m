Height = 256;
Width = 256;
n_matter = 20;
n_sites = Height*Width;
%fg:2,bg:1
% test_samples = zeros(n_sites,n_matters);
% init_labeling = zeros(65536,1);
cur_labeling = init_labeling;
n_hidden = 20;
n_epoch = 50;
while(1)
    cur_labeling = double(cur_labeling-1);
    
    fg_samples = test_samples(cur_labeling==1,:);
    bg_samples = test_samples(cur_labeling==0,:);
    fg_labels = cur_labeling(cur_labeling==1);
    bg_labels = cur_labeling(cur_labeling==0);
    rbm = train_rbm(fg_samples,bg_samples,fg_labels,bg_labels,n_hidden,n_epoch);
    label_prior = [length(bg_labels)/n_sites,length(fg_labels)/n_sites];
    cur_labeling = predict_gc(Height,Width,rbm,label_prior,test_samples);
    
    disp(num2str(1));
end

