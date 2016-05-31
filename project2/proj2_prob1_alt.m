%% 1. Support beam loaded with snow
clear all; close all; clc;

L = 2;% meters

% maximum allowed force on supports A & B
Ra_max = 75; Rb_max = 90;% Newtons

% kernel of the weight intensity
w_kern = @(x) sqrt(sinh(x.^2));
W = integral(@(x) w_kern(x),0,L);% 2.9913

% expected value of the weight kernel
XW = integral(@(x) x.*w_kern(x),0,L);% 4.3779

% total force on the beam [N]
F = @(a,b) a.*L + b.*W;

% moment about the center of mass [Nm] (expected value of the weight
% intensity)
Fd = @(a,b) 0.5.*a.*L.^2 + b.*XW;

% solve the matrix for Ra & Rb
Ra = @(a,b) 0.5.*a.*L + b.*(W - XW./L);
Rb = @(a,b) 0.5.*a.*L + b.*XW./L;

% acceptance range -> a linear system of inequalities whose solution forms
% a parallelogram with vertices @
% {(0,0),(-52.0778,64.9064),(66.3204,10.8177),(118.3982,-54.0886)}
accept = @(a,b) Ra(a,b) > 0 & Ra(a,b) <= Ra_max &...
                Rb(a,b) > 0 & Rb(a,b) <= Rb_max;
            
% setup parameter space
n = 1e3;% grid divisions
a_min = -60; a_max = 125; a = linspace(a_min,a_max,n);
b_min = -60; b_max = 75; b = linspace(b_min,b_max,n); 
[A,B] = meshgrid(a,b);

% plot the results
figure('name','Acceptable Parameters');
% the third paramter of imagesc needs to be an array
imagesc(a,b,accept(A,B)); xlabel('a'); ylabel('b'); grid on; axis tight;
hold on;
% flip the y axis
set(gca,'YDir','normal');
% add a legend
N = 2;
cmap = summer(N);
colormap(cmap); hold on;
mark = line(ones(N),ones(N), 'LineWidth',2);
set(mark,{'color'},mat2cell(cmap,ones(1,N),3));
legend('Reject','Accept','Location','NorthEast');
title('$w(x) = a + b\sqrt{\sinh(x^2)}$','interpreter','latex','FontSize',15);
