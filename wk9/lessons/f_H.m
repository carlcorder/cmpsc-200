% ODE for example 2
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

% we can pass additional arguments here if desired 
function [xd] = f_H(t,x)

% pre allocate xd (dimensions = state variables by 1)
xd = zeros(2,1);

xd(1) = (1/2).*x(1) - (7/4).*(x(1)./x(2)) + (4).*cos(2.*t);
xd(2) = (4).*x(1);

return
