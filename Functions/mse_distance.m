function mse_distance = mse_distance(query_hist, image_hist, n)
    % Calcula la distancia de error cuadrático medio (MSE) entre dos histogramas
    
    % Parámetros:
    %   - query_hist: histograma de consulta 
    %   - image_hist: histograma de imagen 
    %   - n: exponente del MSE
    % Devuelve:
    %   - mse_distance: distancia MSE entre los dos histogramas
    
    % Calcular la distancia MSE
    mse_distance = mean((query_hist - image_hist).^2);
end
