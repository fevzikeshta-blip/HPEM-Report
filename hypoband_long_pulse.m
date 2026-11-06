%% Hypoband long-pulse examples
% 1 GHz carrier, 60 us rectangular pulse, PRF = 1000 Hz.

clear; clc; close all;

%% Parameters
f0 = 1e9;                  % Carrier frequency (Hz)
A0 = 1;                    % Normalized amplitude
PW = 60e-6;                % Rectangular pulse width (s)
PRF = 1000;                % Pulse repetition frequency (Hz)

Trep = 1/PRF;              % Start-to-start interval: 1 ms
Toff = Trep - PW;          % Off time: 940 us
duty = PW/Trep;            % Duty cycle: 0.06
tStart = 10e-6;            % Start of isolated pulse for display

% 20 samples per carrier cycle for RF waveform plots
fs = 20*f0;
dt = 1/fs;

%% 1. Rectangular RF burst: time domain
t = 0:dt:80e-6;

envelope = double(t >= tStart & t < tStart + PW);
a = A0*envelope .* sin(2*pi*f0*(t-tStart));

figure('Color','w','Name','Long RF pulse: time domain', ...
       'Position',[100 100 1100 700]);

subplot(2,1,1);
plot(t*1e6,a,'b','LineWidth',0.5);
hold on;
plot(t*1e6,A0*envelope,'r','LineWidth',1.2);
plot(t*1e6,-A0*envelope,'r','LineWidth',1.2);
xlabel('Time (\mus)');
ylabel('Normalized amplitude');
title('1 GHz rectangular RF burst: pulse width = 60 \mus');
xlim([0 80]);
ylim([-1.2 1.2]);
grid on; box on;

% Show ten individual cycles near the start
subplot(2,1,2);
tZoom = (-2e-9):dt:(10e-9);
aZoom = A0*double(tZoom >= 0) .* sin(2*pi*f0*tZoom);

plot(tZoom*1e9,aZoom,'b','LineWidth',1.2);
xlabel('Time relative to pulse start (ns)');
ylabel('Normalized amplitude');
title('Enlarged leading edge: individual carrier oscillations');
xlim([-2 10]);
ylim([-1.2 1.2]);
grid on; box on;

%% 2. Analytical spectrum of ONE rectangular RF burst
% Fourier transform convention: integral a(t)*exp(-j*2*pi*f*t) dt


df = linspace(-100e3,100e3,40001);
f = f0 + df;

% Exact transform of a sine burst on 0 <= t <= PW
Sminus = sincNormalized((f-f0)*PW);
Splus  = sincNormalized((f+f0)*PW);

F = A0*PW/(2*1i) .* ( ...
    exp(-1i*pi*(f-f0)*PW).*Sminus ...
  - exp(-1i*pi*(f+f0)*PW).*Splus);

% Shift pulse start; this affects phase only
F = F .* exp(-1i*2*pi*f*tStart);
Fmag = abs(F);

figure('Color','w','Name','Single-pulse spectrum', ...
       'Position',[150 150 1100 500]);

plot(df/1e3,Fmag,'b','LineWidth',1.4);
hold on;

% For this integer-cycle burst, first nulls are f0 +/- 1/PW
nullOffset = 1/PW;
plot([-nullOffset nullOffset]/1e3,[0 0], ...
     'ro','MarkerFaceColor','r');

xlabel('Frequency offset from 1 GHz (kHz)');
ylabel('|A(f)| (s)');
title('Analytical spectrum of one 60 \mus rectangular RF burst');
xlim([-100 100]);
grid on; box on;
legend('Spectrum','First nulls','Location','northeast');

%% 3. Gaussian-modulated RF pulse
% Choose 60 us as the AMPLITUDE-envelope FWHM.
% Gaussian tails extend beyond the FWHM interval.
gaussianFWHM = 60e-6;
sigma = gaussianFWHM/(2*sqrt(2*log(2)));
tc = 100e-6;

tg = 0:dt:200e-6;

Genv = exp(-0.5*((tg-tc)/sigma).^2);
g = A0*Genv .* cos(2*pi*f0*(tg-tc));

figure('Color','w','Name','Gaussian RF pulse', ...
       'Position',[200 100 1100 700]);

subplot(2,1,1);
plot(tg*1e6,g,'b','LineWidth',0.5);
hold on;
plot(tg*1e6,A0*Genv,'r','LineWidth',1.4);
plot(tg*1e6,-A0*Genv,'r','LineWidth',1.4);

% Half-amplitude points
plot((tc + [-1 1]*gaussianFWHM/2)*1e6, ...
     [0.5 0.5]*A0,'ko','MarkerFaceColor','k');

xlabel('Time (\mus)');
ylabel('Normalized amplitude');
title('Gaussian RF pulse: amplitude-envelope FWHM = 60 \mus');
xlim([0 200]);
ylim([-1.2 1.2]);
grid on; box on;

subplot(2,1,2);
tgZoom = (-5e-9):dt:(5e-9);
gZoom = A0*exp(-0.5*(tgZoom/sigma).^2) ...
      .* cos(2*pi*f0*tgZoom);

plot(tgZoom*1e9,gZoom,'b','LineWidth',1.2);
xlabel('Time relative to Gaussian pulse centre (ns)');
ylabel('Normalized amplitude');
title('Carrier oscillations near the pulse centre');
xlim([-5 5]);
ylim([-1.2 1.2]);
grid on; box on;

%% 4. Rectangular pulse train: timing envelope
% Plot the envelope on a millisecond scale.
% The 1 GHz carrier exists inside each pulse but is not drawn here.

numberOfPulses = 4;

figure('Color','w','Name','Pulse train: 6 percent duty cycle', ...
       'Position',[250 200 1150 450]);
hold on;

for k = 0:numberOfPulses-1
    ts = k*Trep;

    % Filled rectangular envelope
    patch([ts ts ts+PW ts+PW]*1e3, ...
          [0 A0 A0 0], ...
          [0.25 0.55 1], ...
          'EdgeColor','b','FaceAlpha',0.7);

    % Zero baseline during off time
    plot([ts+PW ts+Trep]*1e3,[0 0],'b','LineWidth',1);
end

xlabel('Time (ms)');
ylabel('Normalized RF envelope');
title('60 \mus pulses: PRF = 1000 Hz, duty cycle = 6%');
xlim([-0.1 numberOfPulses*Trep*1e3]);
ylim([-0.05 1.25]);
xticks(0:1:numberOfPulses);
grid on; box on;

text(0.12,1.10,'Pulse width = 60 \mus');
text(1.12,1.10,'Start-to-start = 1 ms');
text(2.12,1.10,'Off time = 940 \mus');

%% Print calculated parameters
fprintf('Carrier frequency: %.2f GHz\n',f0/1e9);
fprintf('Pulse width: %.1f us\n',PW*1e6);
fprintf('PRF: %.0f Hz\n',PRF);
fprintf('Repetition interval: %.2f ms\n',Trep*1e3);
fprintf('Off time: %.1f us\n',Toff*1e6);
fprintf('Duty cycle: %.1f %%\n',100*duty);
fprintf('Carrier cycles per rectangular pulse: %.0f\n',f0*PW);
fprintf('First-null offsets: +/- %.3f kHz\n',nullOffset/1e3);
fprintf('Null-to-null bandwidth: %.3f kHz\n',2/PW/1e3);

%% Local function: normalized sinc, no toolbox needed
function y = sincNormalized(x)
    y = ones(size(x));
    nonzero = (x ~= 0);
    y(nonzero) = sin(pi*x(nonzero))./(pi*x(nonzero));
end
