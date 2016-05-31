% constructs the adjacency matrix of a mxn 2D grid to create a mnxmn
% adjaceny matrix -> 1 if elements share an edge, 0 otherwise.

function adj = adj_mat(m,n)
% diagonals range from -(m*n - 1) to (m*n - 1)

% diagonal at r
er = ones(m * n,1);
% diagonal just off of main (length = m*n - 1)
e1 = repmat([ones(m - 1,1); 0],n,1);


% construct only half of the adjacency matrix (because spdiags is so
% stupid). The function works as expected for negative diagonal indexes.
adj = spdiags([e1 er],[-1 -m],m*n,m*n);
% finish by adding the transpose
adj = adj + adj.';
end




