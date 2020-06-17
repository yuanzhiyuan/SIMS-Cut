data_mat = [];
label_mat = [];
load('each_cell_allmatter-549-brdu-1.mat');

data_mat = [data_mat;cell_matter_mat];
label_mat = [label_mat;ones(size(cell_matter_mat,1),1)];
load('each_cell_allmatter-549-brdu-4.mat');
data_mat = [data_mat;cell_matter_mat];
label_mat = [label_mat;2*ones(size(cell_matter_mat,1),1)];
load('each_cell_allmatter-293-nobrdu.mat');
data_mat = [data_mat;cell_matter_mat];
label_mat = [label_mat;3*ones(size(cell_matter_mat,1),1)];
load('each_cell_allmatter-549-nobrdu.mat');
data_mat = [data_mat;cell_matter_mat];
label_mat = [label_mat;4*ones(size(cell_matter_mat,1),1)];