name_list = {
%'20190103_lung1_filter',
%'20190103_lung2_filter',

%'20190103_lung3_filter',
%'20190103_lung4_filter',
%'20190103_intestine1_filter',
%'20190103_intestine2_filter'


%'20190105_skeletalmuscle1_filter',
%'20190105_skeletalmuscle2_filter',
%'20190103_lung3_all',
%'20190103_lung4_all',
%'20190115_liverfiber1_filter',
%'20190115_liverfiber2_filter'

%'20190117_liverfiber1_pos',
%'20190117_liverfiber2_pos',
%'20190303_liverfiber_fix',
%'20190303_liverfiber_nofix'
%#'20190308_liver_P1LF2_1',
%'20190308_liver_P1LF2_2'

%'20190115_liverfiber1_filter',
%'20190115_liverfiber1_filter_magic',
%'20190303_liverfiber_fix',
%'20190303_liverfiber_fix_magic'


%'SPE1',
%'SPE1_magic',
%'SPE2',
%'SPE2_magic'
%'intestine_ada',
%'intestine-1_ada'

%'lung-type2_ada',
%'lung-type2_auto'

'liver_hoechst_blood_ada',
'liver_hoechst_blood_auto'
}
edge_type_list={
'ada',
'auto'
}
test_sample_all_file_list = {
%'test_samples_168.mat',
%'test_samples_165.mat',
%'test_samples_164.mat',
%'test_samples_159.mat',
%'test_samples_202.mat',
%'test_samples_181.mat',
%'test_samples_230.mat',
%'test_samples_231.mat'

%'test_samples_225.mat',
%'test_samples_220.mat'
%'test_samples_198.mat'
%'test_samples_191.mat'

%'test_samples_203.mat'
%'test_samples_209.mat'

%'test_samples_183.mat'
%'test_samples_185.mat'

%'test_samples_157.mat'
%'test_samples_165.mat'

%'test_samples_198.mat',
%'test_samples_198.mat',
%'test_samples_183.mat',
%'test_samples_183.mat',


%'test_samples_718.mat',
%'test_samples_718.mat',
%'test_samples_718.mat',
%'test_samples_718.mat',
'test_samples_114.mat',
'test_samples_114.mat'
}
process_path_pref = '/home/yzy/bioSIMS/data/process/';
test_sample20_file = 'test_samples_20.mat';
use_edges = 1;
%default is 0
for i=1:2
process_path = [process_path_pref,name_list{i},'/'];
test_sample_all_file = [test_sample_all_file_list{i}];
run_zuzhi_func_go_choose_adaauto(process_path,test_sample_all_file,test_sample20_file,use_edges,edge_type_list{i});
end
