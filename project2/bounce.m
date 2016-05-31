function [value, isterminal, direction] = bounce(t,x)

% value of the event function (x1 = y)
value = x(1);
% integration is to terminate at a zero of this event function
isterminal = 1;
% find zeros where event function is decreasing
direction = -1;

return