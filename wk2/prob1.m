% This function accepts a time t > 0 as input and returns the height of a
% rocket.

function h = prob1(t)
% initialize constants
g = 9.8;
v0 = 125;
h0 = 500;

% calculate the height
h = -(1/2)*g.*t.^2 + 125.*t + 500;
