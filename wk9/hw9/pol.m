% auxillary function for hw9 prob 3 - Van der Pol Oscillator

% INPUT t: time stamps
% INPUT y: vector of state space variables (ssv)
% INPUT u: damping coefficient

% OUTPUT yd: vector of derivatives of ssv

function dydt = pol(t,y,u)

% default dampening value
if isempty(u)
   u = 0; 
end

dydt = [y(2); u*(1-y(1)^2)*y(2)-y(1)];

return;