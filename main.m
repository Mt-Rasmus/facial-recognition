%{
%
%    TNM034 - Facial Recognition
%    HT2017 - Link?ping University
%
%    Process:
%        1. Load image and color correct using Gray World Assumption
%        2. Transform to YCbCr Color space
%        3. Detect face and create face mask
%        4. 
%
%}

%% Create database with eigenfaces

clc;
clear;
images_folder = 'images/TestDB';
createDatabase(images_folder);

%% Read face image and check if face exists in database

 clc;
 clear;
 tic
 image_name = 'images/DB1/db1_05.jpg'; %db1_03 g?r inte att detecta
 im = imread(image_name);
 [ id ] = tnm034(im);
 toc

% id > 0  =>  face exists in database
% id = 0  =>  face does not exists in database
% id = -1 =>  face could not get detected


%% OLD MAIN 
clc;
clear;
close all;

% Read image from database
input = imread('images/DB1/db1_02.jpg');

% Color correct image
output = colorCorrection(input);
%output = refWhite(output);

%figure
%mshow(output);
%title('Color corrected');
tic
face = detectFace(output);
toc
figure
imshow(face);

%Eye positions
%[eyePos1, eyePos2] = eyeMap(output, faceMask);

%Mouth map and mouth position
%[mouthmap, mouthPos] = mouthMap(output);

%rotatedImage = face_orientation(output, eyePos1, eyePos2);

%Crop image
%eyeCenter = round((eyePos1 + eyePos2)./2);
%centerOfImage = round((eyeCenter + mouthPos)./2);

%xmin = centerOfImage(1) - 125;
%xmax = centerOfImage(1) + 125;
%ymin = centerOfImage(2) - 200;
%ymax = centerOfImage(2) + 150;

%width = xmax- xmin;
%height = ymax - ymin;
%cropped = imcrop(rotatedImage,[xmin ymin width height]);

%figure
%imshow(cropped)

