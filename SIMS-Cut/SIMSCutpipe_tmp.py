import os
from tools.SIMSCut_preprocess import *
import shutil
import datetime
import time
#dataname_list=['rat0_neg0_low0','rat0_neg1_low0','rat0_pos1_low0','rat0_neg1_high0','rat0_pos1_high0','rat0_pos1_high1']
#dataname_list=['rat0_pos1_high0','rat0_pos1_high1']
#dataname_list=['P5LC_POS1_LOW0','P5LC_POS1_HIGH0','P5LC_NEG1_LOW0','P5LC_NEG1_HIGH0','P5LC_NEG0_LOW0','P5LC_NEG0_HIGH0']
#dataname_list=['P5LC_POS1_HIGH0','P5LC_NEG1_HIGH0','P5LC_NEG0_HIGH0']
#dataname_list=['rat0_neg1_high0','rat0_pos1_high0','rat0_pos1_high1']
#dataname_list=['mouse0_liver0_neg1_high0_5','mouse0_liver0_neg1_high0_20']

#dataname_list=['mouse0_liver0_neg2_high0','mouse0_liver0_pos1_high0','mouse0_liver0_pos2_high0']
#dataname_list=['mouse0_liver0_neg2_high0','mouse0_liver0_pos2_high0','mouse0_liver0_pos1_high0']
#dataname_list=['mouse0_kidney0_neg0_high0_5','mouse0_kidney0_neg0_high0_20']
#dataname_list=['mouse0_liver0_neg0_high0_div15','mouse0_liver0_neg1_high0_div15']
#dataname_list=['mouse0_lung0_pos0_high0_div20','mouse0_lung0_neg0_high0_div20']
#dataname_list=['mouse0_liver0_neg1_low0_div15','mouse0_liver0_pos1_low0_div15']
#dataname_list=['mouse0_liver0_neg1_high0_div10','mouse0_liver0_neg1_high0_div15']
#A_matter_list=[134.48,134.48]
#dataname_list=['mouse0_liver0_neg1_low0_div10_0619','mouse0_liver0_neg1_low0_div15_0619']
#dataname_list=['mouse0_liver0_neg0_low_PC0_div20','mouse0_liver0_neg0_low_PC1_div20','mouse0_liver0_neg0_low_PC2_div20','mouse0_liver0_neg0_low_PC3_div20']
#A_matter_list=[134.03,133.58,134.03,133.88]
#divn_list=[20,20,20,20]
#dataname_list=['191125_gastric_div20','191125_gastric_div15']
#dataname_list=['P6_neg0_low0','P6_neg1_low0','P6_neg2_low0','P6_neg3_low0',]
#A_matter_list=[134.45,134.45,134.45,134.46]
#divn_list=[20,20,20,20]

#dataname_list=['P2','P3_R3','P3_R4','P3_R5','P3_R6']
#A_matter_list=[134.45,134.47,134.47,134.46,134.47]
#divn_list=[20,20,20,20,20]

#dataname_list=['P3_R4','P3_R5','P3_R6']
#A_matter_list=[134.47,134.46,134.47]
#divn_list=[20,20,20]

#dataname_list=['cl_10a','cl_a549','cl_hela','cl_sk']
#A_matter_list=[134.05,134.05,134.05,134.05]
#divn_list=[20,20,20,20]

#dataname_list=['test_MIBI_512_div5_top20_gaussian','test_MIBI_512_div2_top20_gaussian','test_MIBI_512_div5_top10_gaussian','test_MIBI_512_div2_top10_gaussian']
#dataname_list=['test_MIBI_2048_div5_top10_gaussian','test_MIBI_2048_div10_top10_gaussian','test_MIBI_2048_div20_top10_gaussian','test_MIBI_2048_div30_top10_gaussian']
dataname_list = ['lung_cut']
A_matter_list=[134.48]
divn_list=[10]
#A_matter_list=[134.04,124.94]
#A_matter_list=[134.03,134.03,124.93,181.68,125.55,125.40]
#A_matter_list=[125.55,125.40]
#A_matter_list=[124.94,125.37,134.00,181.44,134.02,134.48]
#A_matter_list=[125.37,181.44,134.48]
#A_matter_list=[181.68,125.55,125.40]
#A_matter_list=[180.74,180.74]

