clc;

% 1. Define User_root and Database path
User_root = 'C:\Users\alexv\OneDrive\Uni\3B\PIV\Prog02-20240422';
Database_path = 'C:\Users\alexv\OneDrive\Uni\3B\PIV\UKentuckyDatabase';
load('descriptors.mat','descriptors');

%********************RWTextFiles*************************

% Data variables
Data_root      = '';
Input_filename = 'input.txt';
Output_filename= 'output.txt';
Candidates     = 10;  % Number of candidates to retrieve
 
% Read input file
fid = fopen(fullfile(User_root, Data_root, Input_filename), 'r');
input_images = textscan(fid, '%s');
fclose(fid); 
input_images = input_images{1}; % Convert to cell array of strings
% Open output file for writing results
fid_out = fopen(fullfile(User_root, Data_root, Output_filename), 'w');
%**************************************************************************

% 2. Parameters for HSV quantization
levels_H = 15;
levels_S = 3;
levels_V = 3;
output_values_H = (0:levels_H);
output_values_SV = (0:levels_S);

num_images = 2000;  % Number of images in the database
%descriptors = zeros(num_images, 32);  % Preallocate space for descriptors


num_images = size(descriptors, 1);  % Number of images in the database
% Haar Transform Matrix
Hmtx = haarmtx(256);

% Load candidates from input.txt
input_file = fullfile(User_root, 'input.txt');
fileID = fopen(input_file, 'r');
if fileID == -1
    error('No se pudo abrir el archivo input.txt');
end
candidate_files = textscan(fileID, '%s');
fclose(fileID);

% Number of candidates to find for each input image
candidates = 10;

% Initialize output file
output_file = fullfile(User_root, 'output.txt');
outputID = fopen(output_file, 'w');
if outputID == -1
    error('No se pudo abrir el archivo output.txt para escritura');
end

for i = 1:length(candidate_files{1})
    candidate_path = fullfile(Database_path, candidate_files{1}{i});
    candidate_image = imread(candidate_path);
    
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
    
    % Non-linear Compression
    gamma = 1;
    compressed_I = uint8(256 * (double(I) / 256).^gamma);
    
    % Calculate Histogram
    hist_compressed_I = imhist(compressed_I);
    
    % Haar Transform
    H_hist = Hmtx * hist_compressed_I;
    
    % Extract lower-resolution histogram
    candidate_descriptor = H_hist(1:32)';
    
    % Calculate distances
    distances = zeros(num_images, 1);
    for j = 1:num_images
        distances(j) = mse_distance(candidate_descriptor, descriptors(j, :));
    end
    
    % Find top candidates
    [~, sorted_indices] = sort(distances);
    top_indices = sorted_indices(1:candidates);
    
    % Write to output file
    fprintf(outputID, 'Retrieved list for query image %s\n', candidate_files{1}{i});
    for j = 1:candidates
        fprintf(outputID, 'ukbench%05d.jpg\n', top_indices(j)-1);
    end
    fprintf(outputID, '\n');
end

fclose(outputID);


