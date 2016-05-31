%% Numerical Integration of Analytic Function, Example 3
% double integration of a complicated function with two variables in order
% to find the volume under the surface of a function within a defined area.

% we use numerical cubature -> integral2 function to solve this

z = @(x,y) 3 + sin(x.*y).*cos(y.^2);% vector form

x = linspace(0,5,1e3); y = x;
[X,Y] = meshgrid(x,y);

% mesh plot
figure('name','Numerical Cubature');
mesh(X,Y,z(X,Y)); xlabel('x'); ylabel('y'); zlabel('z');
title('$z = 3 + \sin\left(xy\right)\cos\left(y^2\right)$',...
    'interpreter','latex','FontSize',15);
axis([0 5 0 5 0 5]);% x,y,z -> [0,5]

I0505 = integral2(@(x,y) z(x,y),0,5,0,5);% 76.6840

% we could have more complicated curved boundries such as circles etc..in
% this case integral2 does not work as well. We can better deal with such
% limits using Monte Carlo integration 
