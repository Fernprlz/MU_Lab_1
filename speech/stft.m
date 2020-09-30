
function stft(s,fs,M,NFFT,O)

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

% Ventana
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
    
    % Visualiza la transformada de la ventana
    spec_w = fft(cur_w, NFFT);
    frecuencias = linspace(0, fs/2, NFFT/2+1);
    plot(frecuencias, 20*log10(abs(spec_w(1:NFFT/2+1))));
    title('Modulus of the FT of the windowed signal');
    xlabel('Frequency (Hz)');
    
    pause
end
