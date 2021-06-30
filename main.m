clear 
close all
% I = imread('BloodImage_00000.jpg');
% figure, imshow(I)
% figure, imshow(I)
% %Iblue = I(:,:,3);
% Iblue = rgb2gray(I);
% figure, imshow(Iblue)
% % Step 2: Detect Entire Cell
% [~,threshold] = edge(Iblue,'sobel');
% fudgeFactor = 0.5;
% BWs = edge(Iblue,'sobel',threshold * fudgeFactor);
% figure,
% imshow(BWs)
% title('Binary Gradient Mask')
% 
% % Step 3: Dilate the Image
% se = strel('disk',1);
% 
% BWsdil = imdilate(BWs,se);
% imshow(BWsdil)
% title('Dilated Gradient Mask')
% 
% % Step 4: Fill Interior Gaps
% BWdfill = imfill(BWsdil,'holes');
% imshow(BWdfill)
% title('Binary Image with Filled Holes')
% 
% % Step 5: Remove Connected Objects on Border
% BWnobord = imclearborder(BWdfill,4);
% imshow(BWnobord)
% title('Cleared Border Image')
% 
% % Step 6: Smooth the Object
% seD = strel('disk',2);
% BWfinal = imerode(BWnobord,seD);
% BWfinal = imerode(BWfinal,seD);
% imshow(BWfinal)
% title('Segmented Image');
% 
% % Step 7: Visualize the Segmentation
% imshow(labeloverlay(Iblue,BWfinal))
% title('Mask Over Original Image')
% 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


myImage = imread('BloodImage_00006.jpg');
figure
imshow(myImage)
%%Extracting the blue plane 
bPlane = myImage(:,:,3)  - 0.5*(myImage(:,:,1)) - 0.5*(myImage(:,:,2));
figure
imshow(bPlane)
%%Extract out purple cells
figure
BW = bPlane > 29;
imshow(BW)
%%Remove noise 300 pixels or less
% BW = imfill(BW, 'holes');
BW = bwareaopen(BW, 1000);
imshow(BW)
se = strel('disk', 10);

BW = imopen(BW, se);


% Visualize Mask Over Original Image
imshow(labeloverlay(myImage,BW))
title('Mask Over Original Image')

%%Calculate area of regions
cellStats = regionprops(BW, 'all');
cellAreas = [cellStats(:).Area];

%%Superimpose onto original image
figure, imshow(myImage), hold on
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
imshowpair(BW,mask,'blend')
D2 = imimposemin(D,mask);
Ld2 = watershed(D2);
bw3 = BW;
bw3(Ld2 == 0) = 0;
figure, imshow(bw3)

