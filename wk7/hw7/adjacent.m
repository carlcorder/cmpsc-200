% Function returns a list of elements adjacent to the element specified by
% the given index/value. This works for a 2D square counting arrays only.
%
% NOTE: The value of a counting array is the same as its index
%
% Input: index in column major order (start by counting down column 1)
% Input: square counting array ex: A = reshape(1:16,4,4)
%                                  A = [1 5  9 13;
%                                       2 6 10 14;
%                                       3 7 11 15;
%                                       4 8 12 16]
% Output: vector of adjacent elements ->
%               adjacent(A,2) = [1 3 6]
%
% Adjacent to A(i,j) -> A(i-1,j) A(i+1,j) A(i,j-1) A(i,j+1)

function adj_elems = adjacent(A,ind)
n = length(A);
shifts = [-n -1 1 n];
potential_neigh = ind + shifts;
% this filter needs to be modified as it doesn't work for edge cases
filter = potential_neigh > 0 & potential_neigh < n^2 + 1;
adj_elems = potential_neigh(filter);