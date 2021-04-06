load('181109_liver_highres_223.mat');
test_samples_all = test_samples+1;
load('181109_liver_highres_20.mat');
test_samples_20 = test_samples;

test_samples_20_processed = bsxfun(@rdivide,test_samples_20,prctile(test_samples_all,50,2));
test_samples_20_processed = bsxfun(@rdivide,test_samples_20,test_samples_all(:,175));
% test_samples_20_processed = bsxfun(@rdivide,test_samples_20,test_samples_all(:,165));
% test_samples_20_processed(isnan(test_samples_20_processed))=0;
% test_samples_20_processed(isinf(test_samples_20_processed))=0;
img = reshape(test_samples_20_processed(:,1),256,256)';
Iblur1 = imgaussfilt(img,2);


subplot(2,2,1)
imshow(img,[])
subplot(2,2,2)
imshow(Iblur1,[])

[init_labeling,C] = kmeans(test_samples_20_processed(:,1),2);
if(C(1)>=C(2))
    init_labeling = -init_labeling+3;
end
subplot(2,2,3)
imshow(reshape(init_labeling,256,256)',[])
[tmp_labeling,C] = kmeans(Iblur1(:),2);
[tmp,min_C_ind] = min(C);
init_labeling = tmp_labeling;
init_labeling(tmp_labeling==min_C_ind) = 1;
init_labeling(tmp_labeling~=min_C_ind) = 2;


subplot(2,2,4)
imshow(reshape(init_labeling,256,256)',[])
