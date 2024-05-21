# CBIR-SCD
CBIR System implementing Scalable Color Descriptor using Haar transform with 32 coefficients and MSE distance to extract candidates.

# Carpetes
## Database descriptors generators
Aquí es troben els scripts "database_descriptors.m" i database_HSV_descriptors.m" que generen, en aquest ordre:
- **descriptors.mat** : Matriu 2000x256 que conté els 256 coeficients de Haar per a cada una de les 2000 imatges de la base de dades.
- **descriptors_HSV.mat**: Matriu 2000x256 que conté els 256 bins dels histogrames HSV de cada una de les 2000 imatges de la base de dades.
Un cop generades aquestes matrius, es guarden i posteriorment es carreguen al main del sistema.

## Functions
### Haarmtx.m
Funció per calcular els coeficients de Haar dels histogrames de les imatges.
### Mse_distance.m
Funció per calcular la distància amb Mean Square Error. És la que utilitzem actualment per extreure candidats.
### SDC_function.m
Calcula el descriptor SCD d'histograma per a una imatge candidata donada. Aquesta funció depèn de la funció de generació de matriu Haar'haarmtx.m'.
### HSV_function.m
Retorna un histograma HSV de la imatge resultant de combinar els 3 canals quantitzats.

## main.m
Codi principal del projecte. Llegeix input.txt amb les query images i retorna un output.txt amb 10 candidats per cada imatge d'entrada.
