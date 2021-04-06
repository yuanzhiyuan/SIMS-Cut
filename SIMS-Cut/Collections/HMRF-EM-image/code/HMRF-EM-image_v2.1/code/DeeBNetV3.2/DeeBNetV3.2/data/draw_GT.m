load('C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hela\hela_brdu.mat');
hela_brdu = test_samples(:,1);
load('C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\549\A549_brdu.mat');
a549_brdu = test_samples(:,1);
load('C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\549\549_brdu_labeling.mat');
a549_labeling = cur_labeling;
load('C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hela\hela_brdu_labeling.mat');
hela_labeling = cur_labeling;

hela_brdu_img = reshape(hela_brdu,256,256)';
a549_brdu_img = reshape(a549_brdu,256,256)';
hela_label_img = reshape(hela_labeling,256,256)';
a549_label_img = reshape(a549_labeling,256,256)';

imshowpair(hela_brdu_img,hela_label_img);
% imshowpair(a549_brdu_img,a549_label_img);