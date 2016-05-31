% This function calculates the steady state temperature distribution in a
% flat rectangular plate of width W and lenght L, with three sides held at
% T1 and one side held at T2.
%
% Accepts the input parameter n, which is an upper bound on the number of
% terms to use in the series approximation.
%
% Returns a function of x and y which can be used to evaluate the
% temperature at the point (x,y)
%
% example 1)
% temp(19); -> gives the floor(19/2) term approximation to the analytical
% result of the temperature distribution T(x,y)


function T = temp(n)

% initialize parameters and boundary conditions
T1 = 50;
T2 = 210;
W = 2;
L = 3;
N = ceil(n/2);% thanks Josh!
w = @(x,y) (0);

% build the function symbolically
for k = 1:N
    a = 2*k - 1;
    w = @(x,y) (w(x,y) + sin(a*pi.*x/L).*sinh(a*pi.*y/L)./(a...
        .*sinh(a*pi*W/L)));
end

T = @(x,y) ((T2 - T1)*(4/pi)*w(x,y) + T1);

