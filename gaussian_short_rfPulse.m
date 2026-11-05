clear; clc; close all;

%% Normalized time
x = linspace(0, 40, 20001);   % x = t/t0

%% Parameters estimated from the figure
xc = 20;        % Center of the pulse
sigma = 3.5;    % Width of the Gaussian envelope
nu = 1;         % nu = f0*t0: cycles per normalized time unit

%% Build the waveform
envelope = exp(-0.5*((x-xc)/sigma).^2);
carrier = cos(2*pi*nu*(x-xc));

y = envelope .* carrier;     % y = g(t)/A0

%% Plot in a separate window
figure('Color','w','WindowStyle','normal');

plot(x, y, 'b', 'LineWidth', 1.2);

xlim([0 40]);
ylim([-1.2 1.2]);
xticks(0:4:40);
yticks(-1.2:0.4:1.2);

xlabel('t/t_0');
ylabel('g(t)/A_0');
title('Gaussian-modulated sinusoidal pulse');

grid on;
box on;
set(gca,'FontSize',12);

hold on;
plot(x, envelope, 'r--', 'LineWidth', 1);
plot(x, -envelope, 'r--', 'LineWidth', 1);

legend('RF waveform', 'Upper envelope', 'Lower envelope');