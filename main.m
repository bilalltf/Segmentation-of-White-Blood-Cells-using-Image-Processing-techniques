I = imread('BloodImage_00000.jpg');
%Iblue = I(:,:,3);
Iblue = rgb2gray(I);

% Step 2: Detect Entire Cell
[~,threshold] = edge(Iblue,'sobel');
fudgeFactor = 0.5;
BWs = edge(Iblue,'sobel',threshold * fudgeFactor);
imshow(BWs)
title('Binary Gradient Mask')

% Step 3: Dilate the Image
se = strel('disk',1);

BWsdil = imdilate(BWs,se);
imshow(BWsdil)
title('Dilated Gradient Mask')

% Step 4: Fill Interior Gaps
BWdfill = imfill(BWsdil,'holes');
imshow(BWdfill)
title('Binary Image with Filled Holes')

% Step 5: Remove Connected Objects on Border
BWnobord = imclearborder(BWdfill,4);
imshow(BWnobord)
title('Cleared Border Image')

% Step 6: Smooth the Object
seD = strel('disk',2);
BWfinal = imerode(BWnobord,seD);
BWfinal = imerode(BWfinal,seD);
imshow(BWfinal)
title('Segmented Image');

% Step 7: Visualize the Segmentation
imshow(labeloverlay(Iblue,BWfinal))
title('Mask Over Original Image')



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


myImage = imread('BloodImage_00000.jpg');
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
BW2 = bwareaopen(BW, 300);
imshow(BW2)

% Visualize Mask Over Original Image
imshow(labeloverlay(myImage,BW2))
title('Mask Over Original Image')

%%Calculate area of regions
cellStats = regionprops(BW2, 'all');
cellAreas = [cellStats(:).Area];

%%Superimpose onto original image
figure, imshow(myImage), hold on
himage = imshow(BW2);
set(himage, 'AlphaData', 0.5);
title('Superimpose into original image')
