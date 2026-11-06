%% Reproduce the 20-cycle RF burst and its analytical spectrum
% A 20 ns burst delayed by 1 ns ends at 21 ns.
clear; clc; close all;

%% Parameters
f0  = 1e9;                 % Carrier frequency: 1 GHz
T   = 1/f0;                % One cycle: 1 ns
N   = 20;                  % Number of complete cycles (positive integer)
D   = N*T;                 % Burst duration: 20 ns
tau = 1e-9;                % Start time: 1 ns
assert(N > 0 && N == round(N), 'N must be a positive integer.');

%% (a) Time-domain waveform
t = linspace(0, 50e-9, 10001);
a = zeros(size(t));
on = (t >= tau) & (t <= tau + D);
a(on) = sin(2*pi*f0*(t(on)-tau));

%% (b) Analytical Fourier-transform magnitude
% A time delay changes phase, but not spectral magnitude.
f = unique(sort([logspace(log10(3e6), log10(5e9), 80000), ...
                 f0, f0-1/D, f0+1/D]));
w  = 2*pi*f;
w0 = 2*pi*f0;
A = zeros(size(f));
atCarrier = abs(f-f0) < 1; % Avoid the removable 0/0 at the carrier
A(~atCarrier) = abs(2*w0*sin(w(~atCarrier)*D/2) ./ ...
                         (w0^2-w(~atCarrier).^2));
A(atCarrier) = D/2;       % Exact carrier magnitude: 1e-8 s


%% Figure 1: Time-domain waveform
figure('Color','w');

plot(t*1e9, a, 'b', 'LineWidth', 1);
xlim([0 50]);
ylim([-1 1]);

xticks(0:10:50);
yticks(-1:0.5:1);

xlabel('Time (ns)');
ylabel('a(t)');
title('Time domain: 1 GHz, 20-cycle burst');

grid on;
box on;
set(gca,'FontSize',12);

%% Figure 2: Frequency-domain spectrum
figure('Color','w');

loglog(f/1e9, max(A,1e-12), 'b', 'LineWidth', 1);
xlim([1e-3 1e1]);
ylim([1e-12 1e-8]);

xticks([1e-3 1e-2 1e-1 1 10]);
yticks([1e-12 1e-11 1e-10 1e-9 1e-8]);

xlabel('Frequency (GHz)');
ylabel('|A(f)| (s)');
title('Analytical Fourier-transform magnitude');

grid on;
box on;
set(gca,'FontSize',12,'XMinorGrid','off','YMinorGrid','off');
% Floor only for displaying nulls on a logarithmic axis.
loglog(f/1e9, max(A,1e-12), 'b', 'LineWidth', 1);
xlim([1e-3 1e1]); ylim([1e-12 1e-8]);
xticks([1e-3 1e-2 1e-1 1 10]);
yticks([1e-12 1e-11 1e-10 1e-9 1e-8]);
xlabel('Frequency (GHz)');
ylabel('|A(f)| (s)');
title('(b) Analytical Fourier-transform magnitude');
grid on; box on;
set(gca,'FontSize',12,'XMinorGrid','off','YMinorGrid','off');

fprintf('Burst duration: %.1f ns\n',D*1e9);
fprintf('Burst starts at %.1f ns and ends at %.1f ns\n', ...
        tau*1e9,(tau+D)*1e9);
fprintf('Magnitude at the carrier: %.3e s\n',D/2);
fprintf('First zeros around carrier: %.0f and %.0f MHz\n', ...
        (f0-1/D)/1e6,(f0+1/D)/1e6);

