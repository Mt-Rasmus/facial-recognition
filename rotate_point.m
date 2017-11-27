
% Author: Anton Sterner, antst719

% facial orientation adjustment, image and eye positions is input, returns scaled
% and rotated image
function [ point2rotated ] = rotate_point(angle, point1, point2)

% rotate point2 'angle' degrees to follow the image
R = [cosd(angle) -sind(angle); sind(angle) cosd(angle)]; % rotation matrix
%%
point2translated = point2 - point1; % translate point2 to make point1 act as origin
point2rotated = R * transpose(point2translated); % rotation
%%
point2rotated = transpose(point2rotated) + point1; % translate back

end