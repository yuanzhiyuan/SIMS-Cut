br_vec = test_samples(:,matters_candidate==134.05);
n = size(test_samples,2);
ssz = ceil(sqrt(n));
corr_li = -1*ones(1,ssz*ssz);
matter_li = zeros(1,ssz*ssz);
for i=1:size(test_samples,2)
   cur_matter = test_samples(:,i);
   corr_li(i) = corr(br_vec,cur_matter);
   matter_li(i) = matters_candidate(i);
end

[sort_corr_li,sort_corr_ind] = sort(corr_li,'descend');
corr_li = sort_corr_li;
matter_li = matter_li(sort_corr_ind);
shape_corr_li = reshape(corr_li,ssz,ssz);
shape_matter_li = reshape(matter_li,ssz,ssz);




M = shape_corr_li;
n = size(M,1);
L = matters_candidate(60:150);
imagesc(M); % plot the matrix
set(gca, 'XTick', []); % center x-axis ticks on bins
set(gca, 'YTick', []); % center y-axis ticks on bins
for i=1:ssz
    
    for j=1:ssz
        text(j-0.5,i,num2str(shape_matter_li(i,j)));
    end
end
% set(gca, 'XTickLabel', L); % set x-axis labels
% set(gca, 'YTickLabel', L); % set y-axis labels
title('AB-H-1 correlation with A', 'FontSize', 14); % set title
colormap('jet'); % set the colorscheme
colorbar on; % enable colorbar