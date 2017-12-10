function [ face ] = detectFace( input )
% Detecting face by creating binary face mask
% Adding face mask to input image
% Morphing the resulting image

height = size(input,1);
width = size(input,2);

%Initialize the output images
binary = zeros(height,width);

%Convert the image from RGB to YCbCr color space
img_ycbcr = rgb2ycbcr(input);
Y = img_ycbcr(:,:,1);
Cb = img_ycbcr(:,:,2);
Cr = img_ycbcr(:,:,3);

%Detect Skin with static thresholding
[r,c,v] = find( Cr >= 125 & Cr<=183);
numind = size(r,1);

% Mark skin pixels as white
for i=1:numind
    binary(r(i),c(i)) = 1;
end

% Morphological operations to enhance face mask
morphedBinary = enhanceFacemask(binary);
binary_uint8 = im2uint8(morphedBinary);

% Add original face to face mask
facemaskR = immultiply(input(:,:,1), binary_uint8/255);
facemaskG = immultiply(input(:,:,2), binary_uint8/255);
facemaskB = immultiply(input(:,:,3), binary_uint8/255);

faceMasked = cat(3, facemaskR, facemaskG, facemaskB);

%Mouth map and mouth position
[mouthmap, mouthPos] = mouthMap(faceMasked);

%figure
%imshow(mouthmap)
%title('mouth map')

%Eye positions
[eyePos1, eyePos2, numberOfEyes] = eyeMap(input, mouthPos);

% Return if two eyes were not detected
if( numberOfEyes ~= 2 )
    disp('Two eyes not detected!')
    face = [];
    return 
end

% Rotate face to align eye positions
rotatedImage = face_orientation(input, eyePos1, eyePos2);
% Crop image outside of face
cropped = image_normalization(rotatedImage, eyePos1, eyePos2, mouthPos);

face = rgb2gray(cropped);

end

