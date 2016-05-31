% custom function that detects when projectile hits the ground
% see:
% http://www.mathworks.com/help/matlab/ref/odeset.html#f92-1017470
% for more information
%
% INPUT: t
% INPUT: x
%
% OUTPUT: value(s) of our state space constraints
% OUTPUT: isterm
% OUTPUT: dir - direction
function [value, isterm, dir] = impact(t,x)

% again we have from the kinematic eqns
%
% x = v_x t, x' = v_x, x'' = 0
% &
% y = v_y t - (1/2) g t^2, y' = v_y - g t, y'' = -g
% 
% with x1 = y, x2 = y', x3 = x & x4 = x'

% stop when y = x1 = 0
value = x(1);% y
% 0 or 1. 1 indicates we have obtained our value and the solver can stop
% if we set it to 0 we can count the number of times it crosses 0? or if
% isterm is 0 it will not terminate? boolean flag
isterm = 1;% simulation is not accurate after this term

% direction -1 -> value goes from + to -
% direction  1 -> value goes from - to +
% direction  0 -> either direction
% when is a zero crossing detected
dir = -1;% -1,0,1

return;