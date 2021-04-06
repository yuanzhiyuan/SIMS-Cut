
from utils import *

    # train_x,cell_idx,label,matter_list
    # labeling从0开始
    # label = optimal_labeling-1
def SIMS_diff(label,matter_list,train_x,cell_idx,save_path,mode=0,mode_arg=10,font_scale=1,figsize=(10,10),figformat='svg',use_saved_EMD=False):
    # [train_x,cell_idx,cell_type,cell_pos,batch_idx,num_cells] = get_train_data([1],mode='none',norm='none')
    label = label.astype('int')
    cell_idx=cell_idx.astype('int')
    n_label = np.unique(label).shape[0]
    
    
    print('mkdir {0}...'.format(save_path))
    if not os.path.exists(save_path):
        os.makedirs(save_path)
        print('done!')
    else:
        print('{0} already exists!'.format(save_path))

    save_path_k = '{0}k={1}/'.format(save_path,str(n_label))
    print('mkdir {0}...'.format(save_path_k))
    if not os.path.exists(save_path_k):
        os.makedirs(save_path_k)
        print('done!')
    else:
        print('{0} already exists!'.format(save_path_k))


    num_cells = np.max(cell_idx)
    num_features = train_x.shape[1]
    print('median spectrum normalizaiton...')
    pseudo_count = 0
    train_x_norm = (train_x+pseudo_count)/(np.percentile(train_x,80,axis=1,keepdims=True)+pseudo_count)
    train_x_norm = np.log(train_x_norm+1)
    # train_x_norm = MinMaxScaler().fit_transform(train_x_norm)
    mean_profile_list_norm = []
    for i in range(num_cells):
        mean_profile_list_norm.append(np.mean(train_x_norm[cell_idx==i+1,:],axis=0))
    mean_profile_list_norm = np.array(mean_profile_list_norm)

    print('calculating pairwise wasserstein distance...')
    cur_save_path = '{0}mid/{1}'.format(save_path,'EMD.pkl')
    cell_pixel_dict = {}
    pixel_count = []
    for i in range(num_cells):
        cur_pixels = train_x_norm[cell_idx==i+1,:]
        cell_pixel_dict[i] = cur_pixels
        pixel_count.append(cur_pixels.shape[0])
    if use_saved_EMD:
        dist_mat = pickle.load(open(cur_save_path,'rb'))
    else:
        dist_mat = np.zeros(shape=(num_features,num_cells,num_cells))
        for k in range(num_features):
            print(k)
        
            for i in range(num_cells):
                for j in range(num_cells):
                    cur_dist = wasserstein_distance(cell_pixel_dict[i][:,k],cell_pixel_dict[j][:,k])
                    dist_mat[k,i,j] = cur_dist
        pickle.dump(dist_mat,open(cur_save_path,'wb'))
    print('done!')
    # 给定label，计算wbratio的matrix，找差异物质
    # select_k = 0
    # label = label_list[select_k]
    print('calculating WB ratio matrix...')
    # label=pred_y2
    wbr_mat_list = np.zeros(shape=(num_features,n_label,n_label))

    for i in range(num_features):
        cur_dist_mat = dist_mat[i,:,:]
        cur_wbr_mat = np.zeros(shape=(n_label,n_label))
        for j in range(n_label):
            for k in range(n_label):
    #             within_sum_j = np.sum(dist_mat[i,:,:][label==j,:][:,label==j])
    #             within_sum_k = np.sum(dist_mat[i,:,:][label==k,:][:,label==k])
    #             between_sum_1 = np.sum(dist_mat[i,:,:][label==j,:][:,label==k])
    #             between_sum_2 = np.sum(dist_mat[i,:,:][label==k,:][:,label==j])
                within_sum_j = np.mean(dist_mat[i,:,:][label==j,:][:,label==j])
                within_sum_k = np.mean(dist_mat[i,:,:][label==k,:][:,label==k])
                between_sum_1 = np.mean(dist_mat[i,:,:][label==j,:][:,label==k])
                between_sum_2 = np.mean(dist_mat[i,:,:][label==k,:][:,label==j])



    #             cur_wbr_mat[j,k] = (within_sum_j+within_sum_k)/(between_sum_1+between_sum_2)
    # 改为bwratio，则越大越好
                cur_wbr_mat[j,k] = (between_sum_1+between_sum_2)/(within_sum_j+within_sum_k)


        wbr_mat_list[i,:,:] = cur_wbr_mat


    print('drawing MA plot...')
    MAPlot_data = {
        'matter':[],
        'WB_Ratio':[],
        'VS Clusters':[],
        'Average Expression':[],
        'selected':[]
    }
    idx_list = []

    for matter_idx in range(num_features):
        for i in range(n_label):
            for j in range(i+1,n_label):
    #             0是outlier
    #             if i==0:
    #                 continue
                
                
                i_cluster_mean = np.mean(mean_profile_list_norm[label==i,matter_idx])
                j_cluster_mean = np.mean(mean_profile_list_norm[label==j,matter_idx])
                wbr_sign = np.sign(i_cluster_mean-j_cluster_mean)
                
                cur_matter = matter_list[matter_idx]
                cur_vs = 'cluster {i} vs cluster {j}'.format(i=i,j=j)
                cur_wbr = wbr_sign*np.log2(wbr_mat_list[matter_idx,i,j])
                cur_ave = i_cluster_mean+j_cluster_mean
                MAPlot_data['matter'].append(cur_matter)
                MAPlot_data['WB_Ratio'].append((cur_wbr))      
                MAPlot_data['VS Clusters'].append(cur_vs) 
                MAPlot_data['Average Expression'].append((cur_ave))
                if matter_idx in idx_list:
                    MAPlot_data['selected'].append(1)
                else:
                    MAPlot_data['selected'].append(0)
    MAPlot_df = pd.DataFrame(MAPlot_data)           
    # compare_cluster_list = [5,7]
    # for i in range(n_label):
    #     for j in range(i+1,n_label):
    sns.set(font_scale=font_scale)
    cluster_cmp = sns.hls_palette(n_label)

    for i in range(n_label):
        for j in range(i+1,n_label):
            print('label=j',np.sum(label==j))
            unique_idx_list = []

            MAPlot_df = pd.DataFrame(MAPlot_data) 
            cur_unique_idx_list = get_diff_matter_idx(i,j,MAPlot_df,mode,mode_arg,matter_list)
            print('cur_unique_idx_list',cur_unique_idx_list)
            unique_idx_list.extend(cur_unique_idx_list)
            cur_save_path = '{0}{1}vs{2}/'.format(save_path_k,str(i),str(j))
            print('mkdir {0}...'.format(cur_save_path))
            if not os.path.exists(cur_save_path):
                os.makedirs(cur_save_path)
                print('done!')
            else:
                print('{0} already exists!'.format(cur_save_path))

            cur_save_file = '{0}{1}vs{2}/MAPlot_{1}vs{2}.{3}'.format(save_path_k,str(i),str(j),figformat)

            print('saving {0}vs{1} MAPlot to {2}'.format(str(i),str(j),cur_save_file))
            sns.set(style="white", font_scale=font_scale)
            MAPlot_df = pd.DataFrame(MAPlot_data) 
            MAPlot_df = MAPlot_df[MAPlot_df['VS Clusters']=='cluster {0} vs cluster {1}'.format(str(i),str(j))]
            fig, ax1= plt.subplots(1, 1,figsize=figsize)
            sns.scatterplot(x='Average Expression',y='WB_Ratio',hue='VS Clusters',data=MAPlot_df,legend='full')
            ax1.axhline(y=0, color="red", linestyle="--")
            # plt.savefig('AB-H_MAPlot.svg',transparent=True,format='svg')
            for index, row in MAPlot_df.iterrows():
                if -0.5<row['WB_Ratio']<0.5:
                    continue
                plt.annotate(str(row['matter']),(row['Average Expression'],row['WB_Ratio']))

            plt.savefig(cur_save_file,transparent=True,format=figformat)

            print('done!')

            cur_save_file = '{0}{1}vs{2}/Heatmap_{1}vs{2}.{3}'.format(save_path_k,str(i),str(j),figformat)
            print('saving {0}vs{1} Heatmap to {2}'.format(str(i),str(j),cur_save_file))
            label_sort = np.argsort(label)
            sorted_label = np.sort(label)
            unique_idx_list = list(set(unique_idx_list))
            print(unique_idx_list)
            selected_matter_list = [matter_list[i] for i in unique_idx_list]
            # lut = dict(zip(set(sorted_label), sns.hls_palette(len(set(sorted_label)), l=0.5, s=0.8)))
            lut = dict(zip(set(sorted_label),cluster_cmp))
            col_colors = pd.DataFrame(sorted_label)[0].map(lut)
                
            # de_matter_list = np.vstack([de_matter_list_1,de_matter_list_2])
            de_matter_list = np.transpose(mean_profile_list_norm[:,unique_idx_list][label_sort,:])
            sns.clustermap(figsize=figsize,col_colors=col_colors,row_cluster=False,data=pd.DataFrame(de_matter_list),col_cluster=False,cmap="vlag",standard_scale=0,square=False,yticklabels=selected_matter_list,xticklabels=False)
            # sns.clustermap(col_colors=col_colors,col_linkage=linkage_mat,row_cluster=True,data=de_matter_list,col_cluster=True,cmap="vlag")

            plt.savefig(cur_save_file,transparent=True,format=figformat)
    
    cur_save_file = '{0}Heatmap_whole.{1}'.format(save_path_k,figformat)
    print('saving whole Heatmap to {0}'.format(cur_save_file))

    de_matter_list = np.transpose(mean_profile_list_norm[:,:][label_sort,:])
    sns.clustermap(figsize=(40,40),col_colors=col_colors,row_cluster=True,data=pd.DataFrame(de_matter_list),col_cluster=False,cmap="vlag",standard_scale=0,square=False,yticklabels=matter_list,xticklabels=False)
    plt.savefig(cur_save_file,transparent=True,format=figformat)
    

    # CM = CM_list[0]
    # CM = CM/np.max(CM)
    # my_color = ['red','yellow','green','blue','purple']
    # my_color = ['red','yellow','green']
    # my_color = ['red','orange','yellow','green','blue','purple']

    # linkage_mat = hc.linkage(1-CM, method='single',optimal_ordering=True)

    # plt.figure(figsize=(5,5))


    

    # plt.savefig('/home/yzy/data_dump/liver/diffplot.svg',transparent=True,format='svg')
