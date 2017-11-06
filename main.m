%% main
clc;
clear;
close all;

input = imread('images/DB1/db1_05.jpg');
imshow(input);
hold on

%% Gray World Assumption
dim=size(input,3);
input=im2uint8(input);
output=zeros(size(input));    
if (dim==1 || dim==3)
    for j=1:dim
        scalVal=sum(sum(input(:,:,j)))/numel(input(:,:,j));
        output(:,:,j)=input(:,:,j)*(127.5/scalVal);
    end
    output=uint8(output);
else 
    error('myApp:argChk','Input error. Matrix dimensions do not fit.');
end

figure
imshow(output);

%% Face masking

[rows, cols] = size(input(:,:,1));
img = output;
% Color space transformation
imgYCbCr = rgb2ycbcr(input);
imgHSV = rgb2hsv(input);

imgCr = imgYCbCr(:,:,3);
imgCb = imgYCbCr(:,:,2);
imgH = imgHSV(:,:,1);
imgS = imgHSV(:,:,2);
imgV = imgHSV(:,:,3);

% 77?Cb?127 and 133?Cr?173
% 0?H?0.07 and 0.93?H?1 and 0.2?S?0.6 V?40
for row = 1:rows
    for col = 1:cols
        if (imgCr(row,col) < 133 || imgCr(row,col) > 173 && imgCb(row,col) < 77 || imgCb(row,col) >= 127 || imgH(row,col) > 0.07 && imgH(row,col) < 0.93)
           img(row,col,:) = 0;
        else 
            img(row,col,:) = 255;
        end
        %if (imgH(row,col) < 0.03 || imgH(row,col) > 0.09)  
         %   img(row,col,:) = 0;
        %else
         %   img(row,col,:) = 255;
        %end
    end
end

figure
imshow(img)

