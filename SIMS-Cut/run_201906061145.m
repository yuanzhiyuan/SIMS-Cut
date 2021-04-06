name_list={
'mouse0_liver0_neg0_high0_div5_None_ada',
'mouse0_liver0_neg0_high0_div5_None_auto',
'mouse0_liver0_neg1_high0_div5_None_ada',
'mouse0_liver0_neg1_high0_div5_None_auto',
};
nei_type={
'4',
'4',
'4',
'4',
};
edge_type_list={
'ada',
'auto',
'ada',
'auto',
};
test_sample_all_file_list={
'test_samples_224.mat',
'test_samples_224.mat',
'test_samples_244.mat',
'test_samples_244.mat',
};
top_k_name_list={
'test_samples_20',
'test_samples_20',
'test_samples_20',
'test_samples_20',
};

process_path_pref = '/home/yzy/bioSIMS/data/process/';
%test_sample20_file = 'test_samples_5.mat';




use_edges = 0;
%default is 0
for i=1:size(name_list,1)
process_path = [process_path_pref,name_list{i},'/'];
test_sample_all_file = [test_sample_all_file_list{i}];
run_zuzhi_func_go_choose_adaauto(process_path,test_sample_all_file,top_k_name_list{i},use_edges,edge_type_list{i},4,5);
end

