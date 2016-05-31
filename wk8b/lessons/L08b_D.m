%% Numerical Differentiation Example 1
% comparing forward, backward and central differentiation on empirical
% data. we mix methods at the boundaries, make sure each method uses the
% same accuracy
clear all; close all; clc;

% we have collected some velocity data off of a jet and we will try to
% determine what the acceleration of the jet is over the same time period.
% This is in contrast to the a similar example where we integrated the
% velocity data to get the position of the jet.

% raw data
dt = 1;
t = 0:dt:11;% uniformly sampled (unlike integration)
v = [3.1 17.7 30.5 42.4 49.5 57.5 63.6 66.6 66.6 64.9 62.9 62.2];
step_fb = 2;% forward/backward steps
step_c = 1;% central steps

figure('name','Jet Velocity/Acceleration');
subplot(2,1,1);
plot(t,v,'k-o'); grid on;
xlabel('Time [s]'); ylabel('Velocity [m/s]');

% we can only estimate the derivative at the sampled points i.e. t =
% 0,1,2,3 etc..If we want to know what is happening the data points we
% would need to use interpolation.

% use an accuracy 2 method and compare forward, backward and central
% differentiation

% forward
a = zeros(length(v),1);

for k = 1:length(a)
    % index out of bounds error so we restrict k
    if k <= length(a) - step_fb
        % forward
        a(k) = ((-3/2).*v(k) + (2).*v(k+1) + (-1/2).*v(k+2))./dt;
    else
        % use backwards differentiation on the last two data points
        a(k) = ((3/2).*v(k) + (-2).*v(k-1) + (1/2).*v(k-2))./dt;
    end
end

% show acceleration
subplot(2,1,2);
plot(t,a,'-o'); grid on; hold on;
xlabel('Time [s]'); ylabel('Acceleration [m/s^2]');

% backward
a = zeros(length(v),1);

for k = 1:length(a)
    % index out of bounds error so we restrict k
    if k >= 1 + step_fb
        % backward
        a(k) = ((3/2).*v(k) + (-2).*v(k-1) + (1/2).*v(k-2))./dt;
    else
        % use forward differentiation on the first two data points
        a(k) = ((-3/2).*v(k) + (2).*v(k+1) + (-1/2).*v(k+2))./dt;
    end
end

% show acceleration
subplot(2,1,2);
plot(t,a,'r-o');

% central
a = zeros(length(v),1);

for k = 1:length(a)
    % index out of bounds error so we restrict k
    if k < 1 + step_c
        % forward
        a(k) = ((-3/2).*v(k) + (2).*v(k+1) + (-1/2).*v(k+2))./dt;
    elseif k > length(a) - step_c
        % backward
        a(k) = ((3/2).*v(k) + (-2).*v(k-1) + (1/2).*v(k-2))./dt;
    else
        % use central differentiation
        a(k) = ((-1/2).*v(k-1) + (0).*v(k) + (1/2).*v(k+1))./dt;
    end
end

subplot(2,1,2);
plot(t,a,'g-o');
legend('Forward','Backward','Central');