% ODE for ballistic physics example
%
% this function assembles all the derivatives of our state variables
% together
%
% [xd] : x dot
% t : independent variable time
% x : state variable vector
% 
% to use ode45, xd must be a column vector
%

% we can pass additional arguments for the value of gravity
% x is the collection of state variables
function [xd] = f_I(t,x,g)

% pre allocate xd (dimensions = state variables by 1)
% we have 4 state variables
xd = zeros(4,1);

% from the kinematic eqns we have
% x = v_x t, x' = v_x, x'' = 0
% &
% y = v_y t - (1/2) g t^2, y' = v_y - g t, y'' = -g
% 
% now let x1 = y, x2 = y', x3 = x & x4 = x' then we have

xd(1) = x(2);% y'
xd(2) = -g;% y''
xd(3) = x(4);% x'
xd(4) = 0;% x'' ignore the effect of air resistance

return
