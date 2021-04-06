import os
from scipy.ndimage import gaussian_filter
#import magic
from pathlib import Path
import pickle
import pandas as pd
import math
#import pyfpgrowth
import operator
import numpy as np
from scipy.io import *
from scipy.stats import *

# FILE_PATH = '../Yuanzhiyuan/sample2/'
# for file in os.listdir(FILE_PATH):
# 	idx_former = file.find('-',15)
# 	idx_latter = file.find('u',15)
# 	# print file[idx_former+2:idx_latter-1]
# 	# print file
# 	print FILE_PATH+file
# 	print FILE_PATH+file[idx_former+2:idx_latter-1]
# 	os.rename(FILE_PATH+file,FILE_PATH+file[idx_former+2:idx_latter-1])
# 	# print file[idx+1:]
WORK_SPACE = '/Users/yzy/Desktop/study/SKMS/PROCESS1127/'
DATA_PATH = WORK_SPACE+'DATA/YZY-2017-11-27/'
DATA_PEAK_FILE_PATH = DATA_PATH+'peak_files/'
ALL_PEAK_LIST = WORK_SPACE+'MID/ALL_PEAK_LIST_1130.pkl'
CellMatterMatrix = WORK_SPACE+'MID/CellMatterMatrix_withoutback_log.pkl'
CELL_LIST = WORK_SPACE+'MID/CELL_LIST_withoutback_log.pkl'
CELL_PEAK_DICT= WORK_SPACE+'MID/CELL_PEAK_DICT.pkl'

def matter_filter(threshold,path):
	#find matter whose heatmap has more none-zero pixels.
	matter_pixel_dict = get_matter_pixel_dict(path)
	matter_nonezeropixels_dict = {}
	for matter,pixel in matter_pixel_dict.iteritems():
		matter_nonezeropixels_dict[matter] = sum(map(lambda x:x>=1,pixel))
	sorted_dict = sorted(matter_nonezeropixels_dict.items(),key=operator.itemgetter(1))
	return sorted_dict
def get_matter_pixel_dict(path):
	matter_pixel_dict = {}
	for filename in os.listdir(path):
		if 'total' in filename or 'sum' in filename:
			continue
		# idx_former = filename.find('-',25)
		# idx_latter = filename.find('u',15)
		matter = filename[:-4]
		
		pixel = get_pixel_list_from_file(path+filename)
		matter_pixel_dict[matter] = pixel
	return matter_pixel_dict

def get_pixel_list_from_file(filename):
	pixel_list = []
	f = open(filename,'r')
	lines = f.readlines()[9:]
	for line in lines:
		intensity  = float(line.split(' ')[2])
		pixel_list.append(intensity)
	f.close()
	return pixel_list

def renamer(path):
	# print 'bb'
	for filename in os.listdir(path):
		if 'total' in filename or 'sum' in filename or 'tif' in filename:
			continue
		# print 'aa'
		if len(filename)<=10:
			continue
		idx_former = filename.rfind('-')
		idx_latter = filename.rfind('txt')
		# print idx_former,idx_latter
		print(filename[idx_former+2:idx_latter-3])

		print(filename)
		matter = filename[idx_former+2:idx_latter-3]
		originam_filename = path + filename
		changed_filename = path+matter+'.txt'
		print('change {o} to {c}'.format(o=filename,c=matter))
		os.rename(originam_filename,changed_filename)
		
def find_cooccorance_matters(matter_li):
	DEs = [1,5,6,7,8,9,10]
	DSs = range(5,16)
	DE_pre = '/Users/yzy/Desktop/study/SKMS/PROCESS1127/DATA/YZY-2017-11-27/DE-1/DE-1-{num}/'
	DS_pre = '/Users/yzy/Desktop/study/SKMS/PROCESS1127/DATA/YZY-2017-11-27/DS-1/DS-1-{num}/'

	filtered_matters = []
	for matter in matter_li:
		DE_flag = True
		for de in DEs:
			full_filename = DE_pre.format(num=de)+str(matter)+'.txt'
			if not os.path.isfile(full_filename):
				DE_flag = False
		DS_flag = True
		for ds in DSs:
			full_filename = DS_pre.format(num = ds) + str(matter)+'.txt'
			if not os.path.isfile(full_filename):
				DS_flag = False

		if DE_flag and DS_flag:
			filtered_matters.append(matter)
	return filtered_matters

def get_matter_list_from_path(path):
	matter_list = []
	for file in os.listdir(path):
		if 'total' in file or 'sum' in file or 'tif' in file:
			continue
		matter_list.append(file[:-4])
	matter_list = map(float,matter_list)
	return sorted(matter_list)
		
def find_cooccorance_matters1(path1,path2):
	common_matter_list = []
	# for path in path_list:
		# all_matter_list.extend(get_matter_list_from_path(path))
	# return sorted(list(set(all_matter_list)))
	path1_matters = get_matter_list_from_path(path1)
	path2_matters = get_matter_list_from_path(path2)
	for m in path1_matters:
		if m in path2_matters:
			common_matter_list.append(m)
	return common_matter_list

