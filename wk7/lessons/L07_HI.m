%% Overdetermined systems

% we determine the best fit line, plane, etc.. to go through observed or
% empirical data points. This is similar to curve fitting, but we can do a
% better job with multiple independent variables

% * more LI eqns than unknowns
% * matrix A has more rows than columns
% * if rank([A b]) < length(b), the system may have a unique solution

% if we can't find a unique solution then we try to find the coefficients
% that provide the best fit for our data. 

% * same as linear regression using least squares
% * looking at systems with one or multiple independent variables
% * similar to methods used in curve fitting toolbox
% * A contains ind variables (data matrix) and b contains dependent observables
% * still solving Ax = b -> x = A\b

%% Example
clear all; close all; clc;

% best fit regression for a small set of data points

% we make 3 observations, measuring two independent variables (columns of
% A) and one dependent variable that is the column vector b. Each row of A 
% being an observation of the data.

A = [2 0;
    0 1;
    2 2];

b = [1 3 10]';

% note there is not a unique solution for Ax = b i.e. rref([A b]) is
% inconsistent
x_data = A(:,1);% first column of A
y_data = A(:,2);% second column of A
z_data = b';

% plot observations
figure(1); title('No Constant Term');
plot3(x_data,y_data,z_data,'ko','MarkerSize',15); grid on;
xlabel('x'); ylabel('y'); zlabel('z'); hold on;

% using regression, find the plane which best fits all of the
% data points or best passes through the data cloud. In this example we 
% only have 3 data points so there will be a plane which exactly passes
% through all the data. But, this is not always the case.

x_estimate1 = A\b;% [0.75; 4.00] -> 3x/4 + 4y = z -> plane of best fit
b_estimate1 = A*x_estimate1;% [1.5; 4.0; 9.5]

xx = linspace(0,2); yy = linspace(0,2);
[X Y] = meshgrid(xx,yy);
z = @(x,y) (0.75 .* x + 4.00 .* y);

% note the plane does not pass through all of the data points
mesh(X,Y,z(X,Y)); hold on;

% residual
res1 = b - b_estimate1;
s1 = sum(res1.^2);

% we can do a different fit by adding a constant term (c)
% QUESTION: does c need to be all ones?
c = [1; 1; 1;];

% appending this constant term column to the matrix A we have
Ac = [A c];

% again solving for x we have
x_estimate2 = Ac\b;% [1.25; 4.5; -1.5] -> 1.25x + 4.5y - 1.5 = z -> 

% plot the plane of best fit with constant term over the data
figure(2); title('Constant Term Added');
plot3(x_data,y_data,z_data,'ko','MarkerSize',15); grid on;
xlabel('x'); ylabel('y'); zlabel('z'); hold on;

% overlay plane of best fit
z = @(x,y) (1.25 .* x + 4.5 .* y - 1.5);
mesh(X,Y,z(X,Y)); hold on;


b_estimate2 = Ac*x_estimate2;% [1; 3; 10] -> estimates b exactly -> 
% this is because we only have 3 points. If we add another point that is not
% directly on the plane, the residual value will be non zero
res2 = b - b_estimate2;
s2 = sum(res2.^2);

% based on this regression we can now make estimates on data points that we
% have not measured

p = [1.5 0.5 1];% [x y c] -> point = p = (x,y) & c = 1
% estimate the value of b at the point p
b_at_p = p*x_estimate2;

% notice the estimated point in red lies on the plane
plot3(p(:,1),p(:,2),b_at_p,'r.','MarkerSize',20,'MarkerFaceColor','r');

% x = A\b finds the plane which minimizes res = Ax -b
