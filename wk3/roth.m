% A Roth IRA account with $5,500.00 initial investment with an annual rate
% of return of 8% and yearly contributions of %5,500.00 after 'n' years will
% yield a total greater than 'A'. NOTE: THIS FUNCTION TAKES THREE INPUT
% ARGUMENTS.
%
% This function needs n, the number of years invested. A, the principal
% desired on the investment and r, the interest rate on the investment.
%
% example 1)
% roth(1,[],[]);
% investment has grown to $11,440.00 after one year with the default rate
% of 8%
%
% example 2)
% roth([], 20000,[]);
% investment has exceeded the specified amount with the default interest
% rate of 8%
%
% example 3)
% roth(4,[],1.11);
% investment has grown to 3.4253 x 10^4 after 4 years at an 11% interest
% rate

function p = roth(n, A, r)

% interest rate (r), contribution amount (c) & initial investment (p)
if isempty(r)
r = 1.08;
end
c = 5500;
p = [5500];

if isempty(A)
    for k = 1:n
        p = [p (p(end)*r + c)];
    end

% we look when the investment reached the desired amount A.
elseif isempty(n)
    % initialize index (k)
    k = 0;
    while p <= A
        p = [p (p(end)*r + c)];
        k = k + 1;
    end
   
end

