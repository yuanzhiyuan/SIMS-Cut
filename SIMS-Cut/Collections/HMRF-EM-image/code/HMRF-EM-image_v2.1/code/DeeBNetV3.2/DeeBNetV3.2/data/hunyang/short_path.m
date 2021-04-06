function[] = short_path(test_samples,sigma)
    samples = test_samples(:,403);
    
    %samples是一列数据
%     img = reshape(samples,256,256);
% %     img = img(151:250,151:250);
%     samples = img(:);
    tor = 1;
    %不一定沿线严格单调
    Height = 256;
    Width = 256;
    s = [];
    t = [];
    w = [];
    k=0;
    for i=1:Height

        for j=1:Width
            k = k+1;
            disp(num2str(k));
            if(i+1<=Height)

             cur_ind = ij2ind(i,j,Height,Width);
             nei_ind = ij2ind(i+1,j,Height,Width);
             cur_val = samples(cur_ind);
             nei_val = samples(nei_ind);
             if(cur_val>=nei_val-tor)
                 s = [s,cur_ind];
                 t = [t,nei_ind];
                 %下降越大，权重（路程）越小
                 cur_w = exp(-(cur_val-nei_val+tor)^2/sigma^2);
                 w  =[w,cur_w];
             end
             if(nei_val>=cur_val-tor)
                 s = [s,nei_ind];
                 t = [t,cur_ind];
                 cur_w = exp(-(cur_val-nei_val-tor)^2/sigma^2);
                 w = [w,cur_w];
                 
             end


             if(j+1<=Width)
                 nei_ind = ij2ind(i+1,j+1,Height,Width);
                 nei_val = samples(nei_ind,:);
                 if(cur_val>=nei_val-tor)
                     s = [s,cur_ind];
                     t = [t,nei_ind];
                     %下降越大，权重（路程）越小
                     cur_w = exp(-(cur_val-nei_val+tor)^2/sigma^2);
                     w  =[w,cur_w];
                 end
                 if(nei_val>=cur_val-tor)
                     s = [s,nei_ind];
                     t = [t,cur_ind];
                     %下降越大，权重（路程）越小
                     cur_w = exp(-(cur_val-nei_val-tor)^2/sigma^2);
                     w  =[w,cur_w];
                 end
             end

            end

            if(j+1<=Width)

             cur_ind = ij2ind(i,j,Height,Width);
             nei_ind = ij2ind(i,j+1,Height,Width);
             cur_val = samples(cur_ind);
             nei_val = samples(nei_ind);
             if(cur_val>=nei_val-tor)
                 s = [s,cur_ind];
                 t = [t,nei_ind];
                 %下降越大，权重（路程）越小
                 cur_w = exp(-(cur_val-nei_val+tor)^2/sigma^2);
                 w  =[w,cur_w];
             end
             if(nei_val>=cur_val-tor)
                 s = [s,nei_ind];
                 t = [t,cur_ind];
                 %下降越大，权重（路程）越小
                 cur_w = exp(-(cur_val-nei_val-tor)^2/sigma^2);
                 w  =[w,cur_w];
             end


             if(i-1>=1)
                 nei_ind = ij2ind(i-1,j+1,Height,Width);
                 nei_val = samples(nei_ind,:);
                 if(cur_val>=nei_val-tor)
                     s = [s,cur_ind];
                     t = [t,nei_ind];
                     %下降越大，权重（路程）越小
                     cur_w = exp(-(cur_val-nei_val+tor)^2/sigma^2);
                     w  =[w,cur_w];
                 end
                 if(nei_val>=cur_val-tor)
                     s = [s,nei_ind];
                     t = [t,cur_ind];
                     %下降越大，权重（路程）越小
                     cur_w = exp(-(cur_val-nei_val-tor)^2/sigma^2);
                     w  =[w,cur_w];
                 end
             end

            end


        end

    end
end
function[ind] = ij2ind(i,j,height,width)
ind = height*(j-1)+i;

end