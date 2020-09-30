clear variables
close all
clc

afile = './speech_samples/sentence.wav';

ainfo = audioinfo(afile);

fs = ainfo.SampleRate;

[x] = audioread(afile);
x = x / max(abs(x));

Tventana = 25e-3;               % window size (in seconds)
Nventana = ceil(fs*Tventana);   % window size (in samples)

stft(x,fs,Nventana)

