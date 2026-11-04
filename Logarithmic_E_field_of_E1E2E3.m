%% HEMP E1, E2 and E3: separate log-log plots
clear; clc; close all;

%% 1. E1
E01 = 50000;                 % V/m
k1  = 1.3;
a1  = 4e7;                  % s^-1
b1  = 6e8;                  % s^-1

t1 = logspace(log10(1e-10), log10(200e-9), 10000);
E1 = E01*k1 .* (exp(-a1*t1) - exp(-b1*t1));

figure('Color','w','Name','HEMP E1');
loglog(t1*1e9, E1, 'b', 'LineWidth',1.6);

xlabel('Time (ns)');
ylabel('Electric field E_1 (V/m)');
title('Early-time HEMP: E1');
xlim([0.1 200]);
ylim([1 1e5]);

grid on; box on;
set(gca,'FontSize',12, ...
    'XMinorGrid','on','YMinorGrid','on');

%% 2. E2
E02 = 100;                   % V/m
k2  = 1;
a2  = 1000;                  % s^-1
b2  = 6e8;                  % s^-1

t2 = logspace(log10(1e-10), log10(5e-3), 10000);
E2 = E02*k2 .* (exp(-a2*t2) - exp(-b2*t2));

figure('Color','w','Name','HEMP E2');
loglog(t2*1e3, E2, 'b', 'LineWidth',1.6);

xlabel('Time (ms)');
ylabel('Electric field E_2 (V/m)');
title('Intermediate-time HEMP: E2');
xlim([1e-7 5]);
ylim([1e-1 1e3]);

grid on; box on;
set(gca,'FontSize',12, ...
    'XMinorGrid','on','YMinorGrid','on');

%% 3. E3
E0i = 0.04;                  % V/m
ki  = 1.058;
ai  = 0.02;                  % s^-1
bi  = 2;                     % s^-1

E0j = 0.01326;               % V/m
kj  = 9.481;
aj  = 0.015;                 % s^-1
bj  = 0.02;                  % s^-1

t3 = logspace(0, log10(500), 20000);
tau = t3 - 1;               % Preserve the one-second onset delay

Ei = zeros(size(t3));
Ej = zeros(size(t3));
active = tau > 0;

Ei(active) = E0i*ki .* ...
    (exp(-ai*tau(active)) - exp(-bi*tau(active)));

Ej(active) = E0j*kj .* ...
    (exp(-aj*tau(active)) - exp(-bj*tau(active)));

E3 = Ei - Ej;

% Logarithmic axes require positive field values.
E3mag = abs(E3);
E3mag(E3mag == 0) = NaN;

% Break the plotted line where E3 changes polarity.
crossing = find(E3(1:end-1).*E3(2:end) < 0);
E3mag(crossing + 1) = NaN;

figure('Color','w','Name','HEMP E3');
loglog(t3, E3mag, 'b', 'LineWidth',1.6);

xlabel('Time (s)');
ylabel('Electric-field magnitude |E_3| (V/m)');
title('Late-time HEMP: |E3|');
xlim([1 500]);
ylim([1e-5 1e-1]);

grid on; box on;
set(gca,'FontSize',12, ...
    'XMinorGrid','on','YMinorGrid','on');