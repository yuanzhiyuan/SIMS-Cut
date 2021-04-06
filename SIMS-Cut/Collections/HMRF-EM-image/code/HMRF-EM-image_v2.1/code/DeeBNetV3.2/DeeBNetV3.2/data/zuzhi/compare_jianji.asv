
function[] = compare_jianji()
% load('180328_zuzhi_jianji.mat');
% 'C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\EM_mid_rst\';

load('C:\Users\Yuan Zhiyuan\Documents\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\EM_mid_rst\cur_labeling_0403_0328_20_Fmeasure_0.8_grad_div10_22.mat')
for i=1:5
    for j=1:5
        ind = ij2ind(j,i,5,5);
        subplot(5,5,ind);
        if(i==j)
           histogram(test_samples(:,i));
           continue;
        end
            
          
        
        diff_img = reshape(test_samples(:,i)-test_samples(:,j),256,256)';
        imagesc(diff_img);
        colormap('jet');
        title_str = [num2str(i),'-',num2str(j)];
        title(title_str);
        
        
    end
     
end
end

function[ind] = ij2ind(i,j,height,width)
ind = height*(j-1)+i;

end