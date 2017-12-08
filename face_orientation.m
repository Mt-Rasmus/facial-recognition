
% Author: Anton Sterner, antst719

% facial orientation adjustment, image and eye positions is input, returns scaled
% and rotated image
function [ rotatedimg ] = face_orientation( image, point1, point2 )

% angle between eyes
angle = -rad2deg(atan2(point2(2) - point1(2), point2(1) - point1(1))); 

% rotate image 'angle' degrees around 'point1', output is a grayscale images
rotatedimg = ImageRotation(image, point1, angle);

end