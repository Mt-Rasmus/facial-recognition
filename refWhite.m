
function Irw = refWhite(I)

%I = imread(Im);

hsv = rgb2hsv(I); % First, convert it to HSI space
v = hsv(:,:,3); %get the illuminance channel
meanGray = 255*mean2(v);

redChannel = I(:, :, 1);
greenChannel = I(:, :, 2);
blueChannel = I(:, :, 3);

meanR = mean2(redChannel);
meanG = mean2(greenChannel);
meanB = mean2(blueChannel);

% Make all channels have the same mean
redChannel = uint8(double(redChannel) * meanGray / meanR);
greenChannel = uint8(double(greenChannel) * meanGray / meanG);
blueChannel = uint8(double(blueChannel) * meanGray / meanB);

% Recombine separate color channels into a single, true color RGB image.
I = cat(3, redChannel, greenChannel, blueChannel);
Irw = I;

end