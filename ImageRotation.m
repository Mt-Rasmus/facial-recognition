function RImage = ImageRotation(OImage, center, degangle )
%FRotate Rotate an image around a given point
%   Everybody has to use this template
%
%% Who has done it
%
% Author: Anton Sterner, antst719
% Co-author: Rasmus Ståhl, rasst403
%
%% Syntax of the function
%
% Input arguments:  OImage original image
%                   center 2-vector with center point of the rotation 
%                       see the pdf for an definition of center
%                   degangle rotation angle in degrees, rotation is 
%                       clockwise
%
% Output arguments: RImage is the rotated image
%
% You MUST NEVER change the first line
%
%% Basic version control (in case you need more than one attempt)
%
% Version: 2
% Date: 6/11/2017
%
% Gives a history of your submission to Lisam.
% Version and date for this function have to be updated before each
% submission to Lisam (in case you need more than one attempt)
%
%% General rules
%
% 1) Don't change the structure of the template by removing %% lines
%
% 2) Document what you are doing using comments
%
% 3) Before submitting make the code readable by using automatic indentation
%       ctrl-a / ctrl-i
%
% 4) In case a task requires that you have to submit more than one function
%       save every function in a single file and collect all of them in a
%       zip-archive and upload that to Lisam. NO RAR, NO GZ, ONLY ZIP!
%       All non-zip archives will be rejected automatically
%
% 5) Often you must do something else between the given commands in the
%       template
%
%

%% Information about the image (size, type etc)
%       You can assume that it has uint8 pixels 
%       What should you do if this is not the case?
%
[sr,sc,nc] = size(OImage);

%% Generate coordinate vectors for the shifted coordinate system
% (this means converting the index vector for a pixel to the 
%   coordinate vector of the same pixel)
%
ir = [1:sr];%index vector for pixels along first Matlab dimension
ic = [1:sc];%same in the second direction

% NOTE: centerpoint is picked with ginput, so the x & y coords. are
% switched
cir = ir - center(1,2);%shifted ir vector so that center(1) is the origin
cic = ic - center(1,1);%Same for the second axis

%% Use cir and cic in meshgrid to generate a coordinate grid
%
[C,R] = meshgrid(cic, cir); % cir, cic

%% The polar mesh coordinates are computed with cart2pol
%
[Theta,Rho] = cart2pol(C,R); %

%% Convert the degress, modify the angles and 
%   transform back to Euclidean coordinates 
%   you may skip the next two lines and modify the input to pol2cart
%   if you want

rads = degangle*pi/180;% degs...

% clockwise rotion of mesh coords with desired angle
TNew = Theta-rads;% use Theta and degs

[nC,nR] = pol2cart(TNew, Rho); %

%% Compute the index vector from the coordinate vector inverting the 
% previous conversion from ir to cir and ic to cic

% NOTE: centerpoint is picked with ginput, so the x & y coords. are
% switched
newir = nR + center(1,2);

newic = nC + center(1,1);

%% Now use nearest neighbor interpolation (round) and rotate

 RImage = uint8(zeros(sr,sc,nc));
% 
% 

for k = 1:sr
    for l = 1:sc
        % setting pixels ouside image range to black
        if(newir(k,l) < 1 || newir(k,l) > sr)
            RImage(k,l) = 0;
       
        elseif(newic(k,l) < 1 || newic(k,l) > sc)
            RImage(k,l) = 0;
       
            % Filling RImage with new "rotated" pixel values
        else
            RImage(k,l) = OImage(uint32(round(newir(k,l))),uint32(round(newic(k,l))));
        end
        
    end
end

end
