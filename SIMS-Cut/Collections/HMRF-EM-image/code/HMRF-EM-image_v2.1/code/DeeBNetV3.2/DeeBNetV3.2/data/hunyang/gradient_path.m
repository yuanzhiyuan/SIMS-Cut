%输入是一个65536*1的物质（或者是叠加）

record_steps_matrix = [];

% for i=1:500
for i=sort_mean_ind(1:10)
    disp(['processing matter',num2str(i)]);
    img_pixel = test_samples(:,i);
    [sort_val,sort_ind] = sort(img_pixel,'descend');
    max_val = sort_val(1);
    top_pixel_ind = sort_ind(1:1000);
    img = reshape(img_pixel,256,256)';

    % visited = zeros(258,258);
    imagesc(reshape(test_samples(:,189),256,256)');
%     colormap('jet');
    title(num2str(matters_candidate(i)));
    record_steps = [];
    for i=1:256
        for j=1:256
%     for ind = top_pixel_ind'
%             start_y = mod(ind-1,256)+1;
%             start_x = floor((ind-1)/256)+1;
            start_x = i;
            start_y = j;
            extended_img = max_val*ones(258,258);
            extended_img(2:257,2:257) = img;
            extended_x = start_x + 1;
            extended_y = start_y + 1;
            record_line = [];
            while(1)
            %     visited(extended_x,extended_y) = 1;
                record_line = [record_line;extended_x-1,extended_y-1];

                cur_val = extended_img(extended_x,extended_y);
%                 disp([num2str(extended_x-1),',',num2str(extended_y-1),' ',num2str(cur_val)]);
                %b把当前的?取出来之后，把它设置为最大，表示访问过了。
                extended_img(extended_x,extended_y) = max_val;
                all_dir = [extended_img(extended_x,extended_y+1),
                            extended_img(extended_x+1,extended_y+1),
                            extended_img(extended_x+1,extended_y),
                            extended_img(extended_x-1,extended_y+1),
                            extended_img(extended_x-1,extended_y),
                            extended_img(extended_x-1,extended_y-1),
                            extended_img(extended_x,extended_y-1),
                            extended_img(extended_x+1,extended_y-1)];
                [min_val,min_ind] = min(all_dir);
                if(min_val>=cur_val)
                    break;
                end
                %否则说明还能够往下走
                switch min_ind
                    case 1
                        extended_x = extended_x;
                        extended_y = extended_y + 1;
                    case 2
                        extended_x = extended_x + 1;
                        extended_y = extended_y + 1;
                    case 3
                        extended_x = extended_x + 1;
                        extended_y = extended_y;
                    case 4
                        extended_x = extended_x - 1;
                        extended_y = extended_y + 1;
                    case 5
                        extended_x = extended_x - 1;
                        extended_y = extended_y;
                    case 6
                        extended_x = extended_x - 1;
                        extended_y = extended_y - 1;
                    case 7
                        extended_x = extended_x;
                        extended_y = extended_y - 1;
                    case 8
                        extended_x = extended_x + 1;
                        extended_y = extended_y - 1;
                end

            end
%             line(record_line(:,2)',record_line(:,1)','color','r');
            if(size(record_line,1)>=8)
                line(record_line(:,2)',record_line(:,1)','color','r');
            end
            record_steps = [record_steps;size(record_line,1)];
        end
    end
    record_steps_matrix = [record_steps_matrix,record_steps];
end

record_steps_mean = mean(record_steps_matrix);
[sort_mean_val,sort_mean_ind] = sort(record_steps_mean,'descend');

boxplot(record_steps_matrix(:,sort_mean_ind(1:10)),'Labels',arrayfun(@num2str, matters_candidate(sort_mean_ind(1:10)), 'Uniform', false))
