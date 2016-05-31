%% 1. System of Linear Eqns
close all; clear all; clc;
% transcribe the eqns into a matrix
A = [1  5 -1  6;
     2 -1  1 -2;
    -1  4  0  3;
     3 -7 -2  1];
     
b = [22 6 14 -45]';

% a) because A is a square matrix, a unique solution exists if A is
% invertible i.e. det(A) != 0
determinant = det(A);% -41 != 0 -> unique solution exists

% b) find the solution to Ax = b
x = A\b;% [5.26 10.12 -8.56 -7.07]'

%% 2. Temperature Distribution of a Flat Plate

% The plate is divided into sub elements with fixed temperatures T1, T2, T3
% & T4. Two sides are held at a fixed temperature: Ta & Tb, the remaining
% sides are insulated. No heat flow is allowed through the boundry.

Ta = 180; Tb = 25;

T = [3 -1 -1  0;
     1 -2  0  1;
     1  0 -2  1;
     0 -1 -1  3];

boundry = [Ta 0 0 Tb]';

% a) calculate the temp of each inner element by solving the LSE
temps1 = reshape(T\boundry,2,2);% [128.33 102.50 102.50 76.66]'

% b) create a more fine grained temperature distribution of the plate.
% -> see method of relaxation & poisson's eqn for more details on this.
% NOTE: we have non period boundry conditions

% to set up the eqns, we use lse_plate with 2 iterations to build the
% laplacian matrix
iter = 2;
[T2 boundry2] = lse_plate(iter);
% i.
temps2 = reshape(T2\boundry2,2^iter,2^iter);

% ii.
figure('name','Temperature Distribution of a Hot Plate');
subplot(2,1,1);
% scale the temperatures to match the 2nd iteration
temps1 = [repmat(temps1(1),2) repmat(temps1(3),2); ...
    repmat(temps1(2),2) repmat(temps1(4),2)];

b = bar3(temps1); c = colorbar; ylabel(c,'Temp [\circC]');
colormap('jet'); xlabel('x'); ylabel('y'); title('2 x 2');
hold on;

% color bars by height
for k = 1:length(b)
    zdata = b(k).ZData;
    b(k).CData = zdata;
    b(k).FaceColor = 'interp';
end

subplot(2,1,2);
bar3(temps2);

b = bar3(temps2); c = colorbar; ylabel(c,'Temp [\circC]');
colormap('jet'); xlabel('x'); ylabel('y'); title('4 x 4');
hold on;

% color bars by height
for k = 1:length(b)
    zdata = b(k).ZData;
    b(k).CData = zdata;
    b(k).FaceColor = 'interp';
end

% c) let's try one more iteration
iter = 3;
[T3 boundry3] = lse_plate(iter);

temps3 = reshape(T3\boundry3,2^iter,2^iter);

figure(2);
b = bar3(temps3); c = colorbar; ylabel(c,'Temp [\circC]');
colormap('jet'); xlabel('x'); ylabel('y'); title('4 x 4');
hold on;

% color bars by height
for k = 1:length(b)
    zdata = b(k).ZData;
    b(k).CData = zdata;
    b(k).FaceColor = 'interp';
end

% at 3 iterations, we are now approaching the equilibrium distribution

% d) a for loop implementation of the iterative method of relaxation would
% nicely handle a model using mxn elements.

%% 3. Applications in Linear Circuits

R1 = 1e3; R2 = 4e3; R4 = 2e3; R5 = 7e3;% [k Ohms]
v = 100;

% a) translating kirchoff's voltage and current law eqns into a matrix

VI = @(R3)([0   R2  0    R4  0   0;
            R1 -R2  R3   0   0   0;
            0   0  -R3  -R4  R5  0;
            1   1   0    0   0  -1;
            0   1   1   -1   0   0;
            1   0  -1    0  -1   0;
            0   0   0    1   1  -1]);
  
b = [v 0 0 0 0 0 0]';

% b)
I = @(R3) (VI(R3)\b);
% HACKERY ENSUES, but it works -> please tell me there is another way..
I4 = @(R3) (getfield(I(R3),{4})); i4 = 0.0201;

% we wrap I4 in arrayfun because fzero requires a function that can evaluate
% a vector..not just a single value at one time. This outputs a cell which
% we then convert into a matrix

amp = @(r) cell2mat(arrayfun(@(x) I4(x),r,'UniformOutput',false));

r3 = fzero(@(r) (amp(r) - i4),9e3);% 8.3095 kOhms

%% 4. Fuel Economy of Different Car Models

% load the data [num, text, raw]
[~, model, ~] = xlsread('/home/carl/MATLAB/ANGEL/HWs/wk7/mpg.xlsx','A2:A83');
auto_data = xlsread('/home/carl/MATLAB/ANGEL/HWs/wk7/mpg.xlsx','B2:D83');
power = auto_data(:,1);% horsepower [hp]
weight = auto_data(:,2);% [lbs]
mpg = auto_data(:,3);% [mpg]

% discard data once it has been properly stored
clear auto_data;

% a) plot the data as individual points in 3D
scatter3(weight,power,mpg,'k.'); hold on;
xlabel('[lbs]'); ylabel('[hp]'); zlabel('[mpg]');

% b) calculate and show the equation for a linear regression to find fuel
% efficiency (mpg) as a function of both engine power and vehicle weight

% assemble the coefficient matrix with a constant term
A = [weight power ones(length(power),1)];
b = mpg;

% solve Ax = b to find the plane of best fit
% same as regress(b,A)
xsol = A\b;% -0.0099*x - 0.0210*y + 66.8550 = z

% look at the residuals
residuals = A*xsol - b;
res = norm(residuals);% 37.8236

% b)
% plot the plane of best fit
xx = linspace(min(weight),max(weight));
yy = linspace(min(power),max(power));
[X,Y] = meshgrid(xx,yy);
z = @(x,y) (xsol(1).*x + xsol(2).*y + xsol(3));
surf(X,Y,z(X,Y),'EdgeColor','none','FaceAlpha',0.6); hold on;

% c) estimate the mpg for a car that weighs 3,300 lbs and has a 120 hp
% engine
p = [3300 120 1];
mpg_estimate = p*xsol;
scatter3(p(1),p(2),mpg_estimate,'rp'); hold on;
legend('Raw Data','Plane of Best Fit','Mpg Estimate');






