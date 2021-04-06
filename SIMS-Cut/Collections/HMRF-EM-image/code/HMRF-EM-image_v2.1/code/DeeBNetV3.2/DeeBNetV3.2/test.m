[filtered_img,num_valid_cell,filtered_labeling] = filter_cell(leaf_labeling,0);
filtered_labeling = filtered_img(:);
num_cells = max(filtered_labeling);
area_list_tmp = [];
disp('aaa');
for i=1:num_cells
    area_list_tmp = [area_list_tmp,sum(filtered_labeling==i)]
end