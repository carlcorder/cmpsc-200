%% 1. Solving a Dif Eq with ODE45
clear all; close all; clc;
% x'' + 3 x' + 7 x = exp(t) + t sin(t); x(0) = 4, x'(0) = 2

% exact solution
f = @(t) (4275.*exp(t) + exp(-(3/2).*t).*(38981*sqrt(19).*sin((sqrt(19)/2).*t) + ...
    182571.*cos((sqrt(19)/2).*t)) + 209*((30*t - 17).*sin(t) + (6 - 15.*t).*cos(t)))./47025;

% transform eqn using state space variables and solve for the derivative
% x1 = x, x1' = x', x2 = x', x2' = x'' ->
% x1' = x2
% x2' = exp(t) + t*sin(t) - 3*x2 - 7*x1
% 
% the above information is encoded into a custom function 'xn.m'

% solve the ode: function, range, inital values, options
% size of X = (time stamps) x (state variables)
% a) find the nuerical solution using ode45
[T,X] = ode45(@(t,x) xn(t,x),[0,4],[4,2]);

figure('name','ODE 45 Solver');
% plot the numeric solution
plot(T,X(:,1)); grid on; hold on;
xlabel('t','interpreter','latex','fontsize',13);
ylabel('y','interpreter','latex','fontsize',13);
title('$x\prime\prime + 3x\prime + 7x = e^{t} + t\sin(t)$',...
    'interpreter','latex','fontsize',15);

% b) plot the analytic solution
t = 0:0.05:4;
plot(t,f(t),'g--');

legend('Numerical','Analytical');

% c) compare your results
% on the given interval [0,4] the numerical and analytical solution differ
% by no more than 0.0004 = 4e-4
figure('name','Absolute Error');
plot(T,abs(X(:,1) - f(T)),'r-'); grid on;

%% 2. Motion of Mass Connected to Spring and Viscous Damper

% m y'' + c y' + k y = 0
% y(0) = 10 and y'(0) = 2
%
% plot the position of the mass, y(t), for 5 seconds

% y1 = y, y1' = y', y2 = y', y2' = y''
% see: http://www.roboticslab.ca/mass-spring-damper/

% y1' = y2
% y2' = -(c/m)y2 - (k/m)y1

% the ratio of the eigenvalues l1 & l2 of
% A = [0 m; -k -c] give us the stiffness ratio -> indicates numeric stability
% of Runge-Kutta method (ode45), which is designed for non stiff problems.

% these articles address stiffness
% see: https://en.wikipedia.org/wiki/Stiff_equation
% see: http://www.mathworks.com/help/matlab/math/ordinary-differential-equations.html

% A. first parameter set
m1 = 3; c1 = 10; k1 = 102;
p1 = [m1 c1 k1];% m, c, k

% B. second paramter set
m2 = 3; c2 = 39; k2 = 120;
p2 = [m2 c2 k2];% m, c, k

% values of interest
% see: https://en.wikipedia.org/wiki/Damping
% natural frequency w = sqrt(k/m)
% damping ratio z = c/(2*sqrt(m*c))
% natural damped frequency wd = w*sqrt(1-z^2)

w1 = sqrt(k1/m1);% 5.83 hz
z1 = c1/(2*sqrt(m1*c1));% under damped
w2 = sqrt(k2/m2);% 6.32 hz
z2 = c2/(2*sqrt(m2*c2));% over damped

% solve the first system
[T1,Y1] = ode45(@(t,y) yn(t,y,p1),[0,5],[10,2]);

% solve the second system
[T2,Y2] = ode45(@(t,y) yn(t,y,p2),[0,5],[10,2]);

figure('name','Damped Harmonic Oscillator');
plot(T1,Y1(:,1),T2,Y2(:,1)); grid on; hold on;
xlabel('t','interpreter','latex','fontsize',13);
ylabel('y','interpreter','latex','fontsize',13);
title('$m y\prime\prime + c y\prime + k y = 0$',...
    'interpreter','latex','fontsize',15);
legend('under damped','over damped');

% one oscillator is over damped and the other is under damped. Both
% oscillators have a natural frequency around 6Hz

%% 3. Unforced Van der Pol Oscillator

% general equation given as: y'' - u(1 - y^2)y' + y = 0

% when u = 0 there is no damping function and the system enters simple
% harmonic motion (there is conservation of energy). when u > 0 the
% system will enter a limit cycle. Near the origin the system is unstable
% and far from the origin the system is damped. When the oscillator is
% driven it can display chaotic behavior.
% see: https://en.wikipedia.org/wiki/Van_der_Pol_oscillator for more detail

% transform the equation using state space variables and solve for y2'
% y1 = y, y1' = y', y2 = y', y2' = y''

% y1' = y2
% y2' = u(1-y1^2)y2 - y1

% a) let u = 1.2, y(0) = 4 & y'(0) = 0. Solve for y(t) and plot the results
% in phase space over the range 0 < t < 500

[t,y] = ode45(@(t,y) pol(t,y,1.2),[0 500],[4; 0]);

figure('name','Phase Space Diagram');
plot(y(:,1),y(:,2)); grid on; hold on;
xlabel('$y(t)$','interpreter','latex','fontsize',13);
ylabel('$y\prime(t)$','interpreter','latex','fontsize',13);
title('$Van \, der \, Pol \, Oscillator, \mu = 1.2$',...
    'interpreter','latex','fontsize',13);

% animate the oscillator for a cycle
for k = 1:10:3e2
    plot(y(k,1),y(k,2),'r.');
    M(k) = getframe;
end

% When μ is increased to 1000, the solution to the van der Pol equation changes
% dramatically and exhibits oscillation on a much longer time scale.
% Approximating the solution of the initial value problem becomes a more
% difficult task. Because this particular problem is stiff, a solver intended
% for nonstiff problems, such as ode45, is too inefficient to be practical.
% A solver such as ode15s is intended for such stiff problems.

% b) solve the system again but vary y(0) = [-2.50, 0.25, 0.50, 1.00, 3.00]
% and plot the results in the phase plane. What happens, in general, to the
% values of y(t) & y'(t) for t >> 0

figure('name','Varying Initial Conditions');
y0 = [-2.50, 0.25, 0.50, 1.00, 3.00];
for k = 1:length(y0)
    [T,Y] = ode45(@(t,y) pol(t,y,1.2),[0 500],[y0(k); 0]);
    plot(Y(:,1),Y(:,2)); grid on; hold on;
    xlabel('$y(t)$','interpreter','latex','fontsize',13);
    ylabel('$y\prime(t)$','interpreter','latex','fontsize',13);
    title('$y\prime\prime - \mu (1 - y^{2}) y\prime + y = 0$',...
    'interpreter','latex','fontsize',15);
end

hl = legend('y_{0} = -2.50','y_{0} =  0.25','y_{0} =  0.50','y_{0} =  1.00',...
    'y_{0} =  3.00','location','northwest');

set(hl,'FontSize',7);

% for each initial value, there is a unique and stable limit cycle
% surrounding the origin. The limit cycle also becomes increasingly sharp
% as we vary y0.


