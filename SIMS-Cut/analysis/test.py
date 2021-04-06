from utils import *
from SIMS_cluster import *
from SIMS_diff import *
plt.switch_backend('agg')
# data_mat_filename='/home/yzy/SIMS/data_mat_fiber241_1023.mat'
data_mat_filename='/home/yzy/SIMS/datamat_181126_lung_306.mat'


mode='none'
norm='none'
use_representation_list=['total_mean']
use_algorithm_list=['UMAP_HDBSCAN']
[original_data,cell_related_data]=get_train_data(data_mat_filename,mode,norm,batch_num_list=[1])
train_x=cell_related_data['train_x']
cell_idx=cell_related_data['cell_idx']
cell_pos=cell_related_data['cell_pos']
k=-8
save_path='/home/yzy/bioSIMS/data/process/datamat_181126_lung_306/cluster/'
#[optimal_k_idx,final_label_list] = SIMS_cluster(train_x,cell_idx,cell_pos,k,save_path,use_representation_list,use_algorithm_list,true_y=None,figsize=(10,10),figformat='png')
[optimal_k_idx,final_label_list] = SIMS_cluster(train_x,cell_idx,cell_pos,k,save_path,true_y=None,figsize=(10,10),figformat='svg')

matter_list = [50.13, 51.08, 52.08, 53.08, 54.11, 55.09, 56.09, 57.08, 58.09, 63.06, 64.11, 65.11, 66.11, 67.13, 68.13, 69.13, 70.15, 71.15, 72.14, 73.16, 74.13, 75.13, 79.1, 80.12, 81.14, 82.17, 83.19, 84.17, 85.2, 86.16, 87.19, 88.18, 89.18, 90.18, 91.17, 92.19, 93.21, 94.21, 95.21, 96.22, 97.2, 98.23, 99.23, 101.21, 104.22, 105.23, 106.24, 107.23, 108.26, 109.26, 110.27, 111.28, 112.23, 113.31, 114.28, 115.25, 121.26, 122.28, 123.3, 124.3, 125.33, 126.29, 127.34, 128.26, 129.33, 130.32, 131.3, 133.3, 134.34, 135.32, 139.34, 140.34, 141.37, 142.35, 143.33, 144.31, 145.33, 146.35, 147.36, 148.36, 149.35, 150.37, 151.39, 152.4, 153.44, 154.43, 155.46, 156.44, 157.4, 158.41, 159.33, 161.38, 162.39, 163.36, 164.42, 165.4, 166.43, 167.46, 168.48, 169.48, 170.51, 171.42, 172.47, 173.46, 174.43, 175.46, 181.4, 182.44, 183.49, 184.54, 185.49, 186.5, 187.46, 188.54, 189.55, 190.51, 191.5, 194.5, 195.51, 199.45, 201.52, 202.55, 203.51, 204.54, 205.55, 206.58, 207.6, 208.54, 209.63, 211.58, 213.59, 215.53, 217.5, 225.55, 227.6, 231.55, 233.6, 241.59, 257.59, 261.6, 275.63, 277.71, 281.97, 283.95, 301.8, 317.77, 323.84, 340.17, 386.06, 426.16]
for i in range(len(final_label_list)):
	cur_label = final_label_list[i]
	cur_label -= np.min(cur_label)

	SIMS_diff(cur_label,matter_list,train_x,cell_idx,save_path)
