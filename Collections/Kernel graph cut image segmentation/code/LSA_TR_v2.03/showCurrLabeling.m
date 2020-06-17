function showCurrLabeling(figureHandle, img, whichLabel,currLabeling, titleString)
[numRows, numCols, numChannels] = size(img);
currLabeling = currLabeling(reshape(1:numRows*numCols, numRows, numCols));
% boundary = bwmorph(bwmorph(bwmorph(currLabeling == whichLabel,'remove'),'thicken',1),'close');
 boundary = bwmorph(currLabeling == whichLabel,'remove');
% gray scale
if (numChannels == 1)
    
    if max(img(:))~=0
        img=(img - min(img(:)))./(max(img(:))-min(img(:)));
    end
    showImg2 = double(currLabeling == whichLabel);
    
   
    imgR = img;
    imgG = img;
    imgB = img;

else
    imgR = img(:,:,1);
    imgG = img(:,:,2);
    imgB = img(:,:,3);
    showImg2R = imgR.*double(currLabeling == whichLabel) + ones(numRows, numCols).*double(currLabeling~=whichLabel);
    showImg2G = imgG.*double(currLabeling == whichLabel)+ ones(numRows, numCols).*double(currLabeling~=whichLabel);
    showImg2B = imgB.*double(currLabeling == whichLabel)+ ones(numRows, numCols).*double(currLabeling~=whichLabel);
    showImg2 = cat(3, showImg2R, showImg2G, showImg2B);
    
end  

%     green (127,255,0)
% red (255,69,0)
% yellow (255,255,0)
% cyan (0,255,255)

imgR(boundary) = 127/255;
imgG(boundary) = 255/255;
imgB(boundary) = 0;

showImg = cat(3,imgR,imgG,imgB);



figure(figureHandle); 
subplot(1,2,1); imagesc(showImg); title(titleString); axis equal; axis off;axis ij;
subplot(1,2,2); imagesc(showImg2);  axis equal; axis off;axis ij;colormap gray
% imwrite(showImg,['/iterations/' titleString '_B.png']);
% imwrite(showImg2,['iterations/' titleString '.png']);
% 
drawnow;

end
