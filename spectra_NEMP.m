%% Analytical electric-field spectra of E1, E2 and E3
% Fourier convention:
% Etilde(f) = integral E(t)*exp(-1i*2*pi*f*t) dt
% Units: (V/m)*s = (V/m)/Hz

%% Frequency range: 0.0001 Hz to 1 GHz
f = logspace(-4, 9, 30000);
w = 2*pi*f;

%% E1 spectrum
% Algebraically equivalent to:
% E01*k1*(1./(a1+1i*w) - 1./(b1+1i*w))
S1 = E01*k1*(b1-a1) ./ ...
    ((a1 + 1i*w).*(b1 + 1i*w));

%% E2 spectrum
S2 = E02*k2*(b2-a2) ./ ...
    ((a2 + 1i*w).*(b2 + 1i*w));

%% E3 spectrum
Si = E0i*ki*(bi-ai) ./ ...
    ((ai + 1i*w).*(bi + 1i*w));

Sj = E0j*kj*(bj-aj) ./ ...
    ((aj + 1i*w).*(bj + 1i*w));

% Transform the SIGNED E3 waveform, not abs(E3).
% A common time delay changes phase, not spectral magnitude.
S3 = (Si - Sj).*exp(-1i*w*t0E3);

%% Magnitudes
A1 = abs(S1);
A2 = abs(S2);
A3 = abs(S3);

%% Combined spectral plot
figure('Color','w', ...
       'Name','HEMP electric-field spectra', ...
       'Position',[100 100 1100 650]);

axS = axes;
set(axS,'XScale','log','YScale','log');
hold(axS,'on');

p1 = plot(axS,f,A1, ...
    'Color',[0 0 1],'LineWidth',1.8);

p2 = plot(axS,f,A2, ...
    'Color',[0.85 0.15 0.10],'LineWidth',1.8);

p3 = plot(axS,f,A3, ...
    'Color',[0 0.55 0.20],'LineWidth',1.8);

xlabel(axS,'Frequency (Hz)');
ylabel(axS,'Spectral magnitude |E~(f)| ((V/m)/Hz)', ...
    'Interpreter','none');

title(axS,'Analytical electric-field spectra: E1, E2 and E3');

xlim(axS,[1e-4 1e9]);
xticks(axS,10.^(-4:9));

legend(axS,[p1 p2 p3], ...
    {'E1','E2','E3'}, ...
    'Location','northeastoutside');

grid(axS,'on');
box(axS,'on');
set(axS,'FontSize',12, ...
    'XMinorGrid','on','YMinorGrid','on');

hold(axS,'off');
