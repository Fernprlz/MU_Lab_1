
function stft_env(s,fs,M,NFFT,O)

% Compute the Short Time Fourier Transform of the signal s(n), where:
% NFFT is the number of FFT points for each window
% NFFT is , by default, the length of the window w.
% Opcionally, some overlapping between consecutive windows can be included.
% The default overlapping is 0.5 * (window length).

figure
L = length(s);
Lt = L-M;
disp('Press any key to watch the next frame...');

if nargin == 3
    NFFT = 2*M;
end

if nargin > 4
    O = round(M*O);
else
    O = round(M/2); 
end

% Order of the LPC filter
N = 10;

% Window
w = hamming(M);

for n = 1:(M-O):Lt
 
    subplot(3,1,1)
    hold off
    plot([1:L] / fs, s)
    title('Speech signal');
    hold on
    aux = zeros(size(s));
    aux(n:M+n-1) = w;
    plot([1:L] / fs, aux*max(s),'g')
    xlabel('Time (s)');
    
    cur_w = s(n:n+M-1) .* w;
    
    subplot(3,1,2)
    hold off
    plot([1:M] / fs, cur_w)
    title('Windowed signal in time domain');
    xlabel('Time (s)');

    subplot(3,1,3)
    
    % Calcula los coeficientes LPC
    c = xcorr(cur_w, cur_w, N);
    [a, e] = levinson(c(N+1:2*N+1));
    a = a(:);

    % Visualiza la transformada de la ventana con sus LPC
    h = freqz(1, a, NFFT, 'whole');
    spec_w = fft(cur_w, NFFT);
    frecuencias = linspace(0, fs/2, NFFT/2+1);
    plot(frecuencias, 20*log10(abs(spec_w(1:NFFT/2+1))));
    hold on;
    plot(frecuencias,20*log10(e*abs(h(1:NFFT/2+1))), 'r');
    hold off;
    title('Modulus of the FT of the windowed signal');
    xlabel('Frequency (Hz)');
    
    pause
end
