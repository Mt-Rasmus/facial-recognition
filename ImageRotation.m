function RImage = ImageRotation(OImage, rotationPoint, degangle)
%FRotate Rotate an image around a given point
% 
%% Who has done it
%
% Author: Anton Sterner, antst719
% Co-author: Rasmus Ståhl, rasst403
% Developed from a template used in the course TNM087 Bildbehandling och bildanalys
%% Syntax of the function
%
% Input arguments:  OImage original image
%                   center 2-vector with center point of the rotation 
%                   degangle rotation angle in degrees, rotation is clockwise
%
% Output arguments: RImage is the rotated image
%
%% Information about the image (size, type etc)
%
[sr,sc,nc] = size(OImage);

%% Generate coordinate vectors for the shifted coordinate system
% (this means converting the index vector for a pixel to the 
%   coordinate vector of the same pixel)
%
ir = [1:sr];%index vector for pixels along first Matlab dimension
ic = [1:sc];%index vector for pixels in the second direction

% NOTE: centerpoint is picked with ginput, so the x & y coords. are
% switched
cir = ir - rotationPoint(1,2);%shifted ir vector so that center(1) is the origin
cic = ic - rotationPoint(1,1);%Same for the second axis

%% Use cir and cic in meshgrid to generate a coordinate grid
%
[C,R] = meshgrid(cic, cir); % cir, cic

%% The polar mesh coordinates are computed with cart2pol
%
[Theta,Rho] = cart2pol(C,R); %

%% Convert the degress, modify the angles and 
%   transform back to Euclidean coordinates 

rads = degangle*pi/180;% radians...

% clockwise rotion of mesh coords with desired angle
TNew = Theta-rads;% use Theta and rads

[nC,nR] = pol2cart(TNew, Rho); %

%% Compute the index vector from the coordinate vector inverting the 
% previous conversion from ir to cir and ic to cic

% NOTE: centerpoint is picked with ginput, so the x & y coords. are
% switched
newir = nR + rotationPoint(1,2);

newic = nC + rotationPoint(1,1);

%% Now use nearest neighbor interpolation (round) and rotate

 RImage = uint8(zeros(sr,sc,nc));

for k = 1:sr
    for l = 1:sc
        % setting pixels ouside image range to black
        if(newir(k,l) < 1 || newir(k,l) > sr)
            RImage(k,l,:) = 0;
       
        elseif(newic(k,l) < 1 || newic(k,l) > sc)
            RImage(k,l,:) = 0;
       
            % Filling RImage with new "rotated" pixel values
        else
            %RImage = interplmg(OImage, [newir(k,l), newic(k,l)], true);
            RImage(k,l,:) = OImage(uint32(round(newir(k,l))),uint32(round(newic(k,l))));
        end
        
    end
end

end
