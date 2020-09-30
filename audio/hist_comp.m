clear variables;
close all;

[x, fs] = audioread('./audio_samples/bassoon.wav')
N = length(x);

xmin = min(x);
xmax = max(x);

xdif = diff(x);

edges = linspace(xmin, xmax, 100);

figure(1);
subplot(1, 2, 1);
histogram(x, edges);
title('Amplitude values');

subplot(1, 2, 2);
histogram(xdif, edges);
title('Residual');