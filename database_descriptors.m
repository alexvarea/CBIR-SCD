%Compute descriptors
%Aquest script fa la transformada de Haar de cada una de les imatges de la
%database i les emmagatzema en la matriu "descriptors.mat".

Database_path = 'C:\Users\alexv\OneDrive\Uni\3B\PIV\UKentuckyDatabase';


% 2. Parameters for HSV quantization
levels_H = 15;
levels_S = 3;
levels_V = 3;
output_values_H = (0:levels_H);
output_values_SV = (0:levels_S);

% 3. Loop through the image database
num_images = 2000;  % Number of images in the database
descriptors = zeros(num_images, 32);  % Preallocate space for descriptors

%CALCULATE HAAR COEFFICIENTS AND SAVE THEM IN "descriptors.m" MATRIX. Només
%ho hem de fer un cop, perquè guardem la matriu.
for img_idx = 0:num_images-1
    % Construct image file name
    img_name = sprintf('ukbench%05d.jpg', img_idx);
    img_path = fullfile(Database_path, img_name);
    
    % 4. Read Image
    image = imread(img_path);

    % 5. Convert to HSV
    HSV = rgb2hsv(image);
    hImage = HSV(:, :, 1);
    sImage = HSV(:, :, 2);
    vImage = HSV(:, :, 3);

    % 6. Quantization
    thresholds_H = multithresh(hImage, levels_H);
    thresholds_S = multithresh(sImage, levels_S);
    thresholds_V = multithresh(vImage, levels_V);

    quantized_H = uint8(imquantize(hImage, thresholds_H, output_values_H));
    quantized_S = uint8(imquantize(sImage, thresholds_S, output_values_SV));
    quantized_V = uint8(imquantize(vImage, thresholds_V, output_values_SV));

    % 7. Combine quantized channels
    I = 16 * quantized_H + 4 * quantized_V + quantized_S;

    % 8. Non-linear Compression
    gamma = 1;
    compressed_I = uint8(256 * (double(I) / 256).^gamma);

    % 9. Calculate Histogram
    hist_compressed_I = imhist(compressed_I);

    % 10. Haar Transform
    Hmtx = haarmtx(256);
    H_hist = Hmtx * hist_compressed_I;

    % 11. Extract lower-resolution histogram
    H_hist_small = H_hist(1:32);
    descriptors(img_idx+1, :) = H_hist_small';
end


%Save descriptors for future use
save('descriptors.mat', 'descriptors');
%#####################################