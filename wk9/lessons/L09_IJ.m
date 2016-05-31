%% ODE Ballistic Physics Example
clear all; close all; clc;
% a practical example for solving ODEs. launching a cannon ball into the
% air from a height of 10m (y0) with intial velocity of 53 m/s at an angle
% of 20 degrees. How far away will it land?

% we need 4 state variables for: y, y', x, x' and find definitions for y',
% y'', x', x''

% solve for the x & y position of the cannon ball vs time
% at the moment, we don't know the time range we need to run the solver
g = 9.81;% m/s^2
% hits the ground at t ~ 4.1830 sec
% travels about 208 meters
[T,X] = ode45(@(t,x) f_I(t,x,g),[0:0.01:4.2],[10,53*sind(20),0,53*cosd(20)]);

figure('name','Animated Phase Space of Cannon Ball');
plot(X(:,3),X(:,1)); grid on; hold on; axis equal; axis tight;
xlabel('x [m]'); ylabel('y [m]'); title('Trajectory');

% animate the projectile
for k = 1:10:length(T)
    plot(X(k,3),X(k,1),'r.');
    M(k) = getframe;
end

indx_impact = find(X(:,1) <= 0,1);
t_impact = T(indx_impact);% time of impact
distance = X(indx_impact,3);% distance traveled

%% Expand above example by using event detection
clear all; close all; clc;

% we create another m file to handle the custom event

g = 9.81;% m/s^2

% create custom option - create with an Events tag and annotate with the
% event function
opt = odeset('Events',@impact);
% with the options parameter, the solver stops when y = 0 is detected
% we can modify the event by changing the impact value variable to x(2) 
% and dir = 0 to find when y' = 0
[T,X] = ode45(@(t,x) f_I(t,x,g),[0:0.01:5],[10,53*sind(20),0,53*cosd(20)],opt);

% if the solver is called as [T,Y,TE,YE,IE] then it will also return:
% TE: a column vector of times at which events occur
% solution values corresponding to these times
% indicies into the vector returned by the events function (the values
% indicated which event the solver detected)

figure('name','Phase Space of Cannon Ball');
plot(X(:,3),X(:,1)); grid on; hold on; axis equal;
xlabel('x [m]'); ylabel('y [m]'); title('Trajectory');

% we add event detection so that when the projectile hits the ground the
% ode solver stops prematurely
