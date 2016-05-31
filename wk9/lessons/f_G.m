% ODE for example 1
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

% we can pass additional arguments here if desired (scaling a factor for
% example)
function [xd] = f_G(t,x)

% pre allocate xd (state variables x 1)
xd = zeros(2,1);

xd(1) = x(2);
xd(2) = (-7/4).*x(1) + (1/2).*x(2) + (3/4).*sin(t);

return
