clear variables;
close all;

% Numero de bits
nb = 7;



% Importa el archivo como un vector de
[x, fs] = audioread('./audio_samples/bassoon.wav', 'native');

% Saca el menor valor del vector
xmin = min(x);
% Saca el mayor valor del vector
xmax = max(x);
% Saca la diferencia entre 0 y el máximo valor
xamp = max(abs(xmin), xmax);

display(xamp)

% Calcula la frecuencia de muestreo (2 * xamp) 
% luego la divide entre el numero de bits por muestra que elegimos
delta = 2 * xamp / (2^nb);

% Divide los valores del vector del audio entre la diferencia anterior
% cuantiza todo el archivo valor por valor.
xq = x / delta;

xrec = xq * delta;

player = audioplayer(xrec, fs);
player.play();