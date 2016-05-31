%% Using regression for parameter estimation.

% We use this method when we already have an idea of the model which fits
% the data.

% 1) exponential model of an RC circuit with constant 5V power source. We
% sample the voltage across the capacitor at a frequency of 1 khz using an
% oscilliscope. Our goal is to find the value for the time constant RC.
clear all; close all; clc;

% read in our data from csv file which we uploaded to the folder
A = csvread('L04_cap.csv');

% pull out the time
t = A(:,1);
% pull out the voltages
V = A(:,2);
% clear A because it is no longer needed
%clear A;

% plot time vs voltage
plot(t,V,'k.'); 
grid on; xlabel('Time [s]'); ylabel('Voltage [V]'); title('RC Circuit');
hold on;

% notice there is noise in the data. The underlying function is known
% theoretically

% tau = a0
%ft = fittype('5*(1-exp(-x/a0))');
% V0 if we don't know the voltage source
ft = fittype('V0*(1-exp(-x/a0))');

% start point not provided error
[F, gof] = fit(t,V,ft);

% plot the model
plot(t,F(t),'g--','LineWidth',2);

% from this model we can find the RC constant tau = 0.5009


