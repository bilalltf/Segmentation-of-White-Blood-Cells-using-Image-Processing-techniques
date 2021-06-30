clear 
close all

I = imread('BloodImage_00009.jpg');
figure
imshow(I)
%%Extracting the blue plane 
bPlane = I(:,:,3)  - 0.5*(I(:,:,1)) - 0.5*(I(:,:,2));
figure
imshow(bPlane), title('blue plane')
%%Extract out purple cells
figure
BW = bPlane > 29;
imshow(BW), title('Binarization');
%%Remove noise 1000 pixels or less
BW = bwareaopen(BW, 1000);

%%Morphological operation
se = strel('disk', 10);
BW = imopen(BW, se);



% Visualize Mask Over Original Image
figure
imshow(labeloverlay(I,BW))
title('Mask Over Original Image')

%%Calculate area of regions
cellStats = regionprops(BW, 'all');
cellAreas = [cellStats(:).Area];

%%Superimpose onto original image
figure, imshow(I), hold on
himage = imshow(BW);
set(himage, 'AlphaData', 0.5);
title('Superimpose into original image')

%%watershed

D = bwdist(~BW);
figure, imshow(D,[])
title('Distance Transform of Binary Image')

D = -D;
figure, imshow(D,[])
title('Complement of Distance Transform')

L = watershed(D);
L(~BW) = 0;

rgb = label2rgb(L,'jet',[.5 .5 .5]);
figure, imshow(rgb)
title('Watershed Transform')
mask = imextendedmin(D,2);
figure,imshowpair(BW,mask,'blend')
D2 = imimposemin(D,mask);
Ld2 = watershed(D2);
bw3 = BW;
bw3(Ld2 == 0) = 0;
figure, imshow(bw3), title('Final result')

