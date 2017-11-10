function [ output ] = colorCorrection( input )
% Color correct original image with gray world assumption

% Init output image with same size as input image
output = uint8(zeros(size(input,1), size(input,2), size(input,3)));

% Components of the input image
R = input(:,:,1);
G = input(:,:,2);
B = input(:,:,3);

% Inverse of the average values of the R,G,B components
mR = 1/(mean(mean(R)));
mG = 1/(mean(mean(G)));
mB = 1/(mean(mean(B)));

%Smallest Avg Value (max because we are dealing with the inverses)
maxRGB = max(max(mR, mG), mB);

%Calculate the scaling factors
mR = mR/maxRGB;
mG = mG/maxRGB;
mB = mB/maxRGB;

%Scale the values
output(:,:,1) = R*mR;
output(:,:,2) = G*mG;
output(:,:,3) = B*mB;

end

