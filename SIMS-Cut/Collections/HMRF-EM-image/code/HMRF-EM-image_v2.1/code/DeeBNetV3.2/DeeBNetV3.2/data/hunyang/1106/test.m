load('181106_mcf-7-high-spatial-resolution_191.mat');
test_samples_all = test_samples+1;
load('181106_mcf-7-high-spatial-resolution_20.mat');
test_samples_20 = test_samples;

% test_samples_20_processed = bsxfun(@rdivide,test_samples_20,prctile(test_samples_all,50,2));
test_samples_20_processed = bsxfun(@rdivide,test_samples_20,test_samples_all(:,165));
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
subplot(2,2,3)
imshow(reshape(init_labeling,256,256)',[])
[init_labeling,C] = kmeans(Iblur1(:),2);
subplot(2,2,3)
imshow(reshape(init_labeling,256,256)',[])