function[edges] = get_BK_pairwise_cosine(Width,Height,weight,x,sigma)
%edge：numEdge*6的矩阵
%注意，这里e00和e11（也就是label相同的情况），权重是0
%x是输入数据，65536*355
edges = [];
k=0;
for i=1:Height
   for j=1:Width
       k = k+1;
      if(i+1<=Height)
          
         cur_ind = ij2ind(i,j,Height,Width);
         nei_ind = ij2ind(i+1,j,Height,Width);
         cur_x = x(cur_ind,:);
         nei_x = x(nei_ind,:);
         %pdist算出来的是1-cosine_similarity
%          w = exp(-(cur_x(1)-nei_x(1))^2/(2*sigma^2))*1/(pdist([cur_x;nei_x],'euclidean'));
% w = exp(-(cur_x(1)-nei_x(1))^2/(2*sigma^2));
         w = 1-pdist([x(cur_ind,:);x(nei_ind,:)],'cosine');
% w = pdist([])
         w = w*weight;
%          if(cur_x(1)>=nei_x(1))
%              edges = [edges;nei_ind,cur_ind,0,1,w,0]; 
%          else
%              edges = [edges;nei_ind,cur_ind,0,w,1,0]; 
%          end
         edges = [edges;nei_ind,cur_ind,0,w,w,0]; 
         
%          if(j+1<=Width)
%              nei_ind = ij2ind(i+1,j+1,Height,Width);
%              nei_x = x(nei_ind,:);
%              w = exp(-(cur_x(1)-nei_x(1))^2/(2*sigma^2));
%              w = w*weight/sqrt(2);
%              edges = [edges;nei_ind,cur_ind,0,w,w,0]; 
%          end
         
      end
      if(j+1<=Width)
          cur_ind = ij2ind(i,j,Height,Width);
          nei_ind = ij2ind(i,j+1,Height,Width);
           cur_x = x(cur_ind,:);
         nei_x = x(nei_ind,:);
%           w = exp(-(cur_x(1)-nei_x(1))^2/(2*sigma^2))*1/(pdist([cur_x;nei_x],'euclidean'));
% w = exp(-(cur_x(1)-nei_x(1))^2/(2*sigma^2));
          w = 1-pdist([x(cur_ind,:);x(nei_ind,:)],'cosine');
          w = w*weight;
%           if(cur_x(1)>=nei_x(1))
%              edges = [edges;nei_ind,cur_ind,0,1,w,0]; 
%          else
%              edges = [edges;nei_ind,cur_ind,0,w,1,0]; 
%          end
          edges = [edges;nei_ind,cur_ind,0,w,w,0]; 
          
%           if(i-1>=1)
%              nei_ind = ij2ind(i-1,j+1,Height,Width);
%              nei_x = x(nei_ind,:);
%              w = exp(-(cur_x(1)-nei_x(1))^2/(2*sigma^2));
%              w = w*weight/sqrt(2);
%              edges = [edges;nei_ind,cur_ind,0,w,w,0]; 
%          end
          
      end
      disp(num2str(k));
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