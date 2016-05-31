% State space function for bouncing rubber ball - project 2, problem 3 
%
% this function assembles all the derivatives of our state variables
% together. x is the collection of state variables.

function dxdt = ball(t,x)

% parameters
g = 9.81;

% from the kinematic eqns we have
% x = v_x t, x' = v_x, x'' = 0
% &
% y = v_y t - (1/2) g t^2, y' = v_y - g t, y'' = -g
 
% now let x1 = y, x2 = y', x3 = x & x4 = x' then we have
% dxdt = [x(2); -g; x(4); 0];% [y'; y''; x'; x'']

% alternatively, if there is no x-component of motion
% x1 = y, x1' = y', x2 = y', x2' = y''
dxdt = [x(2); -g];

return