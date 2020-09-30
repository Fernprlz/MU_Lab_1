clear variables;
close all;

nb = 10;

[x, fs] = audioread('./audio_samples/bassoon.wav', 'native');

xmin = min(x);
xmax = max(x);
xamp = max(abs(xmin), xmax);

delta = 2 * xamp / (2^nb);

xq = x / delta;

xrec = xq * delta;

player = audioplayer(xrec, fs);
player.play();