sep_labeling = get_each_cell_pos(final_labeling);
num_cells = max(sep_labeling);
label_labeling = sep_labeling;
group = zeros(num_cells,1);
threshold = 2;
mean_br_list = [];
mean_i_list = [];
for i=1:num_cells
    cur_mean_br = mean(br_sample(sep_labeling==i));
%     cur_mean_i = mean(i_sample(sep_labeling==i));
    mean_br_list = [mean_br_list,cur_mean_br];
%     mean_i_list = [mean_i_list,cur_mean_i];
end
group(mean_br_list>=threshold) = 1;
group(mean_i_list>=threshold) = 2;
group = group+1;
for i=1:num_cells
   label_labeling(sep_labeling==i) = group(i); 
end
imshow(reshape(label_labeling,256,256)',[]);
