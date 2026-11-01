%% Electric-field amplitude spectra
% Each array contains:
% Column 1: time in milliseconds
% Column 2: electric field in V/m
%
% These spectra are approximate because the data were
% extracted from images, not the original recordings.

datasets = {figure4_field, figure8_field};

names = { ...
    'stroke electric-field spectrum', ...
    'bipolar electric-field spectrum'};

for k = 1:2

    %% Read electric-field data
    data = datasets{k};

    t = data(:,1)*1e-3;       % Convert milliseconds to seconds
    E = data(:,2);           % Electric field in V/m

    % Sort samples and remove duplicate times
    [t, order] = sort(t);
    E = E(order);
    [t, index] = unique(t);
    E = E(index);

    t = t-t(1);              % Start time at zero

    %% Create a uniformly spaced time vector for the FFT
    dt_image = median(diff(t));

    N = round((t(end)-t(1))/dt_image)+1;
    tu = linspace(t(1), t(end), N).';
    Eu = interp1(t, E, tu, 'linear');

    dt = tu(2)-tu(1);
    Fs = 1/dt;

    %% Approximate continuous Fourier transform
    % E_spectrum(f) ≈ dt * FFT(E)
    %
    % Units:
    % (V/m)*s = (V/m)/Hz
    %
    % Zero-padding makes the plotted frequency grid finer.
    % It does not add information or improve true resolution.

    Nfft = 2^nextpow2(4*N);

    E_FT = dt*fft(Eu, Nfft);

    % Retain positive frequencies, excluding DC for log axes
    indexPositive = (1:floor(Nfft/2)).';

    f = indexPositive*Fs/Nfft;
    spectrumMagnitude = abs(E_FT(indexPositive+1));

    % No factor of 2: this is |Fourier transform| at f > 0,
    % not a doubled one-sided sinusoidal amplitude spectrum.

    %% Plot the spectral curve
    valid = spectrumMagnitude > 0;

    figure('Color','w');

    loglog(f(valid), spectrumMagnitude(valid), ...
           'b', 'LineWidth',1.3);

    xlabel('Frequency (Hz)');
    ylabel('|{E}(f)| ((V/m)/Hz)', ...
           'Interpreter','tex');

    title(names{k});
    grid on;
    box on;

    % Avoid emphasizing frequencies below the record's
    % approximate resolving capability.
    xlim([1/(N*dt), Fs/2]);

    fprintf('\n%s\n', names{k});
    fprintf('Image-derived time spacing: %.3f us\n', dt*1e6);
    fprintf('Approximate frequency resolution: %.2f kHz\n', ...
            1/(N*dt)/1e3);
    fprintf('Image-sampling Nyquist frequency: %.3f MHz\n', ...
            Fs/2/1e6);
end