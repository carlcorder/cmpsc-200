% State space function for rubber ball and racket - project 2, problem 3 
%
% this function assembles all the derivatives of our state variables
% together. x is the collection of state variables.

function dxdt = ball_n_racket(t,x)

% parameters
g = 9.81;

% kinematic eqns with a "moving ground"
% y = y_0 + v_y*t - 2*cos(t/5) - (1/2)*g*t^2,
% y' = v_y + (2/5)*sin(t/5) - g*t
% y'' = (2/25)*cos(t/5) -g
 
% x1 = y, x1' = y', x2 = y', x2' = y''
dxdt = [x(2); (2/25)*cos(t/5)-g];

return