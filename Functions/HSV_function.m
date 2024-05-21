function HSV_function = HSV_function(candidate_image)
%UNTITLED7 Summary of this function goes here
%   It returns an HSV histogram of the image "candidate_image"
levels_H = 15;
levels_S = 3;
levels_V = 3;
output_values_H = (0:levels_H);
output_values_SV = (0:levels_S);

% Convert candidate to HSV
HSV = rgb2hsv(candidate_image);
hImage = HSV(:, :, 1);
sImage = HSV(:, :, 2);
vImage = HSV(:, :, 3);

% Quantize candidate image
thresholds_H = multithresh(hImage, levels_H);
thresholds_S = multithresh(sImage, levels_S);
thresholds_V = multithresh(vImage, levels_V);

quantized_H = uint8(imquantize(hImage, thresholds_H, output_values_H));
quantized_S = uint8(imquantize(sImage, thresholds_S, output_values_SV));
quantized_V = uint8(imquantize(vImage, thresholds_V, output_values_SV));

% Combine quantized channels
I = 16 * quantized_H + 4 * quantized_V + quantized_S;
HSV_function = imhist(I);
end

