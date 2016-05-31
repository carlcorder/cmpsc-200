%% 2D Interpolation
% two independent variables and one (or multiple) dependent variables. In
% general we can interpolate multidimensional data.

% unlike 1D interpolation where the spaceing between data didn't matter, as
% long as it was strictly monotonic, for the built in "interp2" funcion,
% **all of the data points must be evenly spaced for this to work.**
close all; clear all; clc;

% assume we have data from 9 thermo couples measuring temperature on a
% plate at specified intervals across the horizontal and vertical dimensions

x = [0 0.5 1];
y = [0 1 2];
T = [80 100 120
    120 130 135
    130 142 149];

% using interpolation, fill in the data in between and make a contour plot
% of the temperature distribution of the plate
xi = linspace(0,1,1e2);
yi = linspace(0,2,2e2);

[Xi, Yi] = meshgrid(xi,yi);% matrix of (x,y) values

% x & y data + meshgrid of data
% Te is another matrix of estimated temperature values
Te_linear = interp2(x,y,T,Xi,Yi,'linear');% default is linear
Te_spline = interp2(x,y,T,Xi,Yi,'spline');% default is linear

figure('name','Temperature of a Plate','Position',[50,50,1000,1000]);

subplot(1,2,1);
contourf(Xi,Yi,Te_linear,25);% use 25 contours
colormap('jet'); colorbar;
xlabel('x [m]'); ylabel('y [m]');
% set axis to scale and tighten
axis equal; axis tight;
title('Linear','fontweight','bold','fontsize',14);

subplot(1,2,2);
contourf(Xi,Yi,Te_spline,25);
colormap('jet'); colorbar;
xlabel('x [m]'); ylabel('y [m]'); axis equal; axis tight;
title('Spline','fontweight','bold','fontsize',14);

% 3D view
%figure(2);
%meshc(Xi,Yi,Te_linear);

