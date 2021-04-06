from utils import *
import multiprocessing as mp
# /home/yzy/bioSIMS/data/process/20190105_skeletalmuscle1_filter/preprocess
def run_tsne_img(data_name,num_features,path_pref='/home/yzy/bioSIMS/data/process/',bg_threshold=10):

    test_sample_path = '{0}{1}/preprocess/'.format(path_pref,data_name)
    # test_sample_path = '/home/yzy/bioSIMS/data/process/20190103_lung1_filter/preprocess/'
    save_path = '{0}{1}/micro/'.format(path_pref,data_name)
    time_str = time.strftime("%Y%m%d%H%M%S")

    print('mkdir {0}...'.format(save_path))
    if not os.path.exists(save_path):
        os.makedirs(save_path)
        print('done!')
    else:
        print('{0} already exists!'.format(save_path))

    test_sample_file = 'test_samples_{0}.mat'.format(str(num_features))
    # test_sample_file_all = 'test_samples_223.mat'
    test_sample_file_20 = 'test_samples_20.mat'
    test_sample_file = test_sample_path+test_sample_file
    test_sample_file_20 = test_sample_path+test_sample_file_20
    # test_sample_file_all = test_sample_path+test_sample_file_all

    matters_candidate_file = 'matters_candidate.pkl'
    matters_candidate_file = test_sample_path+matters_candidate_file
    test_samples = sio.loadmat(test_sample_file)
    test_samples = test_samples['test_samples']
    test_samples_20 = sio.loadmat(test_sample_file_20)
    test_samples_20 = test_samples_20['test_samples']
    # test_samples_all = sio.loadmat(test_sample_file_all)
    # test_samples_all = test_samples_all['test_samples']
    matters_list = pickle.load(open(matters_candidate_file,'rb'))


    pseudo_count = 1
    # bg_threshold = 5
    fg_threshold = 50
    data_rgb = np.zeros(shape=(65536,3))
    # data_all = batch_dict[1][np.argsort(pos_dict[1]),:]
    data_all = test_samples
    data_all_norm = (data_all+pseudo_count)/(np.percentile(data_all,50,axis=1,keepdims=True)+pseudo_count)
    data_all_norm = MinMaxScaler().fit_transform(data_all_norm)
    # data_all_norm = data_all
    # data_all_norm = StandardScaler().fit_transform(data_all)

    # lung3
    # data_134 = data_all[:,70]
    # fiber
    # data_134 = data_all[:,91]
    data_134 = test_samples_20[:,0]
    # data_diban = test_samples_all[:,11]

    fg_condition = (data_134>=bg_threshold)
    # fg_condition = (data_diban<=fg_threshold)
    # fg_idx = np.where(data_134>=bg_threshold)
    # fg_condition = (fg_umap[:,0]>=20)
    fg_idx = np.where(fg_condition)

    # fg_umap = umap.UMAP(n_components=3,n_neighbors=50).fit_transform(data_all_norm[fg_condition,:])
    print('running tsne for {0} threshold={1}'.format(data_name,str(bg_threshold)))
    fg_umap = TSNE(n_components=3).fit_transform(data_all_norm[fg_condition,:])
    print('done!')
    # fg_umap = fitsne.FItSNE(data_all_norm[data_134>=bg_threshold,:],no_dims=3)
    # fg_umap=fast_tsne(data_all_norm[data_134>=bg_threshold,:], perplexity=50, seed=42,map_dims=3)
    # fg_umap[np.isnan(fg_umap)] = 0
    fg_umap_norm = MinMaxScaler().fit_transform(fg_umap)
    fg_umap_norm[:,0] = MinMaxScaler(feature_range=(0, 100)).fit_transform(fg_umap_norm[:,0][:,None])[:,0]
    fg_umap_norm[:,1] = MinMaxScaler(feature_range=(-128, 127)).fit_transform(fg_umap_norm[:,1][:,None])[:,0]
    fg_umap_norm[:,2] = MinMaxScaler(feature_range=(-127, 128)).fit_transform(fg_umap_norm[:,2][:,None])[:,0]


    data_rgb[fg_idx] = fg_umap_norm

    data_rgb_img = data_rgb.reshape(256,256,3).astype('float64')
    data_rgb_img = lab2rgb(data_rgb_img)
    sns.set(style='white')
    sns.set_color_codes('deep')
    # sns.set
    cur_save_file = '{0}tsnemap_img_thres134_{1}_{2}.png'.format(save_path,str(bg_threshold),time_str)
    plt.figure(figsize=(10,10))
    plt.imshow(data_rgb_img,cmap='BrBG')
    plt.xticks([])
    plt.yticks([])
    plt.savefig(cur_save_file,transparent=True,format='png')

    cur_save_file = '{0}tsnemap_data_thres134_{1}_{2}.pickle'.format(save_path,str(bg_threshold),time_str)
    pickle.dump(data_rgb_img,open(cur_save_file,'wb'))

    # plt.colorbar()
    # plt.show()


def mp_run_tsne_img(i):
    data_name_list=['20190103_lung1_filter','20190103_lung2_filter','20190103_lung3_filter','20190103_lung4_filter','20190103_intestine1_filter','20190103_intestine2_filter']
    num_features_list = [168,165,164,159,202,181]
    bg_threshold_list = [0,5,10]
    for bg_threshold in bg_threshold_list:
        data_name=data_name_list[i]
        num_features=num_features_list[i]
        
        run_tsne_img(data_name,num_features,path_pref='/home/yzy/bioSIMS/data/process/',bg_threshold=bg_threshold)
plt.switch_backend('agg')

pool = mp.Pool()
pool.map(mp_run_tsne_img,range(6))
#data_name_list=['20190103_lung1_filter','20190103_lung2_filter','20190103_lung3_filter','20190103_lung4_filter','20190103_intestine1_filter','20190103_intestine2_filter']

#num_features_list = [168,165,164,159,202,181]
#bg_threshold_list = [0,5,10]

#for i in range(len(data_name_list)):
 #   data_name = data_name_list[i]
 #  num_features = num_features_list[i]
  #  for bg_threshold in bg_threshold_list:
   #     run_tsne_img(data_name,num_features,path_pref='/home/yzy/bioSIMS/data/process/',bg_threshold=bg_threshold)




