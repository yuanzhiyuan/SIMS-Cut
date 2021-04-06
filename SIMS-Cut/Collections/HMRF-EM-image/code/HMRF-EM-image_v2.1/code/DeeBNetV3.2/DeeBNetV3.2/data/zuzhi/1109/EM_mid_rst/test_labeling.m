% labeling_file = 'cur_labeling_1023_181111_liver_hoechst_blood_20_ada_20_Fmeasure_0.5_div10__';
% k=1
% i_start = 12
% i_end = 19
% for i=i_start:i_end
%     load([labeling_file,num2str(i),'.mat']);
%     subplot(1,i_end-i_start+1,k);
%     imshow(reshape(cur_labeling,256,256)',[]);
%     k=k+1;
% end

list_lengh = [];
for i=1:338
   cur_list = intensity_134_list_cell{i};
   cur_length = length(cur_list);
   list_lengh = [list_lengh,cur_length];
   if(cur_length>=10)
      disp(num2str(cur_length));
      
   end
end