function[fimg]  = flip_image(img)
[sz1,sz2] = size(img);
fimg = zeros(sz1,sz2);
for i=1:sz1
    for j=1:sz2
        fimg(sz1+1-i,j) = img(i,j);
    end
end