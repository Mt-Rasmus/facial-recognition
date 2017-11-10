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
input = imread('images/DB1/db1_10.jpg');

% Color correct image
output = colorCorrection(input);
%output = refWhite(output);

figure
imshow(output);
title('Color corrected');

% Face masking
facemask = detectFace(output);

figure
imshow(facemask);
title('Face mask with morphing')

