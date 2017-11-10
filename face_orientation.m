
% Author: Anton Sterner, antst719

% facial orientation adjustment, image and eye positions is input, returns scaled
% and rotated image
function [ rotatedimg ] = face_orientation( image, point1, point2 )

% mid point
midpoint = (point1 + point2)/2;


% angle between eyes
angle = -rad2deg(atan2(point2(2) - point1(2), point2(1) - point1(1))); 

% rotate image, works with grayscale images
% rotates image 'angle' degrees around the mid point, i.e. between the eyes
% should result in an image with 
rotatedimg = ImageRotation(image, point1, angle, point1, point2);
%imshow(rotatedimg);
%line([point1(1) point2(1)], [point1(2) point2(2)])

% show image with lines between eyes (TO ADD: and mouth)
%facetriangle(rotatedimg, point1, point2, midpoint);
% scale image 
% ADD CODE 

end