#def get_samples(rawdata_path,matters_candidate,tosave_path,ifmagic=False):
def get_samples(rawdata_path,matters_candidate,tosave_path,ptype=None,sz=256):
	rst_sample = []
	for matter in matters_candidate:
		matter = "{0:.2f}".format(matter)
		
		cur_file = rawdata_path+matter+'.txt'
		cur_matter_pd = pd.read_csv(open(cur_file,'r'), sep=' ',skiprows=9, header=None,names=['row','col','val'])
		
		cur_matter_data = np.array(cur_matter_pd['val'])
		rst_sample.append(cur_matter_data)
	rst_sample = np.array(rst_sample)
	rst_sample = np.transpose(rst_sample)
	if ptype=='magic':
		rst_sample = magic.MAGIC().fit_transform(rst_sample)
	if ptype=='gaussian':
			
		for i in range(rst_sample.shape[1]):
			cur_col = rst_sample[:,i]
			cur_img = cur_col.reshape(sz,sz)
			cur_img_blur = gaussian_filter(cur_img,1)
			rst_sample[:,i] = cur_img_blur.reshape((sz*sz,))
	savemat(file_name=tosave_path+'test_samples_{num_features}.mat'.format(num_features=len(matters_candidate)),mdict={'test_samples':rst_sample})
	return rst_sample
	# print(rst_sample.shape)

def listmatter_top_k_corr(test_samples,matters_candidate,A_matter,top_k):
	cor_array = np.zeros(shape=(len(matters_candidate)))
	A_matter = float(A_matter)
	top_k = int(top_k)
	data_134 = test_samples[:,matters_candidate.index(A_matter)]
	count = 0
	for i in range(len(matters_candidate)):
		count +=1
		[a,b] = pearsonr(data_134,test_samples[:,i])
		cor_array[i] = float(a)
	sorted_idx = np.flip(np.argsort(cor_array),axis=0)
	sorted_cors = np.flip(np.sort(cor_array),axis=0)
	matters_candidate_np = np.array(matters_candidate)
	rst_matter = matters_candidate_np[sorted_idx[:top_k]]
	rst_corr = sorted_cors[:top_k]
	return rst_matter,rst_corr
# path = '/Users/yzy/Desktop/study/SKMS/PROCESS1127/DATA/YZY-2017-11-27/DS-2/DS-2-{n}/'
# files = [1]
# for f in files:
# 	renamer(path.format(n=str(f)))
# d = matter_filter(0.1,path)
# to_print = []
# for i in d:
# 	if i[1]>=130:
# 		to_print.append(i[0])
# print ','.join(to_print)
# matter_li = [126.95,94.05,46.99,77.03,57.07,112.09,63.93,74.06,136.07,70.98,93.05,80.05,107.04,83.05,43.97,89.97,86.99,70.03,56.02,61.01,51.02,67.05,120.08,98.07,103.99,91.05,39.02,81.04,44.97,100.08,84.04,1.01,130.06,69.07,44.01,27.97,27.02,69.04,56.05,82.05,28.98,124.94,28.02,108.94,71.07,26.98,84.08,55.06,55.02,47.94,58.06,11.01,18.04,59.05,87.98,72.08,53.04,30.04,43.05,43.03,68.05,54.04,41.04,60.06,22.99,44.05,73.06,15.02,62.98,71.98,42.04,70.07,82.94,80.95,40.96,38.96,45.98,164.93,142.95,66.96,110.08,87.09,97.07,29.04]
# print find_cooccorance_matters(matter_li)
# renamer('/Users/yzy/Desktop/study/SKMS/PROCESS0117/no-brdu-293/')
# file_temp = '/Users/yzy/Desktop/study/SKMS/PROCESS1228/{c}/'
# class_li = ['ES+BrdU','ES+noBrdU']
# m=get_matter_list_from_path('/Users/yzy/Desktop/study/SKMS/PROCESS1228/{class}/')
# print len(m)
# print m
# a = find_cooccorance_matters1(file_temp.format(c=class_li[0]),file_temp.format(c=class_li[1]))
# print a

def listmatter(path):
	li = []
	for filename in os.listdir(path):
		if 'DS_S' in filename:
			continue
		if 'txt' not in filename:
			continue
		if 'total' in filename or 'sum' in filename or 'tif' in filename:
			continue
		if 'I' in filename or 'Br' in filename or len(filename)<=4:
			continue

		# print(filename)
		os.rename(path+filename,path+filename.strip())
		matter = filename[0:-4]
		matter = matter.strip()

		matter = float(matter)
		li.append(matter)
	li = sorted(li)
	return li

# listmatter('/Users/yzy/Desktop/study/SKMS/20181023/HELA-BR-A549-I-SK-NO/')
# listmatter('/Users/yzy/Desktop/study/SKMS/20181208/intestine-1/')
# get_samples('/Users/yzy/Desktop/study/SKMS/20181109/liver_highres_all/',[float(190.71),float(192.67)],'/Users/yzy/Desktop/study/SKMS/20181109/')
# renamer('/Users/yzy/Desktop/study/SKMS/20181208/intestine-1/')
#path = '/Users/yzy/Desktop/study/SKMS/20181109/liver_highres_all/'
#tosave_path = '/Users/yzy/Desktop/study/SKMS/20181109/'
#A_matter = 134.47
#top_k = 30
#matters_candidate = listmatter(path)
#test_samples = get_samples(path,matters_candidate,tosave_path)
#matters_20,corr_20 = listmatter_top_k_corr(test_samples,matters_candidate,A_matter,top_k)
# print(matters_20)
# print(corr_20)
# print(len(matters_20))
#test_samples_30 = get_samples(path,matters_20,tosave_path)


