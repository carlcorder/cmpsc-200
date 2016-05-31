%% Numerical Integration of Analytic Functions, Example 1
% we calculate the definite integral of a function of one variable using
% quadrature

% definite integral x = [0,5] of f(x) = exp(sin(x^2)) -> analytic solution
% not easily obtained.

clear all; close all; clc;

% define the function
y = @(x,c) exp(sin(c*x.^2));

c = 1;% set the frequency

% create the space
xt = linspace(0,5,1e3);

%plot(xt,y(xt),'k-');
figure('name','Numeric Integration 1');
h = area(xt,y(xt,c)); h.FaceColor = [0.9 0.9 0.9];
xlabel('x'); ylabel('y'); grid on; hold on;
% use latex to display the title
title('$y = e^{\sin x^2}$','interpreter','latex','FontSize',15);

% integrate y from x = 0 to x = 5
integral(@(x) y(x,c),0,5);% 6.7975 when c = 1

%% Example 2
% we allow our upper bound to now be a variable and evaluate the definite
% integral for different values of the upper bound.

% this could be useful if we have velocity data and we want to know the
% position of our particle at any given time tf. Then we would integrate
% our velocity from v0 to vf.

clear all; close all; clc;

y = @(x) exp(sin(x.^2));

% create the space
xt = linspace(0,5,1e3);

% integral is a function of our upper bound
I = @(t) integral(@(x) y(x),0,t);

I5 = I(5);% same results in example 1 (6.7975), but no longer hard coded

% the integral function can only accept scalars as parameters for the
% bounds. So in order to generate a list of integral data we evaluate I in
% a for loop.

te = linspace(0,5,1e3);

% pre allocate integral data with zeros
Y = zeros(length(te),1);

for k = 1:length(te)
    Y(k) = I(te(k)); 
end

figure('name','Numeric Integration 2');
h = area(xt,y(xt)); h.FaceColor = [0.9 0.9 0.9];
xlabel('x'); ylabel('y'); grid on; hold on;
% use latex to display the title
title('$y = e^{\sin x^2}$','interpreter','latex','FontSize',15);

plot(te,Y,'k-');