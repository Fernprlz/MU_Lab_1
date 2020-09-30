clear variables;
close all;
%% 1. Input
% Numero de bits 
nb = 4;

% Adquisicion del audio
[x, fs] = audioread('./audio_samples/bassoon.wav', 'native');

% Numero de valores totales del vector de audio
N = length(x);

% Vector de diferencias entre elementos adyacentes
xdif = diff(x);

% Diferencia minima
xdif_min = min(xdif);
% Diferencia maxima
xdif_max = max(xdif);
% "Diferencia entre las diferencias", rango de valores
xdif_amp = max(abs(xdif_min), xdif_max);

%% Quantiser
% Doble del rango de valores / numero máximo de valores 
% que se pueden guardar y enviar. --- "cuantos bits le quito"
delta = 2 * xdif_amp / (2^nb);

% Crea un vector de 0's del tamaño del vector de audio con 
xrec = zeros(N, 1, 'int16');
% Se inicializa el vector de las predcciones igualando su 
% primer valor con el primer valor del vector original del audio
xpred(1) = x(1);
% Desde la siguiente posicion en ambos vectores...
for i = 2:N
    % Resta la prediccion al valor original
    res = x(i) - xpred;
    % Esta diferencia es cuantizada utilizando delta
    %% Inverse quantiser
    res_q = res / delta;
    % Se guarda en el vector del audio del receptor la suma entre la 
    % prediccion y el valor del decodificado.
    %% Entropy Decoder
    xrec(i) = xpred + res_q * delta;
    % Se guarda este valor en la variable de prediccion para la
    % siguiente iteración.
    %% Predictor
    xpred = xrec(i);
end

player = audioplayer(xrec, fs);
player.play();
