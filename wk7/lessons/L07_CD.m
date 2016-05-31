%% Example 1) Solving system of linear equations
clear all; close all; clc;
% 3x + 2y - z = 10
% -x + 2z = 5
%  x - y - z = -3
% there is a unique solution

% convert the eqns into matrix form Ax = b
A = [3 2 -1;
    -1 0 2;
    1 -1 -1];% A is square

b = [10; 5; -3];% or use b = [10 5 -3]'

% solve this using 3 methods

% 1) inverse
tic;
x = inv(A)*b;
toc;
% 2) augmented matrix
tic;
rA = rref([A b]);
toc;
% 3) Gauss Jordan elimination
tic;
x = A\b;
toc;

% let's see how these methods compare when evaluating a larger matrix
clear all;

n = 3e2
A = rand(n,n);% 100 x 100 random elements
b = rand(n,1);% 100 x 1 random element column vector

% 1) inverse
tic;
x = inv(A)*b;
toc;
% 2) augmented matrix
tic;
rA = rref([A b]);
toc;
% 3) Gauss Jordan elimination
tic;
x = A\b;
toc;

% so the backslash operator is most efficient for larger systems
%% Example 2
clear all; close all; clc;

%2y = 5z - 14 + 3x
%-6y + 4z = -2x + 10
%z + x + y = 4

% Ax = b
A = [-3 2 -5; 2 -6 4; 1 1 1];
b = [-14 10 4]';


x = A\b;

x = inv(A)*b;

x = rref([A b]);