%% ODE45 Example 1
clc; clear all; close all;

% we use Matlab's ode45 function on a system in state space form. From our
% previous example

% x1 = x, x2 = x'
% solve for x, x' for t in [0,15] sec
% initial conditions

% we make a new .m file whose only job is to assemble the derivatives of
% our state variables. f_G

% range of t
t0 = 0;
tf = 15;

% independent variable, vector of dependent variables (t,x)
% time range [t0 tf]
% initial conditions y(0) = x1(0) = -2 & y'(0) = x2(0) = 4
% can we do other initial conditions here?
[T,X] = ode45(@(t,x) f_G(t,x),[t0, tf],[-2,4]);

figure('name','ODE 45 Solver Example 1');
subplot(2,1,1);
% the first column of X is x1 = y (our solution)
plot(T,X(:,1)); grid on;
xlabel('t','interpreter','latex'); ylabel('y','interpreter','latex');
title('$4y\prime\prime - 2y\prime + 7y = 3\sin(t)$',...
    'interpreter','latex','fontsize',15);

% so we only have approximate values of y at specific values of t
% if we want to know what happens in between, we can use interpolation or
% modify the time range increments [t0:0.1:tf] to get a time step of 0.1
% sec for example.

subplot(2,1,2);
% the second column of X is x2 = y' the derivative of our solution
plot(T,X(:,2)); grid on;
xlabel('t','interpreter','latex'); ylabel('dy/dt','interpreter','latex');
