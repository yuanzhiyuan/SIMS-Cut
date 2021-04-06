function[Weights] = get_BK_neighbor_weights(width,height,weight)
Weights = sparse(width*height,width*height);
for ind=1:width*height
    [row,col] = ind2ij(ind,height,width);
    up_pos = [row-1,col];
    down_pos = [row+1,col];
    left_pos = [row,col-1];
    right_pos = [row,col+1];
    if((up_pos(1)>=1))
       Weights(ind,ij2ind(up_pos(1),up_pos(2),height,width)) = weight; 
    end
    if(down_pos(1)<=height)
         Weights(ind,ij2ind(down_pos(1),down_pos(2),height,width)) = weight; 
    end
    if(left_pos(2)>=1)
        Weights(ind,ij2ind(left_pos(1),left_pos(2),height,width)) = weight; 
    end
    if(right_pos(2)<=width)
       Weights(ind,ij2ind(right_pos(1),right_pos(2),height,width)) = weight;  
    end
end

% for i=1:width*height
%    for j=1:width*height
%        if(Weights(i,j)~=Weights(j,i))
%            disp('发现了不想等');
%        end
%    end
% end
a = issymmetric(Weights);

end



function[ind] = ij2ind(i,j,height,width)
ind = height*(j-1)+i;

end

function[i,j] = ind2ij(ind,height,width)
i = mod(ind-1,height)+1;
j = floor((ind-1)/height)+1;
end

