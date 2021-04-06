function[filtered_img,num_valid_cell,filtered_labeling] = filter_cell_ext(cur_labeling,threshold,sz)

img = reshape(cur_labeling,sz,sz);
[separated_img]=Separate_cell(img);


num_cells = max(separated_img(:));
disp(['before filter: ',num2str(num_cells)]);
to_discard = [];
num_valid_cell = num_cells;
for i=1:num_cells
   idx_vector = find(separated_img==i);
   if(length(idx_vector)<=threshold)
      to_discard = [to_discard;idx_vector]; 
        num_valid_cell = num_valid_cell-1;
   end
   

end
disp(['after filter: ',num2str(num_valid_cell)]);
filtered_img = separated_img(:);
filtered_labeling = ones(size(cur_labeling,1),1);
filtered_labeling(filtered_img~=0)=2;
filtered_labeling(to_discard)=1;
% % filtered_img(ismember(filtered_img,to_discard)) = 0;
% % filtered_img = reshape(filtered_img,256,256)';
filtered_img(to_discard)=0;
filtered_img = reshape(filtered_img,sz,sz)';
