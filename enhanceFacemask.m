function [ output_binary ] = enhanceFacemask( input_binary )
% Morphological operations to enhance binary mask

%numberOfHoles = bweuler(facemask)

diskSize = 20;
kernel = strel('disk', diskSize);
faceMask = imclose(input_binary, kernel);

diskSize = 4;
kernel = strel('disk', diskSize);
faceMask = imopen(faceMask, kernel);

diskSize = 20;
kernel = strel('disk', diskSize);
faceMask = imclose(faceMask, kernel);

output_binary = imfill(faceMask,'holes');

%figure
%imshow(output_binary);
%title('face mask with morphing')

end

