%% 3D visualization of the Figure 8 electric-field pulse
% Requires figure8_field:
% Column 1 = time in ms
% Column 2 = electric field in V/m
%
% The centerline follows the image-derived waveform.
% The transverse Gaussian profile is illustrative, not measured.

c = 299792458;

%% Read the Figure 8 data
t_ms = figure8_field(:,1);
E = figure8_field(:,2);

% Set time zero at the strongest negative excursion
[~, indexMin] = min(E);
t_us = (t_ms-t_ms(indexMin))*1000;

%% Construct an illustrative transverse profile
x = linspace(-1,1,121);       % Normalized transverse position
width = 0.45;

profile = exp(-(x/width).^2);

% Each row is the original pulse scaled by the transverse profile
E3D = profile(:)*E(:).';

[T, X] = meshgrid(t_us, x);

%% Draw the surface
figure('Color','w','Position',[100 100 1100 650]);
ax = axes;

surf(ax, T, X, E3D, E3D, ...
    'FaceColor','interp', ...
    'EdgeColor','none');

colormap(ax, jet(256));

% Symmetric color limits about zero
Emax = max(abs(E));
caxis(ax, [-Emax Emax]);

cb = colorbar(ax);
cb.Label.String = 'Electric field E (V/m)';

xlabel('Time relative to negative peak (\mus)');
ylabel('Normalized transverse position');
zlabel('Electric field E (V/m)');

title({'3D visualization of the bipolar pulse', ...
       'Image-derived waveform; illustrative transverse profile'});

grid on;
box on;
view(42,28);

xlim([min(t_us), max(t_us)]);
ylim([-1 1]);
zlim([-1.15*Emax 1.15*Emax]);

set(ax,'FontSize',12);

% Enable mouse rotation
rotate3d on;

%% Optional closer view of the main bipolar pulse
% Uncomment the following line:
% xlim([-2 5]);