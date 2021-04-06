function[edges] = get_BK_pairwise(x,mode,Height,Width)
%edge：numEdge*6的矩阵
%注意，这里e00和e11（也就是label相同的情况），权重是0
%x是输入数据，65536*355
%mode=1: 用第一维计算，eu
% mode=2：用20维计算，eu
%mode=3：用20维计算，内急
weight = 1;
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
         if(mode==1)
             w = (cur_x(1)-nei_x(1))^2;
         elseif(mode==2)
             w = pdist([cur_x;nei_x],'euclidean');
             w = w^2;
         elseif(mode==3)
             w = 1;
         elseif(mode==4)
             w = (cur_x(1)-nei_x(1))^2;
    
    
         end
         w = w*weight;
         edges = [edges;nei_ind,cur_ind,0,w,w,0]; 
         
         
      end
      if(j+1<=Width)
          cur_ind = ij2ind(i,j,Height,Width);
          nei_ind = ij2ind(i,j+1,Height,Width);
          cur_x = x(cur_ind,:);
          nei_x = x(nei_ind,:);
          if(mode==1)
              w = (cur_x(1)-nei_x(1))^2;
          elseif(mode==2)
              w = pdist([cur_x;nei_x],'euclidean');
              w = w^2;
          elseif(mode==3)
              w = 1;
          elseif(mode==4)
              w = (cur_x(1)-nei_x(1))^2;
    
          end
          w = w*weight;
          edges = [edges;nei_ind,cur_ind,0,w,w,0]; 
      end
      disp(num2str(k));
   end
end

if(mode==4 | mode==3)
   return; 
end
beta = 1/(2*mean(edges(:,4)));
disp(['sigma:',num2str(sqrt(1/(2*beta)))]);
disp(['sigma2:',num2str(sqrt(1/(beta)))]);
edges(:,[4,5]) = exp(-beta*edges(:,[4,5]));
end


function[ind] = ij2ind(i,j,height,width)
ind = height*(j-1)+i;

end

function[i,j] = ind2ij(ind,height,width)
i = mod(ind-1,height)+1;
j = floor((ind-1)/height)+1;
end
