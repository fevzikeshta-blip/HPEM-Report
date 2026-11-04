%% Combined HEMP timeline based on analytical expressions
clear; clc; close all;

%% Common time axis: 0.1 ns to 1000 s
% A logarithmic axis cannot include t = 0.
t = logspace(-10, 3, 60000);       % Time in seconds

%% E1: early-time component
E01 = 50000;                      % V/m
k1  = 1.3;
a1  = 4e7;                        % s^-1
b1  = 6e8;                        % s^-1

E1 = E01*k1 .* (exp(-a1*t) - exp(-b1*t));

%% E2: intermediate-time component
E02 = 100;                        % V/m
k2  = 1;
a2  = 1000;                       % s^-1
b2  = 6e8;                        % s^-1

E2 = E02*k2 .* (exp(-a2*t) - exp(-b2*t));

%% E3: late-time component
E0i = 0.04;                       % V/m
ki  = 1.058;
ai  = 0.02;                       % s^-1
bi  = 2;                          % s^-1

E0j = 0.01326;                    % V/m
kj  = 9.481;
aj  = 0.015;                      % s^-1
bj  = 0.02;                       % s^-1

% Choose the E3 time reference:
% 0 = onset-aligned display, resembling the supplied timeline.
% 1 = retain the 1-second delay used in the previous script.
t0E3 = 0;                        % seconds

tau = t - t0E3;
active = tau > 0;

Ei = zeros(size(t));
Ej = zeros(size(t));

Ei(active) = E0i*ki .* ...
    (exp(-ai*tau(active)) - exp(-bi*tau(active)));

Ej(active) = E0j*kj .* ...
    (exp(-aj*tau(active)) - exp(-bj*tau(active)));

E3 = Ei - Ej;

%% Prepare values for a logarithmic plot
% Hide values below the plotting range instead of clipping them.
fieldMin = 1e-4;                 % V/m

E1plot = E1;
E2plot = E2;
E3plot = abs(E3);

E1plot(E1plot < fieldMin) = NaN;
E2plot(E2plot < fieldMin) = NaN;
E3plot(E3plot < fieldMin) = NaN;

%% Combined figure
figure('Color','w', ...
       'Name','Combined HEMP timeline', ...
       'Position',[100 100 1100 650]);

ax = axes;
hold(ax,'on');

h1 = loglog(ax, t, E1plot, ...
    'Color',[0 0 1], 'LineWidth',1.8);

h2 = loglog(ax, t, E2plot, ...
    'Color',[0.85 0.15 0.10], 'LineWidth',1.8);

h3 = loglog(ax, t, E3plot, ...
    'Color',[0 0.55 0.20], 'LineWidth',1.8);

% Explicitly set both axes to logarithmic scaling.
set(ax, 'XScale','log', 'YScale','log', ...
        'FontSize',12, ...
        'XMinorGrid','on', 'YMinorGrid','on');

xlim(ax,[1e-10 1e3]);
ylim(ax,[fieldMin 1e5]);

xticks(ax,10.^(-10:1:3));
yticks(ax,10.^(-4:1:5));

xlabel(ax,'Time (s)');
ylabel(ax,'Electric-field magnitude (V/m)');
title(ax,{'Combined HEMP timeline', ...
          'E1, E2 and |E3| from analytical expressions'});

legend(ax,[h1 h2 h3], ...
    {'E1','E2','|E3|'}, ...
    'Location','northeastoutside');

grid(ax,'on');
box(ax,'on');
hold(ax,'off');