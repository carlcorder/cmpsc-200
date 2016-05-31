% This function is based on the Collatz conjecture which comes about while
% playing a game with the following rules:
%
% given a positive integer N, if N is odd, multiply it by 3 and add 1. If N
% is even divide it by 2. Repeat this process until the sequence
% terminates. The conjecture is that for all inputs N, every game will
% terminate with a value 1.
%
% Input: positive integer N to serve as the starting point
%
% Output: an array of integers which represents the sequence of numbers
% visited while following the game rules. The number of iterations taken
% before the game terminates. The maximum value achieve (and the index)
% during duration of gameplay.

function [seq iter max_info] = collatz(N)

% initialize the sequence
seq = [N];

% keep checking until we have reached 1
while N > 1
    % even
    if mod(N,2) == 0
        N = N/2;
        seq = [seq N];
    % odd    
    else 
        N = 3*N + 1;
        seq = [seq N];
    end
    % count the number of iterations
    iter = length(seq) -1;
    % find the maximum value in the sequence and its index
    [S, I] = max(seq);
    max_info = [S, I - 1];
end