
%%% Mouth map %%%
% returning the mouth map (mm) and
% the center of the mouth (mc).

function [mm, mc] = mouthMap(I)

IYCbCr = rgb2ycbcr(I);

ICr = double(IYCbCr(:,:,3));
ICb = double(IYCbCr(:,:,2));

n =  0.95 * (mean2((ICr).^2)) / mean2(ICr./ICb);

mm = (ICr.^2) .* ((ICr.^2)-n.*(ICr./ICb)).^2;

mmNormalized = 255.*mm./max(max(mm)); 

mm = uint8(mmNormalized);

r = 20;
SE = strel('sphere', r); % spherical structuring element

mm = imdilate(mm,SE); % DIALATION:
%mm = imerode(mm,SE); % EROSION

[rows, cols] = size(mm);

for row = 1:rows
    for col = 1:cols
        if(mm(row,col) > 150)
            mm(row,col) = 255;
        else
            mm(row,col) = 0;
        end
    end
end

BW = im2bw(mm, 0); % BinaryImage
mm = bwareafilt(BW,1); % Selecting largest object of image

% centroid is the center of an object in an image
labeledImage = bwlabel(mm);
measurements = regionprops(labeledImage, 'Centroid');
centroid = measurements.Centroid;
centroid = round(centroid);
mc = centroid; % mc is the mouth center coordinate (centroid).

I(mc(2),mc(1),:) = 255;


