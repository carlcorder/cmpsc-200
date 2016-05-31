%% Using random numbers to create simulated data
% A convergence test is run to ensure enough samples were created.
% The simulated data is analyzed for its statistical properties to make
% predictions.

% cutting 1x1 sq ft tiles with imperfect tools:

% The saw making the horizontal cut is normally distributed with a mean of 
% 12 inches and a standard deviation of 0.2 inches

% The saw making the vertical cut is normally distributed with a mean of 12
% inches and a standard deviation of 0.15 inches

% We assume the two cuts are independent of each other

% if f and g are gaussian then f*g is also gaussian, but this does not
% guarantee that the product of the densities is in fact a density.
% To see the correct probability density function,
% Look at the "Normal Product Distribution" -> a modified
% bessel function of the second kind or a linear combination of two chi
% squared distributions
clear all; close all; clc;
%% 1.
n = 1e5;% don't go past 1e7
h = 12 + 0.2*randn(1,n);
v = 12 + 0.15*randn(1,n);

bins = ceil(log2(n) + 1);% bin size

hv = [h' v'];
A = h .* v;

% we note that A looks normal, but we will need to run a test on it to be
% sure
figure(1);
[freq center] = hist(A,bins);
bar(center, freq/sum(freq),'y');
grid on; xlabel('Area [sq in]'); ylabel('Relative Frequency');

mu = mean(A);% around 144 (12x12)
s = std(A);% around 3
% Var(XY) = Var(X)Var(Y) + Var(X)E(Y)^2 + Var(Y)E(X)^2 =
% (0.2)^2 * (0.15)^2 + (0.2)^2 * (12)^2 + (0.15)^2 * (12)^2 = 9.0009

%% 2.
% how many samples are enough? We can tell if we are using enough data
% points by looking at convergence. How many samples does it take in order
% to obtain convergence.

% we test for convergence based on the mean of subsets of A

N = 10:n;% number of tiles used in our subset of A
m = zeros(1,length(N));

for k = 1:length(N)
    m(k) = mean(A(1:N(k)));
end

% graphically, it takes about 1e4 samples in order for the mean to converge
figure(2);
%plot(N,m);
semilogx(N,m);
grid on; xlabel('Number of Samples'); ylabel('Mean Area [sq in]');
title('Convergence');

%% 3. Acceptable Tiles
% the purchaser of the tiles has requirements that the dimension of the
% tile (h and v) must fall within the range of [11.75,12.25] inches

filter = (hv(:,1) > 11.75 & hv(:,1) < 12.25) & (hv(:,2) > 11.75 & hv(:,2));
pass = [(hv(:,1).*filter) (hv(:,2).*filter)];

good = (h < 12.25) & (h > 11.75) & (v < 12.25) & (v > 11.75);

% what percentage of the tiles are good (sellable)
percent_good = sum(good)/length(good);% about 70%

%% 4. Above and Beyond
% Say we find a way to improve precision of our horizontal cuts and
% decrease the standard deviation to from s = 0.2 to s = 0.1. How will this
% change the percentage of tiles that pass the given requirements?

