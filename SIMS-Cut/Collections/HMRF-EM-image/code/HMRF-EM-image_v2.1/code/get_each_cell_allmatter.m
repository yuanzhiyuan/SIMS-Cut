cm = mat4;


% MRF_MAP_RBM_BK;
[separated_img]=Separate_cell(reshape(Labeling,256,256));
C549_matters = [];
C293_matters = [];

%65536*d
C549_samples = [];
C293_samples = [];
num_cells = max(separated_img(:));
cell_matter_mat = [];

for i=1:num_cells
   idx_vector = find(separated_img==i);
   cur_cell_info = cm(idx_vector,:);
   cur_cell_mean = mean(cur_cell_info);
   cell_matter_mat = [cell_matter_mat;cur_cell_mean];
%    b = bar(cur_cell_mean,0.1);
%    saveas(b,['A549-1-1_cell',num2str(i),'_finger'],'fig');
end