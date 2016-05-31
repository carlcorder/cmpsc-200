%% 1. Estimating velocity given position data

dt = 1;
t = 0:dt:10;
x = [0 2 6 8 9 11 14 18 16 14 11];
step_fb = 2;% forward/backward steps
step_c = 1;% central steps

figure('name','Position & Velocity');
subplot(2,1,1);
plot(t,x,'k-o'); grid on;
xlabel('Time [s]'); ylabel('Position [m]');

% a)
% forward
vf = zeros(length(t),1);

for k = 1:length(vf)
    if k <= length(vf) - step_fb
        % forward
        vf(k) = ((-3/2).*x(k) + (2).*x(k+1) + (-1/2).*x(k+2))./dt;
    else
        % use backwards differentiation on the last two data points
        vf(k) = ((3/2).*x(k) + (-2).*x(k-1) + (1/2).*x(k-2))./dt;
    end
end

% b)
% backward
vb = zeros(length(t),1);

for k = 1:length(vb)
    if k >= 1 + step_fb
        % backward
        vb(k) = ((3/2).*x(k) + (-2).*x(k-1) + (1/2).*x(k-2))./dt;
    else
        % use forward differentiation on the first two data points
        vb(k) = ((-3/2).*x(k) + (2).*x(k+1) + (-1/2).*x(k+2))./dt;
    end
end

% c)
% central
vc = zeros(length(t),1);

for k = 1:length(vc)
    if k < 1 + step_c
        % forward
        vc(k) = ((-3/2).*x(k) + (2).*x(k+1) + (-1/2).*x(k+2))./dt;
    elseif k > length(vc) - step_c
        % backward
        vc(k) = ((3/2).*x(k) + (-2).*x(k-1) + (1/2).*x(k-2))./dt;
    else
        % use central differentiation on the middle data points
        vc(k) = ((-1/2).*x(k-1) + (1/2).*x(k+1))./dt;
    end
end

% d)
% i.
subplot(2,1,2);
plot(t,vf,'-o'); grid on; hold on;
xlabel('Time [s]'); ylabel('Velocity [m/s]');

subplot(2,1,2);
plot(t,vb,'r-o');

subplot(2,1,2);
plot(t,vc,'g-o');
legend('Forward','Backward','Central');

% ii.
[vf vb vc]
time = 4.6;% sec
dxe = interp1(t,[vf vb vc],time);% [2.1 1.7 2.1]

%% Numerical Differentiation of a Function using Central Differencing
close all; clear all; clc;

x = @(t) sin(t);

% two point scheme coefficients
Cf2 = [-3/2 2 -1/2]; Cb2 = -Cf2;
Cc2 = [-1/2 0 1/2];

% four point scheme coefficients

% a) 5 equally spaced samples of x
N = 5;
dt = 2*pi./N;
t = 0:dt:2*pi;
% i. using a two point scheme
step_c = 1;

dx = zeros(length(t),1);

for k = 1:length(dx)
    if k < 1 + step_c
        % forward
        dx(k) = ((-3/2).*x(k) + (2).*x(k+1) + (-1/2).*x(k+2))./dt;
    elseif k > length(dx) - step_c
        % backward
        dx(k) = ((3/2).*x(k) + (-2).*x(k-1) + (1/2).*x(k-2))./dt;
    else
        % use central differentiation on the middle data points
        dx(k) = ((-1/2).*x(k-1) + (0).*x(k) + (1/2).*x(k+1))./dt;
    end
end

figure('name','Two Point Central Difference');
plot(t,dx,'k-o'); grid on; hold on;
xlabel({'t','5 sample points'}); ylabel('dx/dt');
title('$\frac {d}{dt} sin(t)$','interpreter','latex','FontSize',15);

% b) central differencing using 100 equally spaced samples of x with a 2,4
% & 6 point shceme
N = 100;
dt = 2*pi./N;
t = 0:dt:2*pi;
x = @(t) sin(t);
dxc2 = ndiff(x(t),dt,'c2');
dxc4 = ndiff(x(t),dt,'c4');
dxc6 = ndiff(x(t),dt,'c6');

% no discernable differnce
figure('name','100 Points Central Difference');
plot(t,dxc2,t,dxc4,t,dxc6); axis tight; grid on;
xlabel('t'); ylabel('x'); title('$\frac {d}{dt} sin(t)$',...
    'interpreter','latex','FontSize',15);
legend('c2','c4','c6');

% c) using 1000 equally spaced samples of x
N = 1000;
dt = 2*pi./N;
t = 0:dt:2*pi;
x = @(t) sin(t);
dxc2 = ndiff(x(t),dt,'c2');
dxc4 = ndiff(x(t),dt,'c4');
dxc6 = ndiff(x(t),dt,'c6');

figure('name','1000 Points Central Difference');
plot(t,dxc2,t,dxc4,t,dxc6); axis tight; grid on;
xlabel('t'); ylabel('x'); title('$\frac {d}{dt} sin(t)$',...
    'interpreter','latex','FontSize',15);
legend('c2','c4','c6');

%% 3. Numerical Velocity and Acceleration from Position

% load in the data
data = csvread('/home/carl/MATLAB/ANGEL/HWs/wk8b/pos_data.csv');
t = data(:,1);
x = data(:,2);

% a) find the time step and sample rate

% assuming uniformly sampled data
dt = t(2) - t(1);% 0.0020
% sample rate
f = 1./dt;% 500 samples/sec

% b) plot time vs position
figure('name','Position Data');
subplot(3,1,1);
plot(t,x); grid on; hold on; axis tight;
xlabel('Time [s]'); ylabel('Position [m]');
title('$x$','interpreter','latex','FontSize',12);

% c) find the velocity over the time span using central differencing
v = ndiff(x',dt,'c6')';% ndiff requires a row vector

% ii. find the value of maximum velocity
[max_v,ind] = max(v);
% occurs when t = 0.9760
max_t = t(ind);
% show the point
plot(max_t,x(ind),'r.');

% i. plot time vs velocity
subplot(3,1,2);
plot(t,v); grid on; hold on; axis tight;
xlabel('Time [s]'); ylabel('Velocity [m/s]');
title('$\frac {dx}{dt}$','interpreter','latex','FontSize',12);

% show the max
plot(max_t,max_v,'r.');

% d) find the acceleration over the time span using central differencing
a = ndiff(v',dt,'c6')';% ndiff requires a row vector

% i. plot time vs acceleration
% NOTE: noise at the end of our data set
subplot(3,1,3);
plot(t,a); grid on; hold on; axis tight;
xlabel('Time [s]'); ylabel('Acceleration [m/s^2]');
title('$\frac {d^2 x}{dt^2}$','interpreter','latex','FontSize',12);

% e) find when the acceleration dropped to zero using the velocity and
% acceleration estimate

% i. if we assume a = 0 when v = max_v then
a_0 = a(ind);% 0.0623

% show the zero of acceleration
plot(max_t,a_0,'r.');

% ii. using the acceleration data we get spurious results at the tail due
% to the instablility of the numerical derivative

% we assume the acceleration goes to zero when the sign between consecutive
% data points change
as = diff(sign(a));
a0_possible = find(as ~= 0);% indices where a could be zero

% we see this method is a lot less dependable
plot(t(a0_possible),a(a0_possible),'gs');
