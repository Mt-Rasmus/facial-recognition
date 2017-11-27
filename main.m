%{

    TNM034 - Facial Recognition
    HT2017 - Link?ping University

    Process:
        1. Load image and color correct using Gray World Assumption
        2. Transform to YCbCr Color space
        3. Detect face and create face mask
        4. 

%}

%% Main 
clc;
clear;
close all;

% Read image from database
input = imread('images/DB1/db1_05.jpg');

% Color correct image
output = colorCorrection(input);
%output = refWhite(output);

figure
imshow(output);
title('Color corrected');

faceMask = detectFace(output);
figure
imshow(faceMask);

%Eye positions
[eyePos1, eyePos2] = eyeMap(output, faceMask);

%Mouth map and mouth position
[mouthmap, mouthPos] = mouthMap(output);

rotatedImage = face_orientation(output, eyePos1, eyePos2);

%Crop image
eyeCenter = round((eyePos1 + eyePos2)./2);
centerOfImage = round((eyeCenter + mouthPos)./2);

xmin = centerOfImage(1) - 125;
xmax = centerOfImage(1) + 125;
ymin = centerOfImage(2) - 200;
ymax = centerOfImage(2) + 150;

width = xmax- xmin;
height = ymax - ymin;

    
cropped = imcrop(rotatedImage,[xmin ymin width height]);

figure
imshow(cropped)