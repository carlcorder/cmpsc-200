%% Numeric Integration using trapz
% we revisit example 1 and use the trapz function to estimate the integral.
% we compare our results to the analytic results and also look at the
% effect of sampling frequency

% trapz requires data vectors and integral requires a function and bounds
clear all; close all; clc;

% define the function
y = @(x) exp(sin(x.^2));

% create the space
xt = linspace(0,5,1e3);

figure('name','Trapezoidal Approximation');
h = area(xt,y(xt)); h.FaceColor = [0.9 0.9 0.9];
xlabel('x'); ylabel('y'); grid on; hold on;
% use latex to display the title
title('$y = e^{\sin x^2}$','interpreter','latex','FontSize',15);

% recall that we won't actually know what our underlying function is, so we
% sample it.
samples = 50;
xp = linspace(0,5,samples);% sample points between 0 and 5
meas = y(xp);% simulated measurements
plot(xp,meas,'ko-'); hold on;

% overlay the trapezoids
Vx = [xp;xp]; Vy = [zeros(1,length(meas));meas];
line(Vx,Vy,'Color','k','LineStyle','--');

% using quadrature in ex 1 -> area = 6.7975
I_trap = trapz(xp,meas);% 7.5893 for 10 samples -> this is an overestimate
% 6.8187 for 30 samples

% if this were acceleration and velocity, then integrating the acceleration
% would only give us a change in velocity. to get the absolute velocity we 
% need to add it back to the initial velocity.

% plot the cumulative integral (optional)
%I_cumtrap = cumtrapz(xp,meas);
%plot(xp,I_cumtrap,'k-');

