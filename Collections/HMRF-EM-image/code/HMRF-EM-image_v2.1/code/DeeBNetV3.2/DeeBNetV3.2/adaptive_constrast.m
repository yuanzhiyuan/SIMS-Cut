function[ada_edges] = adaptive_constrast(edges,window_sz,Width,Height)
%距离当前边终点小于等于window_sz的，就当作在window内，
%一个window内单独算一个beta
%输入edges应当是|I1-I2|^2

edges_len = size(edges,1);
ada_edges = zeros(edges_len,6);
rst_w = []
ada_edges(:,[1,2]) = edges(:,[1,2]);
for i=1:edges_len
    disp(['processing ',num2str(i),' row']);
    cur_node1_ind = edges(i,1);
    cur_node2_ind = edges(i,2);
    [cur_node1_x,cur_node1_y] = ind2ij(cur_node1_ind,Height,Width);
    [cur_node2_x,cur_node2_y] = ind2ij(cur_node2_ind,Height,Width);
    %用当前edge的两个短点算那个线段的中点
    cur_edge_middle = [(cur_node1_x+cur_node2_x)/2,(cur_node1_y+cur_node2_y)/2];
    
    %保存位于这个窗内的w
    inner_window_w = [];
%     inner_window_xy = [];
tic;
    parfor j=1:edges_len
        disp(['processing ',num2str(j),' row']);
        ser_node1_ind = edges(j,1);
        ser_node2_ind = edges(j,2);
        [ser_node1_x,ser_node1_y] = ind2ij(ser_node1_ind,Height,Width);
        [ser_node2_x,ser_node2_y] = ind2ij(ser_node2_ind,Height,Width);
        %用当前edge的两个短点算那个线段的中点
        ser_edge_middle = [(ser_node1_x+ser_node2_x)/2,(ser_node1_y+ser_node2_y)/2];
        if(pdist([cur_edge_middle;ser_edge_middle],'euclidean')<=window_sz)
            inner_window_w = [inner_window_w,edges(j,4)];
%             inner_window_xy = [inner_window_xy;ser_node1_x,ser_node1_y,ser_node2_x,ser_node2_y];
        end
        
    end
    toc;
    cur_beta = 1/(2*mean(inner_window_w));
    disp(['sigma:',num2str(sqrt(1/(2*cur_beta)))]);
%     edges(:,[4,5]) = exp(-beta*edges(:,[4,5]));
    ada_edges(i,[4,5]) = exp(-cur_beta*edges(i,[4,5]));
    
    
end

end



function[ind] = ij2ind(i,j,height,width)
ind = height*(j-1)+i;

end

function[i,j] = ind2ij(ind,height,width)
i = mod(ind-1,height)+1;
j = floor((ind-1)/height)+1;
end