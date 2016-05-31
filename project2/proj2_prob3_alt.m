%% Trajectory of a Rubber Ball
clear all; close all; clc;
% A rubber ball is released from an initial height of 10m and hits the
% ground with a restitution coefficient of 0.8. Neglecting air resistance,
% determine the height of the ball as a function of time over the range
% 0 < t < 12.

% construct our helper function (ball.m) for the ode solver
% and the event function (bounce.m)

% create event options
opts = odeset('Events',@bounce,'RelTol',1e-4,'AbsTol',[1e-6 1e-6]);

% initialize loop values
t0 = 0;
tf = 12;
y0 = 10;
v0 = 0;
R  = 0.80;

% a) plot results
figure('name','Bouncing Rubber Ball');

for k = 0:12% NOTE: 12 sec occurs between the 12th and 13th bounce
    [T,X,t_impact,~,~] = ode45(@(t,x) ball(t,x),0:0.001:tf,[y0*(k == 0) v0],opts);
    plot(T + t0,X(:,1),'b-'); hold on;
    t0 = t0 + t_impact;
    v0 = -X(end,2)*R;
end

xlabel('Time [s]'); ylabel('Height [m]');
grid on;

%% Extra Credit
% b) 
% instead of hitting the ground, the ball hits a racket that has a position
% determined by
%
% y_racket = 2 cos(t/5)
% 
% where the height of the ball and racket are measure from the ground.
% Treat the ball/racket collision as perfectly elastic.

% see: https://en.wikipedia.org/wiki/Elastic_collision

% conservation of momentum ->
% mb*ub + mr*ur = mb*vb + mr*vr (b: ball, r: racket)
% conservation of energy ->
% (1/2)*mb*ub^b + (1/2)*mr*ur^2 = (1/2)*mb*vb^b + (1/2)*mr*vr^2
% if we solve these equations simultaneously for vb & vr  we get

% vb = (ub*(mb - mr) + 2*mr*ur)/(mb + mr) if mr >> mb we have
% vb ~ -ub + 2*ur
% vr = (ur*(mr - mb) + 2*mb*ub)/(mb + mr) again if mr >> mb we have
% vr ~ ur

% position of racket
y_racket = @(t) 2.*cos(t./5);
% velocity of racket
v_racket = @(t) -(2/5).*sin(t./5);

% event options
options = odeset('Events',@hit_racket);

% initialize loop values
t0 = 0;
tf = 60;
y0 = 10;
v0 = 0;

figure('name','Extra Credit');
for k = 0:24
[T,X,t_impact,y_impact,~] = ode45(@(t,x) ball(t,x),t0:0.01:tf,[y0 v0],options);
plot(T,X(:,1),'b-',T,y_racket(T),'r-'); hold on;
t0 = t_impact;
y0 = X(end,1);
v0 = 2*v_racket(t_impact) - X(end,2);% velocity of ball after impact
end

xlabel('Time [s]'); ylabel('Height [m]');
grid on; legend('Ball','Racket','location','south');
title('$ y\prime\prime = \frac {2} {25} \cos(\frac {t} {5}) - g $',...
    'interpreter','latex','fontsize',14);

% in part b) energy is conserved -> we find the ball returning to its
% original height (relative to the racket). Unlike part a) where energy is
% not conserved due to the coefficient of restitution < 1
