%% Main 
clc;
clear;
close all;

% Read image from database
input = imread('images/DB1/db1_09.jpg');
%imshow(input);
%title('Original');

% Color correct image
output = colorCorrection(input);
output = refWhite(output);
   
figure
imshow(output);
title('Color corrected');

% Face masking
facemask = detectFace(output);

figure
imshow(facemask);
title('Binary face mask without morphing')

