function[edges] = get_BK_pairwise_grad(Width,Height,weight,x,sigma)
%edge：numEdge*6的矩阵
%注意，这里e00和e11（也就是label相同的情况），权重是0
%x是输入数据，65536*355
% [Gmag, Gdir] = imgradient(I,'prewitt');
img = reshape(x(:,1),256,256);
[Gmag, Gdir] = imgradient(img,'prewitt');
edges = [];
grad = Gmag(:);
grad = grad/(max(grad)+1);
k=0;
for i=1:Height
   for j=1:Width
       k = k+1;
      if(i+1<=Height)
          
         cur_ind = ij2ind(i,j,Height,Width);
         nei_ind = ij2ind(i+1,j,Height,Width);
         cur_x = x(cur_ind,:);
         nei_x = x(nei_ind,:);
%          w = -log10(abs(1-abs(grad(cur_ind)-grad(nei_ind))/(2*180)));
% w = 1-min(1,-min(log(1-abs(grad(cur_ind))),log(1-abs(grad(nei_ind)))));
w = -max(log(abs(grad(cur_ind))),log(abs(grad(nei_ind))));
% w = -min(log(1-abs(grad(cur_ind))),log(1-abs(grad(nei_ind))));
         %pdist算出来的是1-cosine_similarity
%          w = exp(-(cur_x(1)-nei_x(1))^2/(2*sigma^2))*1/(pdist([cur_x;nei_x],'euclidean'));
% w = exp(-(cur_x(1)-nei_x(1))^2/(2*sigma^2));
%          w = 1-pdist([x(cur_ind,:);x(nei_ind,:)],'cosine');
         w = w*weight;
%          if(cur_x(1)>=nei_x(1))
%              edges = [edges;nei_ind,cur_ind,0,1,w,0]; 
%          else
%              edges = [edges;nei_ind,cur_ind,0,w,1,0]; 
%          end
         edges = [edges;nei_ind,cur_ind,0,w,w,0]; 
         
         
      end
      if(j+1<=Width)
          cur_ind = ij2ind(i,j,Height,Width);
          nei_ind = ij2ind(i,j+1,Height,Width);
           cur_x = x(cur_ind,:);
         nei_x = x(nei_ind,:);
%           w = exp(-(cur_x(1)-nei_x(1))^2/(2*sigma^2))*1/(pdist([cur_x;nei_x],'euclidean'));
% w = -log10(abs(1-abs(grad(cur_ind)-grad(nei_ind))/(2*180)));
% w = 1-min(1,-min(log(1-abs(grad(cur_ind))),log(1-abs(grad(nei_ind)))));
w = -max(log(abs(grad(cur_ind))),log(abs(grad(nei_ind))));
% w = -min(log(1-abs(grad(cur_ind))),log(1-abs(grad(nei_ind))));
% w = exp(-(cur_x(1)-nei_x(1))^2/(2*sigma^2));
%           w = 1-pdist([x(cur_ind,:);x(nei_ind,:)],'cosine');
          w = w*weight;
%           if(cur_x(1)>=nei_x(1))
%              edges = [edges;nei_ind,cur_ind,0,1,w,0]; 
%          else
%              edges = [edges;nei_ind,cur_ind,0,w,1,0]; 
%          end
          edges = [edges;nei_ind,cur_ind,0,w,w,0]; 
      end
      disp(num2str(k));
   end
end


sort_w = unique(sort(edges(:,4)));
max_w = sort_w(end-1);
edges(edges(:,4)==inf,4)=max_w;
edges(edges(:,5)==inf,5)=max_w;

end


function[ind] = ij2ind(i,j,height,width)
ind = height*(j-1)+i;

end

function[i,j] = ind2ij(ind,height,width)
i = mod(ind-1,height)+1;
j = floor((ind-1)/height)+1;
end