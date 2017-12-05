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

if( numberOfEyes ~= 2 )
    disp('Two eyes not detected! Continuing with next image...')
    face = [];
    return 
end

rotatedImage = face_orientation(input, eyePos1, eyePos2);

%Crop image
eyeCenter = round((eyePos1 + eyePos2)./2);
%centerOfImage = round((eyeCenter + mouthPos)./2);
eyedist = round(abs(eyePos1 - eyePos2));
eye_mouth_dist = round(abs(eyeCenter - mouthPos));

xmin = max((eyeCenter(1) - eyedist(1)), 0);
xmax = xmin + 2 * eyedist(1);
ymin = max((eyeCenter(2)-(3/5 * eye_mouth_dist(2))), 0);
ymax = ymin + 11/5 * eye_mouth_dist(2);

width = xmax- xmin;
height = ymax - ymin;
cropped = imcrop(rotatedImage,[xmin ymin width height]);

cropped = imresize(cropped, [400, 250]);

face = rgb2gray(cropped);

end

