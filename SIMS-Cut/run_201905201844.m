name_list={
%'P5LC_POS1_HIGH0_gaussian_ada',
'P5LC_NEG1_HIGH0_None_ada',
'P5LC_NEG0_HIGH0_None_ada',
'P5LC_NEG0_HIGH0_None_auto',
};
nei_type={
%'4',
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
'4',
};
edge_type_list={
'ada',
'ada',
'auto',
};
test_sample_all_file_list={
%'test_samples_196.mat',
'test_samples_220.mat',
'test_samples_227.mat',
'test_samples_227.mat',
};

process_path_pref = '/home/yzy/bioSIMS/data/process/';
test_sample20_file = 'test_samples_5.mat';




use_edges = 0;
%default is 0
for i=1:3
process_path = [process_path_pref,name_list{i},'/'];
test_sample_all_file = [test_sample_all_file_list{i}];
run_zuzhi_func_go_choose_adaauto(process_path,test_sample_all_file,test_sample20_file,use_edges,edge_type_list{i},4);
end

