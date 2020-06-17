function[x] = get_all_matter_merge(all_matters_de,all_matters_ds)
matter1_de = reshape(sum(all_matters_de{15},2),128,128);
matter1_ds = reshape(sum(all_matters_ds{15},2),128,128);
[m_f1,seg1] = merge_fig(matter1_de,matter1_ds,1);

x = [];
m_f2 = zeros(size(seg1));
for k=1:40
    for i=1:128
        for j=1:128
            if(seg1(i,j)==0)
                m_f2(i,j) = 0; 
            elseif(seg1(i,j)==1)
                tmp1 = reshape(sum(all_matters_de{k},2),128,128);
                m_f2(i,j) = tmp1(i,j);
            else
                tmp2 = reshape(sum(all_matters_ds{k},2),128,128);
                m_f2(i,j) = tmp2(i,j);
            end
       
        end
    end
    x = [x,m_f2(:)];
end


