from utils import *

def SIMS_cluster(train_x,cell_idx,cell_pos,k,save_path,use_representation_list=['total_mean','median_mean','SIMS_id'],use_algorithm_list=['SC3','SIMLR','UMAP_HDBSCAN'],whole_CM_mat=False,ntimes=1,true_y=None,figsize=(10,10),font_scale=1.5,figformat='svg'):

    # save_path = '/home/yzy/bioSIMS/data/process/cluster/'
        cell_idx=cell_idx.astype('int')
        mid_path = save_path+'mid/'
        rst_path = save_path+'rst/'
        time_str = time.strftime("%Y%m%d%H%M%S")

        print('mkdir {0}...'.format(save_path))
        if not os.path.exists(save_path):
                os.makedirs(save_path)
                print('done!')
        else:
                print('{0} already exists!'.format(save_path))



        print('mkdir {0}...'.format(mid_path))
        if not os.path.exists(mid_path):
                os.makedirs(mid_path)
                print('done!')
        else:
                print('{0} already exists!'.format(mid_path))

        print('mkdir {0}...'.format(rst_path))
        if not os.path.exists(rst_path):
                os.makedirs(rst_path)
                print('done!')
        else:
                print('{0} already exists!'.format(rst_path))




        start_time = timeit.default_timer()
    # eng.quit()
        print('starting matlab engine...')
        eng = matlab.engine.start_matlab()
        print('done!')
    # k=-8
    # true_y = None

#         train_x是不经过任何处理的train_x
#         如果k<-1，就取估计一个最好的
#         先准备representation_list
        if true_y is None:
                true_y = np.zeros(shape=(int(np.max(cell_idx)),))
        train_x_original = train_x
        num_cells = np.max(cell_idx)
        representation_list = []
        rep_name_list = []

        if 'total_mean' in use_representation_list:
            print('preparing total mean reprentation...')
            start = timeit.default_timer()
    #         先准备一个total
            train_x_total = train_x/np.sum(train_x_original,axis=1,keepdims=True)
            train_x_total = np.log(train_x_total+1)
            mean_profile_list_total = []
            for i in range(num_cells):
                    mean_profile_list_total.append(np.mean(train_x_total[cell_idx==i+1,:],axis=0))
            mean_profile_list_total = np.array(mean_profile_list_total)
            representation_list.append(mean_profile_list_total)
            rep_name_list.append('total_mean')
            stop = timeit.default_timer()
            print('done! Time cost: ',stop-start)
        #
#         再准备三个median
        if 'median_mean' in use_representation_list:
            perc_list = [50,70,90]
            for perc in perc_list:
                    print('preparing {0}percentile median mean reprentation...'.format(perc))
                    start = timeit.default_timer()
                    
                    train_x_median = (train_x+1)/(np.percentile(train_x_original,perc,axis=1,keepdims=True)+1)
                    train_x_median = np.log(train_x_median+1)
                    mean_profile_list_median = []
                    for i in range(num_cells):
                            mean_profile_list_median.append(np.mean(train_x_median[cell_idx==i+1,:],axis=0))
                    mean_profile_list_median = np.array(mean_profile_list_median)
                    representation_list.append(mean_profile_list_median)
                    rep_name_list.append('{0}median_mean'.format(perc))
                    
                    stop = timeit.default_timer()
                    print('done! Time cost: ',stop-start)
        
        if 'SIMS_id' in use_representation_list:
