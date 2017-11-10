function EM = eyeMap(Im)

image = im2uint8(Im);

ycbcrmap = rgb2ycbcr(image);

Y = ycbcrmap(:,:,1);
Cb = ycbcrmap(:,:,2);
Cr = ycbcrmap(:,:,3);

normCb = double(Cb)./max(max(double(Cb)));
normCbPow = power(normCb,2);
CbPow = normCbPow.*255;

%CbPow = power(Cb,2);
CrNeg = 255 - Cr;
normCrNeg = double(CrNeg)./max(max(double(CrNeg)));
CrNegPow = power(normCrNeg,2);
CrNegPow = CrNegPow .*255;

CbDivCr = double(Cb)./double(Cr);

eyeMapC = (1/3).*CbPow + (1/3).* CrNegPow + (1/3).*CbDivCr;

SE = strel('sphere',10);

erosion = imerode(Y,SE);
dilation = imdilate(Y,SE);

eyeMapL = double(dilation)./double(erosion + 1);

eyeMapLN = double(eyeMapL)./max(max(double(eyeMapL)));

eyeMapLFinal = eyeMapLN.*255;

eyeMapFinal = imfuse(eyeMapLFinal, eyeMapC, 'blend');

%eyeMapFinal = imdilate(eyeMapFinal, SE);



%imshow(uint8(eyeMapFinal));







EM = uint8(eyeMapFinal);


end