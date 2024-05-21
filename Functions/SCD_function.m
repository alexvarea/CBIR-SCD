function SCD_function = SCD_function(candidate_image, haar_coeffs)
%SCD_FUNCTION Computes the histogram descriptor of an image using Haar wavelet transformation
%   SCD_FUNCTION(candidate_image, haar_coeffs) calculates the histogram descriptor
%   for a given candidate image. This function depends on the Haar matrix generation
%   function 'haarmtx.m'.
%
%   Inputs:
%     candidate_image - HSV image to be processed.
%     haar_coeffs - Number of Haar coefficients to extract from the histogram.
%
%   Outputs:
%     SCD_function - Histogram descriptor of the candidate image.
%
%   Detailed explanation:
%     1. Convert the candidate image from RGB to HSV color space.
%     2. Quantize the HSV channels separately.
%     3. Combine the quantized channels into a single index image.
%     4. Apply non-linear compression to the combined index image.
%     5. Compute the histogram of the compressed image.
%     6. Apply Haar wavelet transformation to the histogram.
%     7. Quantize the transformed histogram and extract the specified number
%        of Haar coefficients as the image descriptor.
%
%   Note:
%     This function requires the 'haarmtx.m' file for generating the Haar matrix.
%
%   See also: HAARMTX, RGB2HSV, IMQUANTIZE, IMHIST, MULTITHRESH

levels_H = 15;
levels_S = 3;
levels_V = 3;
output_values_H = (0:levels_H);
output_values_SV = (0:levels_S);
Hmtx = haarmtx(256);

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

%distancia(imhist(I),base_dades_histogrames) battacharyya amb 256 bins

% Non-linear Compression
gamma = 1;
compressed_I = uint8(256 * (double(I) / 256).^gamma);

% Calculate Histogram
hist_compressed_I = imhist(compressed_I);

% Haar Transform
H_hist = Hmtx * hist_compressed_I;

%quantitzar sortida Haar
levels_H_hist = 16;
output_values_H_hist = (0:levels_H_hist);
thresholds_H_hist = multithresh(H_hist,levels_H_hist);
H_hist_quantized = imquantize(H_hist,thresholds_H_hist,output_values_H_hist); %IMPORTANTE, HE ESCOGIDO 16 ARBITRARIAMENTE. podría cuantizar redondeando

% Extract lower-resolution histogram (haar_coeffs coefficients, i.e. 32, 256...)
%candidate_descriptor = H_hist_quantized(1:haar_coeffs)';
SCD_function = H_hist(1:haar_coeffs)';

end

