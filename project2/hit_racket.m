function [value, isterminal, direction] = hit_racket(t,x)

% value of the event function
value = x(1) - 2*cos(t/5);
% integration is to terminate at a zero of this event function
isterminal = 1;
% find zeros where event function is decreasing
direction = -1;

return