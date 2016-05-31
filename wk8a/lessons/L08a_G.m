%% Numeric Integration of Empirical Data, Example 4
% we don't know the underlying function so we use numerical integration
% methods and apply initial conditions

% we have collected acceleration data at specified times. given the initial
% velocity, we come up with our best estimate for the velocity after 12
% seconds.
close all; clear all; clc;
% time
t = [0.00 0.97 1.96 2.94 4.06 5.02 6.07 7.01 8.11 8.97 10.03 11.11 11.88];
% acceleration
a = [16.4 16.0 13.4 12.8 8.4 6.5 8.7 4.3 1.1 -1.1 -2.1 -1.5 -0.4];
% initial velocity
v0 = 3.1;% m/s

figure('name','Acceleration Data');
ah = plot(t,a,'ko-'); xlabel('time [s]'); ylabel('[m/s^2] & [m/s]');
grid on; hold on; line([min(t);max(t)],[0;0],'LineWidth',1);

% final velocity is the change in velocity over a given time i.e. area under
% the acceleration curve, + initial velocity

% velocity profile as a function of t
v = v0 + cumtrapz(t,a);
% final velocity
vf = v(end);% 77.9175

vh = plot(t,v,'ro-');
legend([ah vh],{'acceleration','velocity'},'Location','NorthWest');

% approximate maximum velocity
v_max = max(v);% 82.2890

