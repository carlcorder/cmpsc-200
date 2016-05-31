%% 1. Numerical Integration Using Quadrature
clear all; close all; clc;
% a) the analytic result is given exactly by -> see notes for details
y = 204*exp(3/4) - 300*exp(1/4);

% b) use the matlab integral function to find the definite value and
% compare your results obtained in part a.
f = @(x) 3.*x.^2.*exp(x./4);
xa = 1; xb = 3;
y_quad = integral(@(x) f(x),xa,xb);

% good to within about 1 part in 1 quadrillion (1/1e16)
rel_error = abs((y - y_quad)/y);

%% 2. Numerical Integration of Voltage Across a Capacitor

t0 = 0;% initial time seconds
t1 = 1.2;
tf = 10;
Q0 = 0;% initial charge Coloumbs
C = 20e-3;% Farads

% current as a function of time
i = @(x) 0.3 + 0.45.*exp(-0.05.*x).*sin(0.5.*pi.*x);% Amperes

% a) create a function to calculate voltage vs time
% integrate the current over time and divide by capacitance to get voltage
v = @(t) integral(@(x) 1/C * (i(x) + Q0),t0,t);

% b) compute the voltage at 1.2s
v_at_t1 = v(t1);% 36.0658

% c) compute the voltage as a function of time and plot the current and
% voltage from t = 0 to t = 10 seconds

n = 1e3;% sample points
te = linspace(t0,tf,n);

% preallocate memory
V = zeros(n,1);

for k = 1:n
   V(k) = v(te(k)); 
end

figure('name','Voltage Across a Capacitor');
subplot(2,1,1);
plot(te,V,'k-'); grid on;
xlabel('Time [s]'); ylabel('Voltage [V]');
title('$v(t) = \frac{1}{C} \int^t_0 i(x)\,dx + \frac{Q_{0}}{C}$'...
    ,'interpreter','latex','FontSize',15);

subplot(2,1,2);
plot(te,i(te),'k-'); grid on;
xlabel('Time [s]'); ylabel('Current [Amperes]');
title('$i(t) = 0.3 + 0.45 e^{-0.05t}\sin(0.05\pi t)$',...
    'interpreter','latex','FontSize',15);
%% 3. Numerical Integration of Acceleration to Estimate Velocity
clear v v0 t t0 t1 tf;
t0 = 0; tf = 10;
v0 = 5;% initial velocity m/s
t = t0:1:tf;% time s
a = [0 2 6 8 9 11 14 18 16 14 11];% acceleration m/s^2

% current velocity is the change in velocity over a given time i.e. area under
% the acceleration curve, + initial velocity
v = v0 + cumtrapz(t,a);

% a) plot the velocity over the time span
figure('name','Trapezoidal Estimation');
plot(t,v); grid on; xlabel('Time [s]'); ylabel('Velocity [m/s]');
title('$v(t) = \int_{t_{0}}^t a(t)\,dt + v_{0}$',...
    'interpreter','latex','FontSize',15);

% b) estimate the objects velocity avel_at_t1t t = 7.5s
% we use linear interpolation
t1 = 7.5;
vel_at_t1 = interp1(t,v,t1);% 72.50 m/s

%% 4. Monte Carlo Integration MCI

% using both methods quadrature & MCI, find the integral of the following 
% function and compare values

y = @(t) 1./(1 + sinh(2.*t) + 2.*log(t).^2);
ta = 0; tb = 3;

% a) what values do you get when using each method?
% quadrature
I_quad = integral(@(t) y(t),ta,tb);% 0.3525

% Monte Carlo
N = 1e6; % number sample points
num = 1:N;
V = (tb - ta);% "volume" of variable space
t_samp = ta + (tb-ta)*rand(N,1);% sample points
Y = y(t_samp);
I_monte = mean(Y)*V;% 0.352_

% b) plot the percent error (use absolute difference) of your MCI from 1 to
% N samples on a semilog plot

I_monte_cum = V.*cumsum(Y)./num';

per_error = 100*abs((I_monte_cum - I_quad)/I_quad);

figure('name','Percent Error');
semilogx(per_error); grid on; hold on; ylim([-5,105]);
xlabel('N'); ylabel('Error');

% i. the solution seems to converge after about 100,000 sample points
% ii. the error of the MCI method seems to scale as ~1/sqrt(N)
err = 1./sqrt(num);
c = 90;
semilogx(c*err);

%% 5. Monte Carlo Integration in Two Dimensions

% A cylindrical solid with its base on the x-y plane, center at the origin
% with radius of 0.5 and height determined by z

z = @(x,y) cos(x-0.25).*sin(y-0.90) + 4;

r = 0.5;% radius
A = pi .* r.^2;% "volume" of our integration space

% logical function for the area of integration
R = @(x,y) x.^2 + y.^2 <= r.^2;

ymin = @(x) -sqrt(r.^2 - x.^2); ymax = @(x) sqrt(r.^2 - x.^2);
xmin = -r; xmax = r;

% establish a baseline for the accepted value
I_exact = integral2(@(x,y) z(x,y),xmin,xmax,ymin,ymax);% 2.58198

n = 1e2;
x = linspace(-r,r,n); y = x; [X,Y] = meshgrid(x,y);

% a) mesh plot the function of interest over the given region R
figure('name','MCI in 2D');
mesh(X,Y,z(X,Y).*R(X,Y),'FaceAlpha',0.7); colormap('winter');
xlabel('x'); ylabel('y'); zlabel('z');
title('z = cos(x - 0.25) sin(y - 0.9) + 4','interpreter','latex','FontSize',15);

% b) find the volume of the solid using MCI
% NOTE: Do not pick points uniformly over radius and angle. See
% http://mathworld.wolfram.com/DiskPointPicking.html
% so we use rejection sampling
N = 1e6;

% sample points within the rectangular region 
xysamps = -r + rand(2,N);
sum_squares = sum(xysamps.^2);

% accept the point only if it is within the circle
accept = sum_squares <= r.^2;
% filter the points
xysamps = xysamps(:,accept);
% evaluate the function within the circular region
Z = z(xysamps(1,:),xysamps(2,:));

I_monte = A .* mean(Z);

num = 1:length(xysamps);
I_monte_cum = A .* cumsum(Z)./num;
% MCI  converges to 2.5820 after about 100,000 sample points
figure('name','MCI Convergence');
semilogx(I_monte_cum); grid on;
xlabel('N'); ylabel('I');
title('$\int\limits_R cos(x - 0.25) sin(y - 0.9) + 4\,dx\,dy$',...
    'interpreter','latex','FontSize',15);
