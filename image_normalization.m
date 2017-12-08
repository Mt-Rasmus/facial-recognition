function [ cropped ] = image_normalization( input, eyePos1, eyePos2, mouthPos ) 

%Crop image
eyeCenter = round((eyePos1 + eyePos2)./2);
eyedist = round(abs(eyePos1 - eyePos2));
eye_mouth_dist = round(abs(eyeCenter - mouthPos));

% top left corner of cropped image
xmin = max((eyeCenter(1) - eyedist(1)), 0);
xmax = xmin + 2 * eyedist(1);
ymin = max((eyeCenter(2)-(3/5 * eye_mouth_dist(2))), 0);
ymax = ymin + 11/5 * eye_mouth_dist(2);

width = xmax- xmin;
height = ymax - ymin;
cropped = imcrop(input,[xmin ymin width height]);
cropped = imresize(cropped, [400, 250]);

end