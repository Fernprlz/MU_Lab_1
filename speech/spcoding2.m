clear variables
close all
clc

afile = './speech_samples/m_oo.wav';

ainfo = audioinfo(afile);

fs = ainfo.SampleRate;

[x] = audioread(afile);
x = x / max(abs(x));

wsize = 50e-3;               % window size (in seconds)
Nwindow = ceil(fs*wsize);   % window size (in samples)

stft_env(x,fs,Nwindow)
