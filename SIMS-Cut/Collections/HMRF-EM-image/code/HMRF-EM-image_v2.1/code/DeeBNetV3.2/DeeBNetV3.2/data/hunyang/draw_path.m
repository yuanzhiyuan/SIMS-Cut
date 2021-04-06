% load('short_path_stw_tor2.mat');
% G = digraph(s,t,w);
% d = disances(G,'Method','unweighted');
% d_ = d;
% d_(d_==inf)=0;
% max(d_(:));
% valid_path_st = find(d_>=20);
% save('valid_path_st_tor2_255.24.mat','valid_path_st');

% È¡256*256µÄ×óÏÂ½Ç
% a = zeros(256,256);
% a(129:256,1:128) = 1;
% a = a';
% b = a(:);
% left_bottom_ind = find(b==1);
%other_ind = find(b==0);
%%%%%%%%%%%%%%%%%%%%%%%

% load('short_path_stw_tor2.mat');
% G = digraph(s,t,w);
% d = disances(G,'Method','unweighted');
% d(d==inf)=0;
% d(:,other_ind)=0;
% d(left_bottom_ind,:)=0;

% max(d_(:));
% valid_path_st = find(d_>=20);
% save('valid_path_st_tor2_255.24.mat','valid_path_st');



cur_matter = 371;
load('valid_path_st_tor0_255.24.mat');
load('short_path_stw_tor0_255.24.mat');
pref = 'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\EM_mid_rst\cur_labeling_0403_0328_20_Fmeasure_0.8_grad_div10_22.mat';
load(pref);
% valid_path_st = valid_path_st(1:3000);
% imagesc(reshape(test_samples(:,189),256,256)');
imshow(reshape(cur_labeling,256,256)',[]);
G = digraph(s,t,w);

for i=valid_path_st'
    record_line = [];
    [s_ind,t_ind] = ind2ij(i,65536,65536);
% [s_ind,t_ind] = ind2ij(i,49152,16384);
    p = shortestpath(G,s_ind,t_ind,'Method','unweighted');
    for j=p
       [cur_x,cur_y] = ind2ij(j,256,256);
       record_line = [record_line;cur_x,cur_y];
       
    end
%     imagesc(reshape(test_samples(:,189),256,256)');
    line(record_line(:,1)',record_line(:,2)','color','r');
    
end



