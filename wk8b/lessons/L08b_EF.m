%% Differentiation of Functions using Higher Order Central Dif, Example 2
clear all; close all; clc;

% we have the actual function we want to find the derivative of so we can
% take as many data points as desired. we demonstrated that taking too few
% data points lessens the accuracy of the derivative and as a general rule
% of thumb how the accuracy increases as we take more data points.

y = @(x) exp(sin(x.^2));

dt = 0.01;% time step
t = 0:dt:5;% range
Y = y(t);

figure('name','Numerical Differentiation');
subplot(2,1,1);
plot(t,Y,'k-'); grid on;
xlabel('t'); ylabel('y');

% we want to use a 4th order accuracy central method
step_c = 2;% both directions
step_fb = 4;
dy = zeros(1,length(Y));

for k = 1:length(Y)    
    if k < 1 + step_c
        % forward 4th order accuracy
        dy(k) = ((-25/12).*Y(k) + (4).*Y(k+1) + (-3).*Y(k+2) + ...
            (4/3).*Y(k+3) + (-1/4).*Y(k+4))./dt;
    elseif k > length(Y) - step_c
        % backward 4th order accuracy
        dy(k) = ((25/12).*Y(k) + (-4).*Y(k-1) + (3).*Y(k-2) + ...
            (-4/3).*Y(k-3) + (1/4).*Y(k-4))./dt;
    else
        % central 4th order accuracy
        dy(k) = ((1/12).*Y(k-2) + (-2/3).*Y(k-1) + ...
                (2/3).*Y(k+1) + (-1/12).*Y(k+2))./dt;
    end
end

subplot(2,1,2);
plot(t,dy,'k-'); grid on;
xlabel('t'); ylabel('dy/dt');

%% Differentiation of Noisy Data, Example 3
% in the presence of noise, if we want to sample faster we need more accuracy
% this is a problem with real signals and using raw data. This is why we
% filter and smooth the data first. Higher accuray derivatives can also
% smooth the data.

y = @(x) exp(sin(x.^2));

% NOTE: the plot looks a little smoother if we sample the data more
% INFREQUENTLY
dt = 0.01;% time step
t = 0:dt:5;% range
% adding some white noise - random normally distributed with mean = 0 and
% std = 0.02
Y = y(t) + 0.02.*randn(1,length(t));

figure('name','Numerical Differentiation with Noise');
subplot(3,1,1);
plot(t,Y,'k-'); grid on;
xlabel('t'); ylabel('y');

% we want to use a 4th order accuracy central method
step_c = 2;% both directions
step_fb = 4;
dy = zeros(1,length(Y));

for k = 1:length(Y)    
    if k < 1 + step_c
        % forward 4th order accuracy
        dy(k) = ((-25/12).*Y(k) + (4).*Y(k+1) + (-3).*Y(k+2) + ...
            (4/3).*Y(k+3) + (-1/4).*Y(k+4))./dt;
    elseif k > length(Y) - step_c
        % backward 4th order accuracy
        dy(k) = ((25/12).*Y(k) + (-4).*Y(k-1) + (3).*Y(k-2) + ...
            (-4/3).*Y(k-3) + (1/4).*Y(k-4))./dt;
    else
        % central 4th order accuracy
        dy(k) = ((1/12).*Y(k-2) + (-2/3).*Y(k-1) + ...
                (2/3).*Y(k+1) + (-1/12).*Y(k+2))./dt;
    end
end

subplot(3,1,2);
plot(t,dy,'k-'); grid on;
xlabel('t'); ylabel('dy/dt');

% in contrast the integral is less sensitive to noise
I = cumtrapz(t,Y);
subplot(3,1,3);
plot(t,I,'k-'); grid on;
xlabel('t'); ylabel('$\int y dt$','Interpreter','Latex');

% to get velocity, we are better off integrating the acceleration
% measurements than differentiating the position measurements

