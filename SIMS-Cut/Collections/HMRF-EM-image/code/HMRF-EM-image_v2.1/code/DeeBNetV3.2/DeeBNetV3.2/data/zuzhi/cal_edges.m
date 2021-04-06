test_samples_li = {
    'liver-cancer-1_20',
    'liver-cancer-2_20',
    'liver-xwh-1_20',
    'liver-xwh-2-1_20',
    'liver-xwh-2-2_20',
    'liver-xwh-3_20'
};
test_samples_path = 'C:\Users\yzy\Documents\SIMS\MATLAB\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\zuzhi\';
save_path = 'C:\Users\yzy\Documents\SIMS\MATLAB\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\pairwise_edges\0713\';

for i=2:6
    cur_sample = test_samples_li{i};
    cur_file = [test_samples_path,cur_sample,'.mat'];
    load(cur_file);
    [edges] = get_BK_pairwise(test_samples,1,256,256);
    [ada_edges] = adaptive_constrast2(edges,21,256,256);
    to_save_edges = [save_path,cur_sample,'_auto.mat'];
    to_save_adaedges = [save_path,cur_sample,'_ada21auto.mat'];
    save(to_save_edges,'edges');
    save(to_save_adaedges,'ada_edges');
    
end