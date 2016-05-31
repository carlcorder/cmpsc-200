%% Testing for Linear Independence
% we prove a set of linear equations has a unique solution by showing it
% has the same number of LI eqns as variables.

% properties of A for linear independence:

% * A must be square (look at the size(A))
% * A cannot be a singular matrix i.e. non zero determinant
% * the condition number of A is finite, if cond(A) >> 1e3 then A is assumed
%   to be a singular matrix

A1 = [3 2 -1;
    -1 0 2;
    1 -1 -1];% A is square

size = size(A1);% 3 x 3 square matrix
det1 = det(A1);% 7 != 0

clear A det;
A2 = [-3 2 -5; 2 -6 4; 1 1 1];

det2 = det(A2);% -6
% the condition of A will be a very large number when we don't have linear
% independence
cond = cond(A2);% 47.10

%% Test a system of eqns for LI and show there is not a unique solution
clear all; clc;

% 3x + y + z = 10
% -x + 3y + 2z = 5
% 6x + 2y + 2z = -1

% we can see by inspection that R2 = 2*R1 -> linear dependence 
A = [3 1 1; 
    -1 3 2; 
    6 2 2];

b = [10 5 -1]';

% it is a square matrix
size(A);

% but the determinant is zero -> so we cannot expect to have a unique
% solution for this
detA = det(A);
%inv = inv(A);% all infinities

% the condition of A
condA = cond(A);% 5.0106e16

% x = A\b also fails
x = A\b;% [NaN -Inf Inf]'

% let's change A slightly
A = [3 1 1; 
    -1 3 2; 
    6 2 3];

detA = det(A);% 10

condA = cond(A);% 22.04

x = A\b;

%% Using Linear Systems with unique solutions in Engineering

% Numerical evaluation of:
% *forces in mechanical structures
% *thermal systems
% *voltage in electrical systems
% *finite element analysis
% *systems may be extremely large sets of LI eqns

% Physics engines in computer simulations
% *simulate interaction of large scale dynamic systems

% Video games/real time simulations
% *Havok, Unreal, Unity
% *graphics cards solve giant systems of eqns very quickly



