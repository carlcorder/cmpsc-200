%% ODE 45 Example 2
clear all; close all; clc;
% numerically solve the second example from the notes
% 4y'x - 2xy + 7y = 16 cos(2t) x
% x' - 4y = 0
% x1 = y, x2 = x

% we want to solve for both variables over t = 30 sec, with initial
% conditions of y(0) = -1 and x(0) = 4

% we will also look at the variables over phase space

% solve the DE
% again, T is our time stamps and X is an array with our solutions for y
% (x1) & x (x2)
% size of X is (time stamps) x (state variables)
% using ~ 8,000 points by default
[T,X] = ode45(@(t,x) f_H(t,x),[0 30],[-1,4]);

figure('name','ODE Solver Example 2');
plot(T,X); grid on; legend('y','x');
xlabel('t');

% not the phase space forms a close loop and goes through a period cycle
figure('name','Phase Space');
plot(X(:,1),X(:,2));
xlabel('y'); ylabel('x');
grid on;

figure('name','Phase Space Animation');
hold on; grid on; axis equal;
xlabel('y'); ylabel('x');
% frame 100 + plays too slowly..
for k = 1:100
    plot(X(k,1),X(k,2),'r.');
    M(k) = getframe;
end

% play the movie
movie(M);

