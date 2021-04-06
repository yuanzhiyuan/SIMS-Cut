% path = 'C:\Users\Yuan Zhiyuan\Documents\MATLAB\SIMS_0820\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\zuzhi\1208\EM_mid_rst\';
% file_prefix = 'cur_labeling_1023_20181208_liver-alb_20_ada_test_20_Fmeasure_0.8_div10__';
% cur_labeling_0713_liver-cancer-1_20_Fmeasure_0.5_ada21auto_div10__1.mat
file_sufix = '.mat';
iters_max = 200;
iters_num = 0
for i=1:iters_max
   cur_file = strcat(path,file_prefix,num2str(i),file_sufix);
   
	disp(cur_file)
   if exist(cur_file, 'file') 
       iters_num = i;
   end
end
disp(num2str(iters_num));
height = sz;
fold_mean = 1.00;
width = sz;
%指大于0.75分位数的细胞要考虑分裂(75分位数)
attention_threshold = 40;
labeling_mat = zeros(height*width,iters_num);
% 构建labeling_mat，并看哪个图的cell最多
num_cells_li =[];
num_pixels_li = [];
for i=1:iters_num
   cur_file = [path,file_prefix,num2str(i),file_sufix];
   load(cur_file);
  
   [filtered_img,num_valid_cell,filtered_labeling] = filter_cell_ext(cur_labeling,0,sz);
   img = reshape(filtered_labeling,sz,sz);
    [separated_img]=Separate_cell(img);
%     num_cells = max();        
    labeling_mat(:,i) = separated_img(:);
    num_pixels = sum(cur_labeling==2);
    num_cells_li = [num_cells_li,num_valid_cell];
    num_pixels_li = [num_pixels_li,num_pixels];
end
labeling_mat = labeling_mat(:,2:end);
disp('filter done')
%第i个位置表示i号节点的父节点的idx,1号节点是全1
parent_list = [0];
%记录第i个节点属于哪一层，第1层是labeling_1
level_list = [0];
%记录第i个节点是那一层的几号细胞
cell_list = [1];
area_list = [sz*sz];


lost_number = 0;
iters_num = iters_num-1;
%假设第一个labeling包含了bias的kmeans，把全1当作根节点，代号为1
 pre_lost = 0;
for i=1:iters_num
disp(['loop2',':',num2str(i)])
   cur_labeling = labeling_mat(:,i);
   num_cells = max(cur_labeling);
   if(i==1)
       for j=1:num_cells
           parent_list = [parent_list,1];
           level_list = [level_list,1];
           cell_list = [cell_list,j];
           area_list = [area_list,sum(cur_labeling==j)];
       end
       continue;
   end
   pre_labeling = labeling_mat(:,i-1);
   pre_idxs = (length(parent_list)-max(pre_labeling)+1+pre_lost):length(parent_list);

   pre_cells = cell_list(pre_idxs);
   pre_lost = 0;
   for j=1:num_cells
      %把新来的节点的父节点记录下来
      flag = 1;
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       for k=pre_cells
%          if(max(max((cur_labeling==j)+(pre_labeling==k)))==2)
%              
%             
%             %说明两层这两个segment有重叠
%             parent_list = [parent_list,pre_idxs(k)];
%             level_list = [level_list,i];
%             cell_list = [cell_list,j];
%             area_list = [area_list,sum(cur_labeling==j)];
%             
%             flag = 0;
%             break;
%     
%              
%          end
%          
%          
%          
%       end
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        要求重叠面积最大，才是爸爸
%         overlap_area_list = [];
%         for k=pre_idxs
%             overlap_area = sum((cur_labeling==j)+(pre_labeling==cell_list(k))==2);
%             overlap_area_list = [overlap_area_list,overlap_area];
%         end
%         [max_area_val,max_area_ind] = max(overlap_area_list);
%         if(max_area_val>0)
%             %说明找到爸爸了
%             flag= 0;
%             
%             parent_list = [parent_list,pre_idxs(max_area_ind)];
%             level_list = [level_list,i];
%             cell_list = [cell_list,j];
%             area_list = [area_list,sum(cur_labeling==j)];
%         
%             %说明找不到爸爸，丢失
%         end
       
       
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
       for k=pre_idxs
         if(max(max((cur_labeling==j)+(pre_labeling==cell_list(k))))==2)
             
            
            %说明两层这两个segment有重叠
            parent_list = [parent_list,k];
            level_list = [level_list,i];
            cell_list = [cell_list,j];
            area_list = [area_list,sum(cur_labeling==j)];
            
            flag = 0;
            break;
    
             
         end
         
         
         
      end
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
       
       
%       发现丢失了770个
      if(flag)
          pre_lost = pre_lost+1;
         lost_number = lost_number+1; 
         disp([num2str(i+1),',',num2str(j)]);
         
      end
      
   end
    
