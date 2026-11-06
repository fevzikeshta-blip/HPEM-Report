%% HEMP E1, E2 and E3 reference waveforms
% All calculations use time in seconds and electric field in V/m.

clear; clc; close all;

%% 1. Early-time component: E1
E01 = 50000;             % V/m
k1  = 1.3;
a1  = 4e7;              % 1/s
b1  = 6e8;              % 1/s

t1 = linspace(0, 200e-9, 20001);
E1 = zeros(size(t1));

active = t1 > 0;
E1(active) = E01*k1 .* ...
    (exp(-a1*t1(active)) - exp(-b1*t1(active)));

figure('Color','w','Name','HEMP E1');
plot(t1*1e9, E1, 'b', 'LineWidth',1.6);

xlabel('Time (ns)');
ylabel('Electric field E_1 (V/m)');
title('Early-time HEMP: E1');
xlim([0 200]);
xticks(0:20:200);
grid on; box on;
set(gca,'FontSize',12);

ax = gca;
ax.YAxis.Exponent = 0;

%% 2. Intermediate-time component: E2
E02 = 100;              % V/m
k2  = 1;
a2  = 1000;             % 1/s
b2  = 6e8;              % 1/s

% Fine sampling near the fast rising edge, then a longer time range.
t2 = unique([linspace(0, 100e-9, 2001), ...
             linspace(100e-9, 5e-3, 20001)]);

E2 = zeros(size(t2));

active = t2 > 0;
E2(active) = E02*k2 .* ...
    (exp(-a2*t2(active)) - exp(-b2*t2(active)));

figure('Color','w','Name','HEMP E2');
plot(t2*1e3, E2, 'b', 'LineWidth',1.6);

xlabel('Time (ms)');
ylabel('Electric field E_2 (V/m)');
title('Intermediate-time HEMP: E2');
xlim([0 5]);
xticks(0:1:5);
grid on; box on;
set(gca,'FontSize',12);

%% 3. Late-time component: E3
E0i = 0.04;             % V/m
ki  = 1.058;
ai  = 0.02;             % 1/s
bi  = 2;                % 1/s

E0j = 0.01326;          % V/m
kj  = 9.481;
aj  = 0.015;            % 1/s
bj  = 0.02;             % 1/s

t3  = linspace(0, 500, 50001);
tau = t3 - 1;           % Shifted time: onset at t = 1 second

Ei = zeros(size(t3));
Ej = zeros(size(t3));

% Apply the onset condition to the shifted time.
active = tau > 0;

Ei(active) = E0i*ki .* ...
    (exp(-ai*tau(active)) - exp(-bi*tau(active)));

Ej(active) = E0j*kj .* ...
    (exp(-aj*tau(active)) - exp(-bj*tau(active)));

E3 = Ei - Ej;

figure('Color','w','Name','HEMP E3');
plot(t3, E3, 'b', 'LineWidth',1.6);

xlabel('Time (s)');
ylabel('Electric field E_3 (V/m)');
title('Late-time HEMP: E3');
xlim([0 500]);
xticks(0:50:500);
grid on; box on;
set(gca,'FontSize',12);

%% Print calculated peak values and their times
[peak1, index1] = max(E1);
[peak2, index2] = max(E2);
[peak3, index3] = max(E3);
[min3, indexMin3] = min(E3);

fprintf('E1 peak: %.3f kV/m at %.3f ns\n', ...
    peak1/1e3, t1(index1)*1e9);

fprintf('E2 peak: %.3f V/m at %.3f ns\n', ...
    peak2, t2(index2)*1e9);

fprintf('E3 positive peak: %.5f V/m at %.3f s\n', ...
    peak3, t3(index3));

fprintf('E3 negative peak: %.5f V/m at %.3f s\n', ...
    min3, t3(indexMin3));
