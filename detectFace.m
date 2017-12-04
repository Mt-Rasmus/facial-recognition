function [ face ] = detectFace( input )
% Detecting face by creating binary face mask
% Adding face mask to input image
% Morphing the resulting image

height = size(input,1);
width = size(input,2);

%Initialize the output images
binary = zeros(height,width);

%Convert the image from RGB to YCbCr
img_ycbcr = rgb2ycbcr(input);
Y = img_ycbcr(:,:,1);
Cb = img_ycbcr(:,:,2);
Cr = img_ycbcr(:,:,3);

%{
%%%%%%%%%%%% TESTING
[ww hh] = size(Cr);
wa = zeros(ww,hh);
[a,b,c] = find(Cr >= 125 & Cr<=183 );
nu = size(a,1);
for i=1:nu
    wa(a(i),b(i)) = 1;
end
figure
imshow(wa);
title('test Cr')

wa2 = zeros(ww,hh);
[a2,b2,c2] = find(Cb<=140 & Cb >= 100);
nu2 = size(a2,1);
for i=1:nu2
    wa2(a2(i),b2(i)) = 1;
end
%figure
%imshow(wa2);
%title('test Cb')
%%%%%%%%%%%%
%}

%Detect Skin with static thresholding
[r,c,v] = find( Cr >= 125 & Cr<=183);
numind = size(r,1);

% Mark skin pixels as white
for i=1:numind
    binary(r(i),c(i)) = 1;
end

%figure
%imshow(binary)
%title('binary face mask without morphing')

% Morphological operations to enhance face mask
morphedBinary = enhanceFacemask(binary);
binary_uint8 = im2uint8(morphedBinary);

% Add original face to face mask
%facemaskR = immultiply(input(:,:,1), binary_uint8/255);
%facemaskG = immultiply(input(:,:,2), binary_uint8/255);
%facemaskB = immultiply(input(:,:,3), binary_uint8/255);

%facemask = cat(3, facemaskR, facemaskG, facemaskB);
faceMask = binary_uint8;

%Eye positions
[eyePos1, eyePos2] = eyeMap(input, faceMask);


%Mouth map and mouth position
[mouthmap, mouthPos] = mouthMap(input);

rotatedImage = face_orientation(input, eyePos1, eyePos2);

%Crop image
eyeCenter = round((eyePos1 + eyePos2)./2);
centerOfImage = round((eyeCenter + mouthPos)./2);

figure
imshow(rotatedImage)
hold on
plot(centerOfImage(1), centerOfImage(2), 'c*')

xmin = centerOfImage(1) - 150;
xmax = centerOfImage(1) + 150;
ymin = centerOfImage(2) - 200;
ymax = centerOfImage(2) + 100;

width = xmax- xmin;
height = ymax - ymin;
cropped = imcrop(rotatedImage,[xmin ymin width height]);

cropped = imresize(cropped, [400, 250]);

face = rgb2gray(cropped);

end