end


%找出所有的叶子节点，并赋给final_labeling
parent_set = unique(parent_list);
all_set = 1:length(parent_list);
leaf_set = setdiff(all_set,parent_set);

mean_leaf_area = median(area_list(leaf_set));
area_threshold = fold_mean*mean_leaf_area;
single_leaf_set = leaf_set;
%对每一个叶子节点往上回溯，找到level最低的不分裂节点
intensity_134_list_count = 1;
intensity_134_list= [];
for i=leaf_set
    

disp(['loop3',':',num2str(i)])
        if(length(intensity_134_list)>=2)
        disp(['---------------',num2str(length(intensity_134_list))]);
        intensity_134_list_cell{intensity_134_list_count} = intensity_134_list;
        intensity_134_list_count = intensity_134_list_count+1;
    end
    
    intensity_134_list= [];
    ori_leaf = i;
    cur_leaf = i;
    cur_leaf_level = level_list(i);

   while(cur_leaf~=0)
       
       
        
        cur_leaf_cell = cell_list(cur_leaf);
        if(cur_leaf_level<=0)
	    continue;
        end
        cur_134_mean = mean(test_samples_20(labeling_mat(:,cur_leaf_level)==cur_leaf_cell,1));
        intensity_134_list = [intensity_134_list,cur_134_mean];
        
        if(length(intensity_134_list)==1)
            foldchange_intensity_134 = 1;
        else
            foldchange_intensity_134 = intensity_134_list(end)/intensity_134_list(end-1);
        end
        
       
        
%        先看当前层有没有leaf跟curleaf是同一个爸爸
       check_brother = sum(parent_list(level_list==cur_leaf_level)==parent_list(cur_leaf));
       if(check_brother==0)
           disp('error');
           
%            上升到分叉这个条件没问题，因为只要有沟壑
%           重点是要决定上升到哪一层停止？单纯用threshold不行
% 方案：上升到平均134的信号不减弱？或者画一个上升过程中平均134的变化图（应该是下降趋势），取拐点。
% 现在：只要134的平均值下降了百分之*就停止上升
% 或者说134的平均，没有降到原来的百分之*才停止

%        elseif(check_brother==1 & area_list(cur_leaf)<=area_threshold)
        elseif(check_brother==1 && foldchange_intensity_134>=fold_mean)
           %说明可以往上走
           cur_leaf = parent_list(cur_leaf);
%            cur_leaf_level = cur_leaf_level-1;
            cur_leaf_level = level_list(cur_leaf);
       else
           %不能往上走
           single_leaf_set(single_leaf_set==ori_leaf) = cur_leaf;
           disp(['change ',num2str(ori_leaf),'to ',num2str(cur_leaf)]);
           break;
       end
       
       
       
   end
end


final_labeling = zeros(sz*sz,1);
leaf_labeling = zeros(sz*sz,1);
for i=single_leaf_set
   cur_leaf_level = level_list(i);
   cur_leaf_cell = cell_list(i);
   final_labeling(labeling_mat(:,cur_leaf_level)==cur_leaf_cell) = 1;
end

for i=leaf_set
   cur_leaf_level = level_list(i);
   cur_leaf_cell = cell_list(i);
   leaf_labeling(labeling_mat(:,cur_leaf_level)==cur_leaf_cell) = 1;
end

