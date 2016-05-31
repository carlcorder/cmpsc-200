% auxillary function for hw9 prob 1
% INPUT t: time stamps
% INPUT x: vector of state space variables (ssv)
%
% OUTPUT xd: vector of derivatives of ssv
function [xd] = xn(t,x)

% pre allocate
xd = zeros(length(x),1);

xd(1) = x(2);
xd(2) = exp(t) + t*sin(t) - 3*x(2) - 7*x(1);

return;