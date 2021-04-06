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

%'20190115_liverfiber1_filter_ada',
%'20190115_liverfiber1_filter_auto',
%'20190117_liverfiber2_pos_nei4_div10_ada_gaussian',
%'20190117_liverfiber2_pos_nei4_div10_auto_gaussian',
%'20190117_liverfiber2_pos_nei8_div10_ada_gaussian',
%'20190117_liverfiber2_pos_nei8_div10_auto_gaussian'
%'20190115_liverfiber1_filter_magic',
%'20190303_liverfiber_fix',
%'20190303_liverfiber_fix_magic'
%'20190117_liverfiber2_pos_2_ada',
%'20190117_liverfiber2_pos_2_auto',
'20190117_liverfiber2_pos_gaussian_ada',
'20190117_liverfiber2_pos_gaussian_auto',
'20190117_liverfiber2_pos_ada',
'20190117_liverfiber2_pos_auto',

%'SPE1',
%'SPE1_magic',
%'SPE2',
%'SPE2_magic'
%'intestine_ada',
%'intestine-1_ada'

%'lung-type2_ada',
%'lung-type2_auto'

%'liver_hoechst_blood_ada',
%'liver_hoechst_blood_auto'
%'P3_low_1_auto',
%'P3_low_1_ada',
%'P3_low_2_auto',
%'P3_low_2_ada',
%'P3_low_3_auto',
%'P3_low_3_ada',
%'P3_high_1_auto',
%'P3_high_1_ada',
%'P3_high_2_auto',
%'P3_high_2_ada',

%'P3_high_1_ada_div10',
%'P3_high_1_auto_div10'
%'P3_high_2_ada_div10',
%'P3_high_2_auto_div10',

%'P4_low0_ada',
%'P4_low1_ada',
%'P4_high0_ada',
%'P4_high1_ada',
%'P4_high2_ada',
%'P4_high3_ada',


%'P4_low0_auto',
%'P4_low1_auto',
%'P4_high0_auto',
%'P4_high1_auto',
%'P4_high2_auto',
%'P4_high3_auto',
%'20190117_liverfiber1_pos_ada_div5',
%'20190117_liverfiber2_pos_ada_div5',
%'20190117_liverfiber1_pos_auto_div5',
%'20190117_liverfiber2_pos_auto_div5',


%'rat0_low0_auto',
%'rat0_low1_auto',
%'rat0_low0_ada',
%'rat0_low1_ada',
}
nei_type={
4,
4,
4,
4

}
edge_type_list={

'ada',
%'ada',
'auto',
%'auto',
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

'test_samples_209.mat',
'test_samples_209.mat',
'test_samples_209.mat',
'test_samples_209.mat',
%'test_samples_183.mat',
%'test_samples_183.mat',
%'test_samples_203.mat',
%'test_samples_203.mat',


%'test_samples_718.mat',
%'test_samples_718.mat',
%'test_samples_718.mat',
%'test_samples_718.mat',
%'test_samples_114.mat',
%'test_samples_114.mat'

%'test_samples_621',
%'test_samples_621',
%'test_samples_643',
%'test_samples_643',
%'test_samples_589',
%'test_samples_589',
%'test_samples_244',
%'test_samples_244',
%'test_samples_238',
%'test_samples_238',

%'test_samples_793',
%'test_samples_749',
%'test_samples_203',
%'test_samples_209',
%'test_samples_208',
%'test_samples_210',

%'test_samples_793',
%'test_samples_749',
%'test_samples_203',
%'test_samples_209',
%'test_samples_208',
%'test_samples_210',

%'test_samples_203',
%'test_samples_209',
%'test_samples_203',
%'test_samples_209',


%'test_samples_699',
%'test_samples_699',
%'test_samples_699',
%'test_samples_699',

}
process_path_pref = '/home/yzy/bioSIMS/data/process/';
test_sample20_file = 'test_samples_5.mat';
%use_edges = 0;
%default is 0
%for i=1:6
%process_path = [process_path_pref,name_list{i},'/'];
%test_sample_all_file = [test_sample_all_file_list{i}];
%run_zuzhi_func_go_choose_adaauto(process_path,test_sample_all_file,test_sample20_file,use_edges,edge_type_list{i});
%end



use_edges = 0;
%default is 0
for i=1:4
process_path = [process_path_pref,name_list{i},'/'];
test_sample_all_file = [test_sample_all_file_list{i}];
run_zuzhi_func_go_choose_adaauto(process_path,test_sample_all_file,test_sample20_file,use_edges,edge_type_list{i},nei_type{i});
end