final_labeling = final_labeling+1;
leaf_labeling = leaf_labeling + 1;
[~,final_num_cells,final_labeling] = filter_cell_ext(final_labeling,1,sz);
disp(['there are ',num2str(final_num_cells),' valid cells']);
% subplot(1,2,1);
% imshow(reshape(leaf_labeling,256,256)',[]);
% subplot(1,2,2);
% imshow(reshape(final_labeling,256,256)',[]);
save(strcat(save_final_labeling_path,'final_labeling_',num2str(beta),'.mat'),'final_labeling');

final_labeling_img = logical(reshape(final_labeling,sz,sz)'-1);
imwrite(final_labeling_img,strcat(save_final_labeling_path,'final_labeling_',num2str(beta),'.png'));
img_134 = reshape(test_samples_20(:,1),sz,sz)';
imshowpair(img_134,final_labeling_img);
print(strcat(save_final_labeling_path,'final_labeling_merge134_',num2str(beta),'.png'),'-dpng');

























% [max_cell_num,max_cell_idx] = max(num_cells_li);
% % 开始分析初始图中的细胞
% max_cell_idx=2;
% %max为细胞个数，min为0（基低）
% 
% init_image_labeling = labeling_mat(:,max_cell_idx);
% max_cell_num = max(init_image_labeling);
% final_labeling = init_image_labeling;
% cell_size_li = [];
% for i=1:max_cell_num
%     cell_size_li = [cell_size_li,sum(init_image_labeling==i)];
% end
% thre_area = prctile(cell_size_li,attention_threshold);
% attention_cells = find(cell_size_li>thre_area);
% idx = 1;
% while(idx<=length(attention_cells) )
%     i = attention_cells(idx);
% % for i=attention_cells
%     idx = idx + 1;
%     region_idxs = find(final_labeling==i);
%     in_region_cells_li = [];
%     cell_area_var_li = [];
%     cell_area_li_dict = {};
%     j_in_region_dict = {};
%     for j=max_cell_idx+1:iters_num
%         j_sep_labeling = labeling_mat(:,j);
%         j_in_region = j_sep_labeling(region_idxs);
%         if(all(j_in_region))
%             %如果没有0，应从下一个j中找
%             in_region_cells_li = [in_region_cells_li,0];
%             continue;
%         end
% %         去掉0之后，看这个区域里有多少个不同cell
%         j_in_region = j_in_region(j_in_region~=0);
%         cell_idx_j = unique(j_in_region);
%         j_in_region_dict{j-max_cell_idx} = cell_idx_j;
%         num_cells_in_region = length(cell_idx_j);
%         in_region_cells_li = [in_region_cells_li,num_cells_in_region];
%         
%         cell_area_li = [];
%         for k=cell_idx_j'
%             cell_area_li = [cell_area_li,sum(j_sep_labeling==k)];
%         end
%         cell_area_li_dict{j-max_cell_idx} = cell_area_li;
%         cell_area_var_li = [cell_area_var_li,var(cell_area_li)];
%         
%     end
% %     [select_j_value,~] = max(in_region_cells_li);
%     %选择分裂出来最多的细胞，可能有好几个图都是最多的，选方差最小的。
% %     [select_j_va]
% %     cell_area_var_li(in_region_cells_li>=max(select_j_value-1,1))=inf;
% %     [~,select_j] = min(cell_area_var_li);
% %     in_region_cells_li=fliplr(in_region_cells_li);
%      [~,select_j] = max(in_region_cells_li);
%      j_area_li = cell_area_li_dict{select_j};
%      j_idx_li = j_in_region_dict{select_j};
%      
%      illigel = j_idx_li(j_area_li>=thre_area);
% %      if(length(j_area_li)>=1)
% %         disp(i,j) ;
% %      end
%      
%      
%     select_j = select_j + max_cell_idx;
%     %select_j就是应该替换掉attention的img中第i个cell的图
%     j_sep_labeling = labeling_mat(:,select_j);
%     j_in_region = j_sep_labeling(region_idxs);
%     added_j_in_region = j_in_region;
%     max_final_labeling = max(final_labeling);
%     added_j_in_region(added_j_in_region~=0) = added_j_in_region(added_j_in_region~=0)+max_final_labeling;
%     
% %      final_labeling(region_idxs)=0;
%     final_labeling(region_idxs)  =added_j_in_region;
%     attention_cells = [attention_cells,illigel'+max_final_labeling];
%     i
%     
% end
% 
% final_labeling(final_labeling~=0)=1;
% final_labeling = final_labeling+1;
% subplot(1,2,1);
% imshow(reshape(final_labeling,256,256)',[]);
% subplot(1,2,2);
% imshow(reshape(init_image_labeling,256,256)');
% [~,final_num_cells,~] = filter_cell(final_labeling,3);
% disp(['有',num2str(final_num_cells),'个有效细胞']);
% 
% 
% % cur_labeling_0704_yidao_20_Fmeasure_0.5_ada21auto_div5__1.mat
% % cur_labeling_0704_yidao_20_Fmeasure_0.5_ada21auto_div10__1.mat

