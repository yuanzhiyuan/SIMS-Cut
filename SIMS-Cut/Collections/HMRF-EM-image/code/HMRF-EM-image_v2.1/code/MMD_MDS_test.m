cells = {};
load('each_cell_finger_print/10a_brdu/all_cells_info.mat');
cells = cat(2,cells,all_cells_info);

load('each_cell_finger_print/10a_nobrdu/all_cells_info.mat');
cells = cat(2,cells,all_cells_info);

load('each_cell_finger_print/0227a549_nobrdu/all_cells_info.mat');
cells = cat(2,cells,all_cells_info);

load('each_cell_finger_print/hela_brdu/all_cells_info.mat');
cells = cat(2,cells,all_cells_info);

num_cells = size(cells,2);

% D = [];
% %D只保存距离矩阵的上三角
% s = 100;
% %s是mmd中gaussian kernel的sigma
% for i=1:num_cells
%    for j=i+1:num_cells
%        D = [D,MMD(cells{i},cells{j},s)];
%        disp([i,j]);
%    end
% end

D = [];
%D只保存距离矩阵的上三角
s = 100;
%s是mmd中gaussian kernel的sigma
for i=1:num_cells
   for j=i+1:num_cells
%        D = [D,norm(mean(cells{i})-mean(cells{j}),inf)];
        D = [D,pdist([mean(cells{i});mean(cells{j})],'cosine')];
%        D = [D,MMD(cells{i},cells{j},s)];
       disp([i,j]);
   end
end
[Y,eigvals] = cmdscale(D);
 g = [ones(10,1);2*ones(21,1);3*ones(17,1);4*ones(24,1)];
 gscatter(Y(:,1),Y(:,2),g);