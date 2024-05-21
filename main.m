clear
clc;
User_root = 'C:\Users\alexv\OneDrive\Uni\3B\PIV\Prog02-20240422';
Database_path = 'C:\Users\alexv\OneDrive\Uni\3B\PIV\UKentuckyDatabase';
load('descriptors.mat','descriptors');
load('descriptors_HSV.mat','descriptors_HSV');

n_coeffs = 256;
%********************RWTextFiles*************************

% Data variables
Data_root      = '';
Input_filename = 'input.txt';
Output_filename= 'output.txt';
candidates     = 10;  % Number of candidates to retrieve
num_images = size(descriptors, 1);

% Read input file
fid = fopen(fullfile(User_root, Data_root, Input_filename), 'r');
input_images = textscan(fid, '%s');
fclose(fid);
input_images = input_images{1}; % Convert to cell array of strings

% Open output file for writing results
fid_out = fopen(fullfile(User_root, Data_root, Output_filename), 'w');

% Load candidates from input.txt
input_file = fullfile(User_root, 'input.txt');
fileID = fopen(input_file, 'r');
if fileID == -1
    error('No se pudo abrir el archivo input.txt');
end
candidate_files = textscan(fileID, '%s');
fclose(fileID);

% Initialize output file
output_file = fullfile(User_root, 'output.txt');
outputID = fopen(output_file, 'w');
if outputID == -1
    error('No se pudo abrir el archivo output.txt para escritura');
end

for i = 1:length(candidate_files{1})
    candidate_path = fullfile(Database_path, candidate_files{1}{i});
    candidate_image = imread(candidate_path);
    haar_vector = SCD_function(candidate_image,n_coeffs);
    HSV_vector = HSV_function(candidate_image);
    
    % Calculate distances
    distances = zeros(num_images, 1);
    for j = 1:num_images
%         distances(j) = mse_distance(haar_vector, descriptors(j, :),2); % Distancia con Haar
        distances(j) = mse_distance(HSV_vector', descriptors_HSV(j, :),2); % Distancia con histogramas HSV

    end
    
    % Find top candidates
    [~, sorted_indices] = sort(distances);
    top_indices = sorted_indices(1:candidates);
    
    % Write to output file
    fprintf(outputID, 'Retrieved list for query image %s\n', candidate_files{1}{i});
    resultats = cell(candidates, 1);
    for j = 1:candidates
        resultats{j} = strcat('ukbench', sprintf('%05d.jpg', top_indices(j)-1));
        fprintf(outputID, '%s\n', resultats{j});
    end
    fprintf(outputID, '\n');
    
    %***PRECISION AND RECALL CALCULATION***
    aciertos = 0;
    precission = 0;
    for j = 1:candidates
        index_ref = (floor(str2double(regexp(resultats{1}, '\d+', 'match'))/4))*4;
        % Get the name of the j-th image in resultats
        imagen_actual = resultats{j};
 
        % Extract the image number from the string and convert to number
        numero_imagen_actual = str2double(imagen_actual(end-8:end-4));
 
        % Check if the image number is within the expected range
        if numero_imagen_actual >= index_ref && numero_imagen_actual <= index_ref + 3
            aciertos = aciertos + 1; 
        end
        precission_matrix(i, j) = aciertos/j;
        recall_matrix(i, j) = aciertos*0.25;
    end
    precission = aciertos/candidates;
    fprintf('Precision for %s: %.2f\n', candidate_files{1}{i}, precission);
end

%Average precision and recall
average_precision = mean(precission_matrix);
average_recall = mean(recall_matrix);
f1 = 2 * (average_precision .* average_recall) / (average_precision + average_recall);
fprintf('F-score is %.2f\n', f1);

%Plot Precision-Recall graph
plot(average_recall, average_precision, '-o')
grid on;
ylim([0 1]);
xlim([0 1]);
xlabel('Recall');
ylabel('Precision');
title('Precision-Recall Curve')
fscore_str = "Fscore = "+ round(f1,2);
text(0.1,0.1,fscore_str)

fclose(outputID);
fclose('all');