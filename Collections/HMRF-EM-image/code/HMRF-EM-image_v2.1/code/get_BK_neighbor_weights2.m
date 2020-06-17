function[Weights] = get_BK_neighbor_weights2(width,height,sigma,lambda,x)
%x是65536*20
Weights = sparse(width*height,width*height);
num_edges = 0;
for ind=1:width*height
    disp(num2str(ind));
    [row,col] = ind2ij(ind,height,width);
    up_pos = [row-1,col];
    down_pos = [row+1,col];
    left_pos = [row,col-1];
    right_pos = [row,col+1];
    cur_x = x(ind,:);
    
    if((up_pos(1)>=1))
       up_ind = ij2ind(up_pos(1),up_pos(2),height,width);
       up_x = x(up_ind,:);
       weight = exp(-(cur_x(1)-up_x(1))^2/(2*sigma^2))*1/(pdist([cur_x;up_x],'euclidean'));
       Weights(ind,up_ind) = weight; 
       num_edges = num_edges+1;
    end
    if(down_pos(1)<=height)
        down_ind = ij2ind(down_pos(1),down_pos(2),height,width);
        down_x = x(down_ind,:);
        weight = exp(-(cur_x(1)-down_x(1))^2/(2*sigma^2))*1/(pdist([cur_x;down_x],'euclidean'));
         Weights(ind,down_ind) = weight; 
         num_edges = num_edges+1;
    end
    if(left_pos(2)>=1)
        left_ind = ij2ind(left_pos(1),left_pos(2),height,width);
        left_x = x(left_ind,:);
        weight = exp(-(cur_x(1)-left_x(1))^2/(2*sigma^2))*1/(pdist([cur_x;left_x],'euclidean'));
        Weights(ind,left_ind) = weight; 
        num_edges = num_edges+1;
    end
    if(right_pos(2)<=width)
        right_ind = ij2ind(right_pos(1),right_pos(2),height,width);
        right_x = x(right_ind,:);
        weight = exp(-(cur_x(1)-right_x(1))^2/(2*sigma^2))*1/(pdist([cur_x;right_x],'euclidean'));
       Weights(ind,right_ind) = weight;  
       num_edges = num_edges+1;
    end
end
Weights = Weights*lambda;

% for i=1:width*height
%    for j=1:width*height
%        if(Weights(i,j)~=Weights(j,i))
%            disp('发现了不想等');
%        end
%    end
% end
a = issymmetric(Weights);
disp(num2str(num_edges));

end



function[ind] = ij2ind(i,j,height,width)
ind = height*(j-1)+i;

end

function[i,j] = ind2ij(ind,height,width)
i = mod(ind-1,height)+1;
j = floor((ind-1)/height)+1;
end

