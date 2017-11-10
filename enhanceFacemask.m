function [ output_binary ] = enhanceFacemask( input_binary )
% Morphological operations to enhance binary mask

%numberOfHoles = bweuler(facemask)

diskSize = 35;
kernel = strel('square', diskSize);
faceMask = imerode(input_binary, kernel);

faceMask = imdilate(faceMask, strel('disk', 4));

%{
faceMask = imclose(input_binary, kernel);

diskSize = 5;
kernel = strel('disk', diskSize);
faceMask = imopen(faceMask, kernel);

diskSize = 20;
kernel = strel('disk', diskSize);
faceMask = imclose(faceMask, kernel);

%}


output_binary = imfill(faceMask,'holes');

%figure
%imshow(output_binary);
%title('face mask with morphing')

end

