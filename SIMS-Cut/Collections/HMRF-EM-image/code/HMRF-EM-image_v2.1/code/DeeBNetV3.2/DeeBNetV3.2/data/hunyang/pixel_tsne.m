for i=1:6
    for j=10:10:100
   batch =  data_mat(data_mat(:,1)==i,4:end);
   batch_n = bsxfun(@rdivide,batch,batch(:,1));
   y = tsne(batch, [], 2, 20, j);
   y_n = tsne(batch_n, [], 2, 20, j);
   group = data_mat(data_mat(:,1)==i,3);
   save(['pixel_tsne_',num2str(i),'_',num2str(j),'.mat'],'y','y_n','group');
    end
end