#A_matter_list=[125.00,134.06]
#ptype_list=['gaussian',,None]
#ptype_list=[None,None,None,None]
ptype_list=['gaussian']
top_k_list=[5]
renamer_list=[0]
sz_list = [2048]
epoch_list = [5]
rbm_ratio_list = [0.01]
process_data_path = '/home/yzy/bioSIMS/data/process/'


matlab_info = {
	'name_list':[],
	'nei_type':[],
	'edge_type_list':[],
	'test_sample_all_file_list':[],
	'top_k_name_list':[],
	'divn_list':[],
        'epoch_list':[],
        'rbm_ratio_list':[],
        'sz_list':[]
}


os.chdir(process_data_path)
for i in range(len(dataname_list)):
	dataname=dataname_list[i]
	A_matter=A_matter_list[i]
	for ptype in ptype_list:
		
			
		data_name,n_matter=SIMSCut_preprocess(dataname,A_matter,ptype,top_k_list[i],renamer_list[i],sz_list[i])
		src = process_data_path+data_name
		dist1 = process_data_path+data_name+'_ada'
		os.system('cp -r {src} {dist}'.format(src=src,dist=dist1))
		matlab_info['name_list'].append(data_name+'_ada')
		matlab_info['nei_type'].append(4)
		matlab_info['edge_type_list'].append('ada')
		matlab_info['test_sample_all_file_list'].append('test_samples_{n_matter}.mat'.format(n_matter=n_matter))
		matlab_info['top_k_name_list'].append('test_samples_{0}'.format(top_k_list[i]))
		matlab_info['divn_list'].append(divn_list[i])
		matlab_info['epoch_list'].append(epoch_list[i])
		matlab_info['rbm_ratio_list'].append(rbm_ratio_list[i])
		matlab_info['sz_list'].append(sz_list[i])

		dist2 = process_data_path+data_name+'_auto'
		os.system('cp -r {src} {dist}'.format(src=src,dist=dist2))
		matlab_info['name_list'].append(data_name+'_auto')
		matlab_info['nei_type'].append(4)
		matlab_info['edge_type_list'].append('auto')
		matlab_info['test_sample_all_file_list'].append('test_samples_{n_matter}.mat'.format(n_matter=n_matter))
		matlab_info['top_k_name_list'].append('test_samples_{0}'.format(top_k_list[i]))
		matlab_info['divn_list'].append(divn_list[i])
		matlab_info['epoch_list'].append(epoch_list[i])
		matlab_info['rbm_ratio_list'].append(rbm_ratio_list[i])
		matlab_info['sz_list'].append(sz_list[i])
		

matlab_code_temp = """
process_path_pref = '/home/yzy/bioSIMS/data/process/';
%test_sample20_file = 'test_samples_5.mat';




use_edges = 0;
%default is 0
for i=1:size(name_list,1)
process_path = [process_path_pref,name_list{i},'/'];
test_sample_all_file = [test_sample_all_file_list{i}];
run_zuzhi_func_go_choose_adaauto_ext(process_path,test_sample_all_file,top_k_name_list{i},use_edges,edge_type_list{i},4,str2num(divn_list{i}),str2num(sz_list{i}),str2num(epoch_list{i}),str2num(rbm_ratio_list{i}));
end

"""
matlab_code_comp = ''
for key,val in matlab_info.items():
	cur_code = key+'={'+'\n'
	val_str_list = ['\''+str(v)+'\''+','+'\n' for v in val]
	val_str = ''.join(val_str_list)
	cur_code += val_str
	cur_code += '};\n'
	matlab_code_comp+=cur_code
matlab_code = matlab_code_comp +matlab_code_temp

#cur_time_str = f"{datetime.datetime.now():%Y-%m-%d}"
cur_time_str=time.strftime("%Y%m%d%H%M")
matlab_script_name = '/home/yzy/bioSIMS/code/run_{0}.m'.format(cur_time_str)
with open(matlab_script_name,'w') as f:
	f.write(matlab_code)







