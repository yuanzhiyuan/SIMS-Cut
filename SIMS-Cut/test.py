from tools.preprocess import *
import pickle
import os
import timeit
#data_name = '20190103_lung1_filter'
#A_matter = 134.10
#data_name = '20190103_lung2_filter'
#A_matter = 134.09
#data_name = '20190103_lung3_filter'
#A_matter = 134.10
#data_name = '20190103_lung4_filter'
#A_matter = 134.10
#data_name = '20190103_intestine1_filter'
#A_matter = 134.37
#data_name = '20190103_intestine2_filter'
#A_matter = 134.11
#data_name = '20190105_skeletalmuscle1_filter'
#Amatter = 181.16
#data_name = '20190105_skeletalmuscle2_filter'
#A_matter = 134.18
#A_matter = 181.16
#data_name='20190115_liverfiber2_filter'
#A_matter = 134.00
#data_name='20190117_liverfiber2_pos'
#A_matter=125.14
#data_name='20190303_liverfiber_fix'
#A_matter=134.38
#data_name='20190303_liverfiber_nofix'
#A_matter=134.37
#data_name='20190308_liver_P1LF2_2'
#A_matter=134.45


#data_name='20190303_liverfiber_fix_magic'
#A_matter=134.38


#data_name='20190115_liverfiber1_filter_magic'
#A_matter=134.00



#data_name='SPE1'
#data_name='SPE1_magic'
#data_name='SPE2'
#data_name='SPE2_magic'
#A_matter=134.02
#data_name='intestine'
#A_matter=135.43

#data_name='intestine-1'
#A_matter=133.96

#data_name='liver_hoechst_blood'
#A_matter=134.46
data_name='lung-type2'
A_matter=134.44
cut_magic=False
ifrenamer = 0
rawdata_path = '/home/yzy/bioSIMS/data/raw/'+data_name+'/'
workspace = '/home/yzy/bioSIMS/data/process/'
workspace += data_name
workspace += '/'
if not os.path.exists(workspace):
	os.mkdir(workspace)
# tosave_path = '/Users/yzy/Desktop/study/SKMS/20181109/'
preprocess_path = workspace+'preprocess/'
if not os.path.exists(preprocess_path):
	os.mkdir(preprocess_path)
top_k = 20


print('renaming...')
start = timeit.default_timer()
if ifrenamer:
	renamer(rawdata_path)
stop = timeit.default_timer()
print('done! Time cost: ',stop-start)

print('get matters candidate...')
start = timeit.default_timer()
matters_candidate = listmatter(rawdata_path)
pickle.dump(matters_candidate,open(preprocess_path+'matters_candidate.pkl','wb'))
stop = timeit.default_timer()
print('done! Time cost: ',stop-start)

print('extract data samples...')
start = timeit.default_timer()
test_samples = get_samples(rawdata_path,matters_candidate,preprocess_path)
stop = timeit.default_timer()
print('done! Time cost: ',stop-start)

print('get top {0} correlation matters with {1}...'.format(top_k,A_matter))
start = timeit.default_timer()
matters_20,corr_20 = listmatter_top_k_corr(test_samples,matters_candidate,A_matter,top_k)
stop = timeit.default_timer()
print('done! Time cost: ',stop-start)

# print(matters_20)
# print(corr_20)
# print(len(matters_20))
print('extract top 20 data samples...')
start = timeit.default_timer()
test_samples_30 = get_samples(rawdata_path,matters_20,preprocess_path,ifmagic=cut_magic)
stop = timeit.default_timer()
print('done! Time cost: ',stop-start)
