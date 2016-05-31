%% 1. kinematic eqn of a rocket
t = linspace(0,30,500);

% a.
figure('name','Rocket');
% we can call a function within a script as long as it's on the PATH
plot(t, prob1(t)); xlabel('time seconds'); ylabel('height meters'); grid on;

% b.
% i. analytic solution
% ii. use ginput on the plot
% iii. use the max function on the data
% iv. use fminsearch

% i.
% see pdf

% ii.
[x, y] = ginput;

% iii.
[maxHeight ind] = max(prob1(t));
maxTime = t(ind);

% iv.
t0 = 12;% our initial guess (we could also use a value from ginput)
% we search on the negative of our function
[t_min, h_min] = fminsearch(@(t) -prob1(t),t0);
h_max = -h_min;

%% Capacitance of two parallel conductors

% a.
% L = 1cm, r = 1mm, d = 4mm
C = prob2(10, 1, 4);

%b
L = 12;
r = 1.5;
d = linspace(3,5);% d goes from 3 to 5cm
figure('name','Parallel plate capacitors');
plot(d, 1e12*prob2(L, r, d)); xlabel('d mm'); ylabel('C pF'); grid on; hold on;
title('parallel plate capacitors');
axis([3 5 0 10]);
cap = 3.*ones(1,100);
plot(d,cap);
%[x,y] = ginput;
% use fzero
x0 = fzero(@(d) 1e12*prob2(L, r, d) - 3, 3.10);

% loglog plot
figure('name','log of capacitance');
% change the linspace so that we don't take log of negatives
d = linspace(3,5);% d goes from 3 to 5cm
loglog(d, 1e12*prob2(L, r, d));
xlabel('d mm'); ylabel('C pF'); grid on; hold on;
title('loglog plot of parallel plate capacitors');
axis([3 5 0 10]);
cap = 3.*ones(1,100);
plot(d,cap);

%% 3. Using fzero & fminsearch on a polynomial

x = linspace(-20, 20, 500);
y = @(x) (x.^3 + 5.*x.^2 - 3.*(x - 6) - 40);

% a. The function has global min/max of +/- inf at the tails
figure('name','polynomial extrema');
plot(x, y(x)); grid on; xlabel('x'); ylabel('y(x)');
title('global features');

% b. find the roots and local extrema analytically


% c. we zoom in to find the local extrema
figure('name', 'local extrema');
plot(x, y(x)); grid on; xlabel('x'); ylabel('y(x)');
axis([-6 5 -200 200]);
title('local extrema');
[xx yy] = ginput;

% find the zeros of the polynomial. Our initial guess by inspection is
% x = -5, -2, 2

zero1 = fzero(@(x) y(x), -5);
zero2 = fzero(@(x) y(x), -2);
zero3 = fzero(@(x) y(x), 2);

% find the local minimum. Our intial guess by inspection is x = 0
[x_min y_min] = fminsearch(@(x) y(x), 0);
% find the local maxmimum. Our intial guess by inspection is x = -3
[x_max y_max] = fminsearch(@(x) -y(x), -3);
y_max = -y_max;%flip the sign to make it our local max

%% 4. Water volume in a reservoir

% this works, but it's no good for fminsearch
volume = @(r,t) (10^9 + 10^8 .* (1 - exp(-t./100)) - r.*t);

r = linspace(0,2e7);
t = linspace(0,100);

[R T] = meshgrid(r,t);
figure('name','Reservoir volume');
meshc(R, T, volume(R,T)); xlabel('rate'); ylabel('time'); zlabel('volume');

% if we want to use fminsearch
v = @(x) (10^9 + 10^8 .* (1 - exp(-x(2)./100)) - x(1) .* x(2));

% we use fzero to find how many days it will take for the reservoir to
% reach 2/3 its original volume of 10^9 liters

volume = @(r,t) (10^9 + 10^8 .* (1 - exp(-t./100)) - r.*t);
% Our initial guess is 20 days
time_for_two_thirds = fzero(@(t) volume(2e7,t) - (2/3)*10^9, 20);

%% 5. Finding global extrema of a 2 variable function

clear x y;
z = @(x,y) (-x .* y .* exp(-(x.^2 + y.^2)./3));

x = linspace(-5,5);
y = linspace(-5,5);

[X Y] = meshgrid(x,y);
figure('name','Global extrema');
meshc(X,Y,z(X,Y)); xlabel('x'); ylabel('y'); zlabel('z'); grid on;

% a.

f = @(x) (-x(1) .* x(2) .* exp(-(x(1).^2 + x(2).^2)./3));

% find the global minimum values
[x_min1, f_min1] = fminsearch(@(x) f(x), [-1 -1]);
[x_min2, f_min2] = fminsearch(@(x) f(x), [1 1]);

% find the global maximums values
[x_min3, f_min3] = fminsearch(@(x) -f(x), [2 -2]);
[x_min4, f_min4] = fminsearch(@(x) -f(x), [-2 2]);

f_max1 = -f_min3;
f_max2 = -f_min4;

% b.
 
[xmin, fmin, flag, output1] = fminsearch(@(x) f(x), [-1 -1]);
% check output.message and tweak the options

opts = optimset('TolX', 1e-6,'TolFun', 1e-6, 'MaxFunEvals', 1e6, 'MaxIter', 1e6);
% if none provided default options are used
[xmin, fmin, flag, output2] = fminsearch(@(x) f(x), [-1 -1], opts);




