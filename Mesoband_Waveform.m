%% Mesoband waveform and spectrum: reproduce the book's graphs
% No additional toolboxes required.
clear; clc; close all;

%% Parameters inferred from the book's graphs
f0    = 1e9;              % Sinusoidal frequency: 1 GHz
w0    = 2*pi*f0;          % Angular frequency (rad/s)
alpha = 1e8;              % Damping coefficient (1/s)

%% Figure (a): Normalized time-domain waveform
t = linspace(0, 15e-9, 15001);

ep = exp(-alpha*t);       % Upper envelope
em = -ep;                % Lower envelope
En = ep .* sin(w0*t);     % Normalized field E(t)/E0

figure('Color','w','Position',[150 150 780 480]);

h1 = plot(t*1e9, ep, 'r:', 'LineWidth',1.5);
hold on;
h2 = plot(t*1e9, em, 'r--','LineWidth',1.3);
h3 = plot(t*1e9, En, 'b-', 'LineWidth',1.1);

xlabel('Time (ns)');
ylabel('E(t)/E_0');
title('(a) Mesoband damped sinusoidal pulse');

legend([h1 h2 h3], ...
    {'e_p(t) = exp(-\alpha t)', ...
     'e_m(t) = -exp(-\alpha t)', ...
     'E(t)/E_0 = exp(-\alpha t) sin(\omega_0 t)'}, ...
    'Location','northeast');

xlim([0 15]);
ylim([-1 1]);
xticks(0:1:15);
yticks(-1:0.5:1);

grid on; box on;
set(gca,'FontSize',12);

%% Figure (b): Normalized analytical spectrum
f = linspace(0.5e9, 1.5e9, 50001);
w = 2*pi*f;

% |E_tilde(f)| / E0
Sn = w0 ./ sqrt((alpha^2 + w0^2 - w.^2).^2 ...
                + 4*alpha^2*w.^2);

% Exact spectral peak for w0 > alpha
wPeak = sqrt(w0^2-alpha^2);
fPeak = wPeak/(2*pi);
Smax  = 1/(2*alpha);

% Exact 3 dB frequencies for these parameters
% At these points, spectral magnitude = peak/sqrt(2)
fL3 = sqrt(w0^2-alpha^2-2*alpha*w0)/(2*pi);
fH3 = sqrt(w0^2-alpha^2+2*alpha*w0)/(2*pi);

S3dB = Smax/sqrt(2);
BW3  = fH3-fL3;

figure('Color','w','Position',[200 200 780 480]);

hS = plot(f, Sn, 'b', 'LineWidth',1.3);
hold on;

hP = plot([fL3 fH3], [S3dB S3dB], 'ro', ...
    'MarkerFaceColor','r','MarkerSize',6);

% Short horizontal line connecting the 3 dB points
plot([fL3 fH3], [S3dB S3dB], 'r--', ...
    'LineWidth',1,'HandleVisibility','off');

xlabel('Frequency (Hz)');
ylabel('|E(f)|/E_0 (s)');
title('(b) Mesoband analytical spectrum');

legend([hS hP], {'Spectrum','Lower and upper 3 dB points'}, ...
    'Location','northeast');

xlim([0.5e9 1.5e9]);
ylim([0 5e-9]);

xticks([0.5 0.75 1 1.25 1.5]*1e9);
yticks((0:1:5)*1e-9);

grid on; box on;
set(gca,'FontSize',12);

%% Print results
fprintf('Sinusoidal frequency: %.3f GHz\n', f0/1e9);
fprintf('Cycle period: %.2f ns\n', 1e9/f0);
fprintf('Cycles in the 15 ns display: %.0f\n', f0*15e-9);
fprintf('Envelope at 15 ns: %.4f\n', exp(-alpha*15e-9));
fprintf('Spectral peak frequency: %.3f MHz\n', fPeak/1e6);
fprintf('Normalized spectral peak: %.3e s\n', Smax);
fprintf('Lower 3 dB frequency: %.3f MHz\n', fL3/1e6);
fprintf('Upper 3 dB frequency: %.3f MHz\n', fH3/1e6);
fprintf('3 dB bandwidth: %.3f MHz\n', BW3/1e6);

%% Figure (c): Mesoband pulse train
PRF  = 1000;                % Pulses per second
Trep = 1/PRF;               % 1 ms between pulse starts
Np   = 5;                  % Number of pulses displayed

% Resolve individual oscillations without sampling entire millisecond gaps
dt = 1/(200*f0);            % 200 samples per cycle
tLocal = 0:dt:200e-9;

% Normalized waveform of one pulse
pulse = exp(-alpha*tLocal).*sin(w0*tLocal);

figure('Color','w','Position',[250 150 900 650]);

subplot(2,1,1);
hold on;

for k = 0:Np-1
    tStart = k*Trep;

    % Actual damped oscillations
    plot((tStart+tLocal)*1e3, pulse, ...
         'b','LineWidth',1.1);

    % Neglect the extremely small remaining tail
    plot([tStart+tLocal(end), (k+1)*Trep]*1e3, ...
         [0 0], 'b','LineWidth',1);
end

xlabel('Time (ms)');
ylabel('E(t)/E_0');
title('Mesoband pulse train: PRF = 1 kHz');
xlim([-0.2 Np*Trep*1e3]);
ylim([-1.1 1.1]);
xticks(0:Np);

grid on; box on;
set(gca,'FontSize',12);

%% Enlarged view of one pulse
subplot(2,1,2);

plot(tLocal*1e9, pulse, 'b','LineWidth',1.1);
hold on;
plot(tLocal*1e9,  exp(-alpha*tLocal), 'r--');
plot(tLocal*1e9, -exp(-alpha*tLocal), 'r--');

xlabel('Time relative to pulse start (ns)');
ylabel('E(t)/E_0');
title('Enlarged view of one mesoband pulse');
xlim([0 50]);
ylim([-1.1 1.1]);

grid on; box on;
set(gca,'FontSize',12);