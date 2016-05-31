% This function sets up the linear system of equations (lse) for the
% temperature distribution over a plate with boundry values indicated by
% hw7 problem 2.
%
% We continue to split the plate into 4, 16, 64, ..., 4^n cells or a
% 2 x 2, 4 x 4, 8 x 8, ..., 2^n x 2^n grid

function [L boundry] = lse_plate(iter)
% initialze parameters
Ta = 180; Tb = 25;
n = 2^iter;
N = reshape(1:n^2,n,n);

% setup a logical array to indicate where our hot plate is NOT insulated.
% This is needed because an insulated neighboring cell does not contribute 
% to the cells average. Where as a cell adjacent to a set boundry temp does
hot = zeros(n,n);
hot([[1:n/2] [end - n/2 + 1:end]]) = 1;

% at this point, we can also build the boundry conditions
boundry = zeros(n,n);
boundry([1:n/2]) = Ta; boundry([end - n/2 + 1:end]) = Tb;
boundry = reshape(boundry,n^2,1);

% we need to construct the Laplacian matrix -> Degree matix - Adjacency
% matrix -> L = D - A

% degree kernel
K = [0 1 0;1 0 1;0 1 0];
grid = ones(n,n);
% construct the degree matrix
D = diag(reshape(conv2(grid,K,'same') + hot,n^2,1));
% construct the adjacency matrix
A = adj_mat(n,n);

L = D - A;
end