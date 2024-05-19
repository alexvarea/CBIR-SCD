# CBIR-SCD
CBIR System implementing Scalable Color Descriptor
## SCD_5.m
Codi principal del projecte. Llegeix input.txt amb les query images i retorna un output.txt amb 10 candidats per cada imatge d'entrada.
## Descriptors.m
Script per generar la matriu "descriptors.mat".
Un cop generada, el sistema la carrega perquè no haguem de calcular-la cada cop que volguem utilitzar el sistema.
## Descriptors.mat
Matriu 2000x36 que emmagatzema els 36 coeficients de Haar dels histogrames de cada una de les 2000 imatges de la base de dades.