#         再准备distill
            print('preparing SIMS-id reprentation...')
            start = timeit.default_timer()
            SIMS_id_t_list = [5,10,15,20,25,30,35,40,50]
            SIMS_id_name_list = list(map(lambda x:str(x)+'SIMS_id',SIMS_id_t_list))

            train_x_l1 = Normalizer(norm='l1').fit_transform(train_x)
            rep_list = get_distil_rep(train_x_l1,cell_idx,num_cells,SIMS_id_t_list, verbose=False,epochs=300)
            representation_list.extend(rep_list)
            
            rep_name_list.extend(SIMS_id_name_list)
            stop = timeit.default_timer()
            print('done! Time cost: ',stop-start)


        cur_save_file = '{0}rep_dict_{1}.pkl'.format(mid_path,time_str)
        print('saving representation list to {0}'.format(cur_save_file))
        rep_dict = dict(zip(rep_name_list,representation_list))
        pickle.dump(rep_dict,open(cur_save_file,"wb"))
        print('done!')

        label_list = []
        CM_list = [np.zeros(shape=(num_cells,num_cells))]*(int(np.abs(k))-1)
        label_name_list = []
        label_ari_list = []
        for rep_idx in range(len(representation_list)):
            rep = representation_list[rep_idx]
            rep_name = rep_name_list[rep_idx]
            for nt in range(ntimes):
                
                if 'UMAP_HDBSCAN' in use_algorithm_list:
                    print('{1}/{2}th umap_euclidean clustering in {0}...'.format(rep_name,str(nt),str(ntimes)))
                    start = timeit.default_timer()
                    umap_embed_euc = umap.UMAP(n_components=10,metric='euclidean',n_neighbors=30,min_dist=0).fit_transform(rep)
                    # label_umap_euc = hdbscan.HDBSCAN(min_cluster_size=10).fit_predict(umap_embed_euc)
                    for cur_k in list(np.arange(2,np.abs(k)+1)):
                        cur_label = KMeans(cur_k).fit_predict(umap_embed_euc)
                        CM_list[cur_k-2]+=label2CM(cur_label)
                    stop = timeit.default_timer()
                    # ari = adjusted_mutual_info_score(true_y,label_umap_euc)
                    # label_ari_list.append(ari)
                    print('done! Time cost: ',stop-start)
                    





                    # print('umap_cosine clustering in {0}...'.format(rep_name))
                    print('{1}/{2}th umap_cosine clustering in {0}...'.format(rep_name,str(nt),str(ntimes)))

                    start = timeit.default_timer()
                    umap_embed_cos = umap.UMAP(n_components=10,metric='cosine',n_neighbors=30,min_dist=0).fit_transform(rep)
                    # label_umap_cos = hdbscan.HDBSCAN(min_cluster_size=10).fit_predict(umap_embed_cos)
                    for cur_k in list(np.arange(2,np.abs(k)+1)):
                        cur_label = KMeans(cur_k).fit_predict(umap_embed_cos)
                        CM_list[cur_k-2]+=label2CM(cur_label)
                    stop = timeit.default_timer()
                    # ari = adjusted_mutual_info_score(true_y,label_umap_cos)
                    # label_ari_list.append(ari)
                    # print('done! Time cost: ',stop-start,'ari: ',ari,'k: ',np.unique(label_umap_cos))
                    print('done! Time cost: ',stop-start)
                 




                    # print('umap_correlation clustering in {0}...'.format(rep_name))
                    print('{1}/{2}th umap_correlation clustering in {0}...'.format(rep_name,str(nt),str(ntimes)))

                    start = timeit.default_timer()
                    umap_embed_cor = umap.UMAP(n_components=10,metric='correlation',n_neighbors=30,min_dist=0).fit_transform(rep)
                    # label_umap_cor = hdbscan.HDBSCAN(min_cluster_size=10).fit_predict(umap_embed_cor)
                    for cur_k in list(np.arange(2,np.abs(k)+1)):
                        cur_label = KMeans(cur_k).fit_predict(umap_embed_cor)
                        CM_list[cur_k-2]+=label2CM(cur_label)
                    stop = timeit.default_timer()
                    # ari = adjusted_mutual_info_score(true_y,label_umap_cor)
                    # label_ari_list.append(ari)
                    # print('done! Time cost: ',stop-start,'ari: ',ari,'k: ',np.unique(label_umap_cor))
                    print('done! Time cost: ',stop-start)

                
                
                
                    

        cur_save_file = '{0}CM_list_{1}.pkl'.format(mid_path,time_str)
        print('saving CM_list to {0}'.format(cur_save_file))
        # label_name_dict = dict(zip(label_name_list,label_list))
        pickle.dump(CM_list,open(cur_save_file,"wb"))
        print('done!')

        if whole_CM_mat:
            # adding all k's CM
            CM_tmp = np.zeros(shape=(num_cells,num_cells))
            for CM in CM_list:
                CM_tmp += CM
            CM_list = [CM_tmp]*(int(np.abs(k))-1)

        CM_label_list = []

        for i in range(len(CM_list)):
            print('AgglomerativeClustering on CM k={0}'.format(str(i+2)))
            CM = CM_list[i]
            CM = CM/np.max(CM)
       
            linkage_mat = hc.linkage(1-CM, method='complete',optimal_ordering=True)

            consensus_label=AgglomerativeClustering(n_clusters=i+2,affinity='precomputed',linkage='complete').fit_predict(1-CM)
        
            
            
            data_matrix = pd.DataFrame(1-CM)

        #     labels = np.random.random_integers(0,5, size=50)
            lut = dict(zip(set(consensus_label), sns.hls_palette(len(set(consensus_label)))))
            row_colors = pd.DataFrame(consensus_label)[0].map(lut)
            
            
            cur_save_file = '{0}CM_mat_k={2}.{1}'.format(rst_path,figformat,str(i+2))
            print('saving CM_mat_k={1} to {0}...'.format(cur_save_file,str(i+2)))
            sns.set(style="white", font_scale=font_scale)
            # fig = plt.figure(figsize=figsize)
            sns.clustermap(data_matrix, figsize=figsize,row_linkage=linkage_mat, col_linkage=linkage_mat,cmap='vlag',row_colors=row_colors,col_colors=row_colors,linewidths=0)
        #     sns.clustermap(data_matrix, row_linkage=linkage_mat, col_linkage=linkage_mat,figsize=(5,5),row_colors=row_colors,col_colors=row_colors)
            CM_label_list.append(consensus_label)
            plt.savefig(cur_save_file,transparent=True,format=figformat,bbox_inches='tight')

            # plt.show()


        import matplotlib.cm as cm
        sns.set(style="white", font_scale=font_scale)

        silhouette_list = []
        consensus_k_range = list(np.arange(2,np.abs(k)+1))

        a = 0.2
        # fig = plt.figure()
        CM_list_norm = []
        for i in range(len(CM_list)):
            CM = CM_list[i]
            CM = CM/CM[0,0]
            CM_list_norm.append(CM)

        #     n_bins = 1000
        # #     plt.subplot(1,len(CM_list),i+1)
        #     bins = bins[0:-1]
            consensus_label = CM_label_list[i]
            silhouette_list.append(silhouette_score(1-CM,metric='precomputed',labels = consensus_label))
            
            
            fig, ax1= plt.subplots(1, 1)
            cluster_labels = consensus_label
            silhouette_avg = silhouette_score(1-CM,metric='precomputed',labels = consensus_label)
            sample_silhouette_values = silhouette_samples(1-CM, metric='precomputed',labels = consensus_label)
            n_clusters = i+2
            y_lower = 10
            for i in range(n_clusters):
                # Aggregate the silhouette scores for samples belonging to
                # cluster i, and sort them
                ith_cluster_silhouette_values = \
                    sample_silhouette_values[cluster_labels == i]

                ith_cluster_silhouette_values.sort()

                size_cluster_i = ith_cluster_silhouette_values.shape[0]
                y_upper = y_lower + size_cluster_i

                color = cm.nipy_spectral(float(i) / n_clusters)
                ax1.fill_betweenx(np.arange(y_lower, y_upper),
                                  0, ith_cluster_silhouette_values,
                                  facecolor=color, edgecolor=color, alpha=0.7)

                # Label the silhouette plots with their cluster numbers at the middle
                ax1.text(-0.05, y_lower + 0.5 * size_cluster_i, str(i))

                # Compute the new y_lower for next plot
                y_lower = y_upper + 10  # 10 for the 0 samples

            ax1.set_title("The silhouette plot for k={k}.".format(k=n_clusters))
            ax1.set_xlabel("The silhouette coefficient values")
            ax1.set_ylabel("Cluster label")

            # The vertical line for average silhouette score of all the values
            ax1.axvline(x=silhouette_avg, color="red", linestyle="--")

            ax1.set_yticks([])  # Clear the yaxis labels / ticks
            ax1.set_xticks([-0.1, 0, 0.2, 0.4, 0.6, 0.8, 1])
        #     plt.savefig('AB-H_silhouette_k{k}.svg'.format(k=n_clusters),transparent=True,format='svg')
            

            cur_save_file = '{0}silhouette_plot_k={2}.{1}'.format(rst_path,figformat,str(n_clusters))
            print('saving silhouette_plot_k={1} to {0}...'.format(cur_save_file,str(n_clusters)))
            # fig = plt.figure(figsize=figsize)
            # plt.plot(consensus_k_range,average_ari_list,'ro-')
            fig.savefig(cur_save_file,transparent=True,format=figformat,bbox_inches='tight')


        optimal_k_idx = np.argmax(silhouette_list)
        cur_save_file = '{0}silhouette_score.{1}'.format(rst_path,figformat)
        fig = plt.figure(figsize=figsize)
        plt.plot(consensus_k_range,silhouette_list,'ro-')
        fig.savefig(cur_save_file,transparent=True,format=figformat,bbox_inches='tight')




     



        
        resultsLWEA = np.transpose(np.array(CM_label_list))
        final_label_list = []
        for i in range(resultsLWEA.shape[1]):
                cur_k_labeling = resultsLWEA[:,i]
                final_label_list.append(cur_k_labeling)
                cur_k = i+2

                if np.sum(true_y)!=0:
                        print('k={0} ari: '.format(str(cur_k)),adjusted_mutual_info_score(cur_k_labeling,true_y))

            
                cur_k_labeling-=np.min(cur_k_labeling)
            
            
    #         开始画图
                cluster_cmp = sns.hls_palette(cur_k)
                labeling_plot_cmp = ['k']
                labeling_plot_cmp.extend(cluster_cmp)
            
                cur_save_file = '{0}TSNE_k{1}_{2}.{3}'.format(rst_path,str(cur_k),time_str,figformat)
                print('saving TSNE_k{0} to {1}...'.format(str(cur_k),cur_save_file))
                sns.set(style="white", font_scale=font_scale)
                embed_test = TSNE(metric='precomputed').fit_transform(1-CM_list_norm[i])
                            # plt.scatter(embed_test[:,0],embed_test[:,1],c=optimal_labeling,cmap=sns.hls_palette(3))
                fig=plt.figure(figsize=figsize)
                sns.scatterplot(x=embed_test[:,0],y=embed_test[:,1],hue=cur_k_labeling,palette=cluster_cmp,s=20)
                plt.legend(bbox_to_anchor=(1.05, 1), loc=2, borderaxespad=0.)
                fig.savefig(cur_save_file,transparent=True,format=figformat,bbox_inches='tight')
                print('done!')
                cur_save_file = '{0}embed_test_k{2}_{1}.pkl'.format(mid_path,time_str,str(cur_k))
                pickle.dump(embed_test,open(cur_save_file,'wb'))
            
            
            
                cur_save_file = '{0}labeling_image_k{1}_{2}.{3}'.format(rst_path,str(cur_k),time_str,figformat)
                print('saving labeling_image_k{0} to {1}...'.format(str(cur_k),cur_save_file))
                labeling = get_labeling(cur_k_labeling,cell_idx,cell_pos)
                labeling_plot = labeling.reshape((256,256))
                sns.set(font_scale=font_scale)
                plt.figure(figsize=figsize)
                ticks=np.arange(np.min(labeling_plot)+1,np.max(labeling_plot)+1)
                boundaries = np.arange(np.min(labeling_plot)+0.5,np.max(labeling_plot)+1.5)
                sns.heatmap(labeling_plot,cmap=labeling_plot_cmp,square=True,cbar_kws={"ticks":ticks, "boundaries":boundaries,'fraction':0.046,'pad':0.04})
                plt.xticks([])
                plt.yticks([])
                plt.tight_layout()
                plt.savefig(cur_save_file,transparent=True,format=figformat,bbox_inches='tight')
            
                print('done!')
        cur_save_file = '{0}final_label_list_{1}.pkl'.format(mid_path,time_str)
        print('saving final_label_list to {0}'.format(cur_save_file))
        pickle.dump(final_label_list,open(cur_save_file,"wb"))
        print('done!')
        stop_time = timeit.default_timer()
        print(stop_time-start_time)
        return optimal_k_idx,final_label_list        
#         return resultsLWEA,optimal_k_idx 
