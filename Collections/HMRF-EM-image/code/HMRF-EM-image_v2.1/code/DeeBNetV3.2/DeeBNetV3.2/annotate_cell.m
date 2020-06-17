
    function[] = annotate_cell(sep_labeling)
  
   cell_idx = unique(sep_labeling(sep_labeling~=0));
   num_cells = length(cell_idx);
    cur_labeling = sep_labeling;
    cur_labeling(cur_labeling~=0)=1;
    imshow(reshape(cur_labeling,256,256)',[]);
    for idx=1:num_cells
        i = cell_idx(idx);
        pixel_li = find(sep_labeling==i);
        [text_i,text_j] = myind2ij(min(pixel_li),256,256);
        text(text_i,text_j,num2str(i),'Color','red');
%         subplot(num_cells,1,i);
%         b = bar(cur_cells_mean(i,:),0.1);
        
    end
    
  