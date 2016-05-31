%% Monte Carlo Integration, Example 5
% we revisit example 1 and this time solve the integral using MCI. We check
% for convergence of the result to assure that we have used enough samples
% in the estimate.

clear all; close all; clc;

% function of interest from example 1
y = @(x) exp(sin(x.^2));

% establish a baseline
a = 0; b = 5;
tic;
I_Quad = integral(@(x) y(x),a,b);% 6.7975
t_quad = toc;
% calculating this using MCI, how many samples will we need in order to
% achieve the same value.

tic;
% test points sampled uniformly on [0,5]
N = 1e6;
xt = a + b*rand(N,1);

% evaluate the function at the test points
F = y(xt);

% get the average value
F_bar = mean(F);

% MCI estimate
I_Monte = F_bar * (b - a);
t_monte = toc;

t_monte/t_quad
% how many samples does it take before the value of our estimate converges?
% how does the estimate of the integral change as we use more samples?

Fs = cumsum(F);
sliding_mean = Fs ./ [1:N]';
I_estimate = sliding_mean .* (b - a);

% we appear to have convergence after about 50,000 samples
figure('name','Monte Carlo Integration');
semilogx(I_estimate,'k-'); grid on;
xlabel('Sample Size N');
title('$\int^a_b e^{\sin x^2}\,dx$','interpreter','latex','FontSize',15);

