G = digraph(s,t,w);
record_ijd = [];
for i=1:65536
    for j=1:65536
        disp(['i=',num2str(i),', j=',num2str(j),', found=',num2str(size(record_ijd,1))]);
        dij = distances(G,i,j,'Method','unweighted');
        if(dij~=inf & dij~=0)
            record_ijd = [record_ijd;i,j,dij];
%             disp(['i=',num2str(i),' ,j=',num2str(j),'found=',num2str(size(record_ijd,1))]);
        end
    end
end