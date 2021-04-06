name_list={
'P2_None_ada',
'P2_None_auto',
'P3_R3_None_ada',
'P3_R3_None_auto',
'P3_R4_None_ada',
'P3_R4_None_auto',
'P3_R5_None_ada',
'P3_R5_None_auto',
'P3_R6_None_ada',
'P3_R6_None_auto',
};
nei_type={
'4',
'4',
'4',
'4',
'4',
'4',
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
'ada',
'auto',
'ada',
'auto',
'ada',
'auto',
};
test_sample_all_file_list={
'test_samples_165.mat',
'test_samples_165.mat',
'test_samples_254.mat',
'test_samples_254.mat',
'test_samples_254.mat',
'test_samples_254.mat',
'test_samples_254.mat',
'test_samples_254.mat',
'test_samples_254.mat',
'test_samples_254.mat',
};
top_k_name_list={
'test_samples_20',
'test_samples_20',
'test_samples_20',
'test_samples_20',
'test_samples_20',
'test_samples_20',
'test_samples_20',
'test_samples_20',
'test_samples_20',
'test_samples_20',
};
divn_list={
'20',
'20',
'20',
'20',
'20',
'20',
'20',
'20',
'20',
'20',
};

process_path_pref = '/home/yzy/bioSIMS/data/process/';
%test_sample20_file = 'test_samples_5.mat';




use_edges = 0;
%default is 0
for i=1:size(name_list,1)
process_path = [process_path_pref,name_list{i},'/'];
test_sample_all_file = [test_sample_all_file_list{i}];
run_zuzhi_func_go_choose_adaauto(process_path,test_sample_all_file,top_k_name_list{i},use_edges,edge_type_list{i},4,str2num(divn_list{i}));
end

