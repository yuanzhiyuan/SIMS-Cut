function[ada_edges] = adaptive_constrast2_ext(edges,window_sz,Width,Height)
%距离当前边中点小于等于window_sz的，就当作在window内，
%一个window内单独算一个beta
%输入edges应当是|I1-I2|^2

% 先把edges转化成一个扩展的矩阵，然后基于这个矩阵做中职旅博
% extended_mat = zeros(Height+Height-1,Width+Width-1);
% edges_sz = size(edges,1);
% for i=1:edges_sz
%    cur_node1_ind = edges(i,1);
%     cur_node2_ind = edges(i,2);
%     [cur_node1_x,cur_node1_y] = ind2ij(cur_node1_ind,Height,Width);
%     [cur_node2_x,cur_node2_y] = ind2ij(cur_node2_ind,Height,Width);
%     edge_mid_x = cur_node1_x + cur_node2_x-1;
%     edge_mid_y = cur_node1_y + cur_node2_y-1;
%     extended_mat(edge_mid_x,edge_mid_y) = edges(i,4);
extended_mat = edge2mat(edges,Width,Height);
% 对扩展图进行均值旅博
h = fspecial('average',[window_sz,window_sz]);
B = filter2(h,extended_mat);
% B = medfilt2(extended_mat,[3,3],'symmetric');
% 滤波后每个点是周围点的mean，但是周围点有大约一半的是edge，剩下一半是node或者空
B = 2*B;
beta = 1./(4*B);
%     disp(['sigma:',num2str(sqrt(1/(2*cur_beta)))]);
%     edges(:,[4,5]) = exp(-beta*edges(:,[4,5]));
ada_mat = exp(-beta.*extended_mat);
% ada_edges(i,[4,5]) = exp(-cur_beta*edges(i,[4,5]));
ada_edges = mat2edge(ada_mat,Width,Height);


    
    
end

function[extended_mat] = edge2mat(edges,Width,Height)
extended_mat = zeros(Height+Height-1,Width+Width-1);
edges_sz = size(edges,1);
for i=1:edges_sz
   cur_node1_ind = edges(i,1);
    cur_node2_ind = edges(i,2);
    [cur_node1_x,cur_node1_y] = ind2ij(cur_node1_ind,Height,Width);
    [cur_node2_x,cur_node2_y] = ind2ij(cur_node2_ind,Height,Width);
    edge_mid_x = cur_node1_x + cur_node2_x-1;
    edge_mid_y = cur_node1_y + cur_node2_y-1;
%     if(edge_mid_y>Width+Width-1)
%        1+1; 
%     end
    disp([num2str(edge_mid_x),',',num2str(edge_mid_y)]);
    extended_mat(edge_mid_x,edge_mid_y) = edges(i,4);
    
    
end

end

function[edges] = mat2edge(extended_mat,Width,Height)
edges = zeros(Width*(Height-1)*2,6);
k = 1;
for i=1:size(extended_mat,1)
   disp(num2str(i)); 
    for j=1:size(extended_mat,2)
        if(mod(i+j,2)==1)
           %奇数说明当前点是edge
           %偶数说明当前点是node或者空
           if(mod(i,2)==1)
%               如果当前行是奇数行，那么这个edge是横向
%               否则是纵向
                node1_i = (i+1)/2;
                node1_j = (j+1+1)/2;
                node2_i = (i+1)/2;
                node2_j = (j-1+1)/2;
                
           else
               node1_i = (i+1+1)/2;
               node1_j = (j+1)/2;
               node2_i = (i-1+1)/2;
               node2_j = (j+1)/2;
           end
        else
            continue;
        end
%         if(floor(node1_i)~=node1_i)
%            1+1; 
%         end
%         if(floor(node1_j)~=node1_j)
%            1+1; 
%         end
%         if(floor(node2_i)~=node2_i)
%            1+1; 
%         end
%         if(floor(node2_j)~=node2_j)
%            1+1; 
%         end
        
        node1_ind = ij2ind(node1_i,node1_j,Height,Width);
        node2_ind = ij2ind(node2_i,node2_j,Height,Width);
        edges(k,:) = [node1_ind,node2_ind,0,extended_mat(i,j),extended_mat(i,j),0];
       k = k+1; 
    end
    
end
end

function[ind] = ij2ind(i,j,height,width)
ind = height*(j-1)+i;

end

function[i,j] = ind2ij(ind,height,width)
i = mod(ind-1,height)+1;
j = floor((ind-1)/height)+1;
end
