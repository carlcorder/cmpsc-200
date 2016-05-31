% auxillary function for hw9 prob 2 - mass connected to a spring and
% viscous damper

% INPUT t: time stamps
% INPUT y: vector of state space variables (ssv)
% INPUT params: specifies values for mass (m = kg), viscous damping
% coefficient (c = N s/m) and the spring constant (k = N/m)

% OUTPUT yd: vector of derivatives of ssv

% NOTE: t & y must be the functions two arguments, but the function does
% not need to use them
function [yd] = yn(t,y,params)

% extract parameters
m = params(1); c = params(2); k = params(3);

% pre allocate
yd = zeros(length(y),1);

yd(1) = y(2);
yd(2) = -(c/m)*y(2) - (k/m)*y(1);

return;