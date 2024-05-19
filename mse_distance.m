function mse_distance = mse_distance(query_hist, image_hist)
    % Calcula la distancia de error cuadrático medio (MSE) entre dos histogramas
    
    % Parámetros:
    %   - query_hist: histograma de consulta (1x32)
    %   - image_hist: histograma de imagen (1x32)
    % Devuelve:
    %   - mse_distance: distancia MSE entre los dos histogramas
    
    % Calcular la distancia MSE
    mse_distance = mean((query_hist - image_hist).^2);
end
