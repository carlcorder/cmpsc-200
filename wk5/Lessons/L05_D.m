%% Using Matlab to generate random numbers, vectors and matrices
% selected from a uniform or normal distribution

clear all; close all; clc;

% rng(0) will reset the random number generating seed
% rng('shuffle')
% rng('default')

% generate a random number uniformly distributed within [0,1]
rand

% 2x2 matrix of random numbers
rand(2)

% if the matrix is not square, specify both dimensions
rand(1,3)

% becomes more uniform as we use more points
x = rand(1e3,1);
hist(x);

% how do we generate a random number on the intervale [a,b]
% (b-a) * rand + a
a = 10;
b = 25;

x = a + (b - a) * rand(1e3,1);
hist(x);

% normally distributed random numbers (mean = 0, std dev = 1)
randn

x = randn(1,1e6);
% number of bins k
k = ceil(log2(length(x)) + 1);
hist(x,k);

% this should pass the lillietest (h = 0, p > 0.05)
%[h, p] = lillietest(x);

% normally distributed with mean of mu and std dev of s
mu = 1700;
s = 50;

x = mu + s*randn(1,1e6);
k = ceil(log2(length(x)) + 1);
hist(x,k);

% how does standard deviation effect the plot? As std dev increases the
% distribution spreads out
x = mu + s*randn(1,1e6);
y = mu + 3*s*randn(1,1e6);
hist([x' y'],k);

% random integers which are not picked from a continuous distribution but
% from a discrete distribution

% generate an integer between 1-10 inclusive
randi(10)

% row vector of 1000 numbers between [1,10]
% histograms don't work very well for randi, but we can still see that it
% is nearly uniformly distributed
x = randi(10,1,1e3);
hist(x);

% simulate coin flips (1 heads, 2 tails)
flips = randi(2,1,1e3);

% drawing cards with replacement
cards = randi(52,1,1e3);

% pick between a & b inclusive [a,b]
% (a - 1) + randi(b - a + 1,1,1e3)
a = 10;
b = 30;

x = (a-1) + randi(b-a + 1,1e2);
% plotting is a good way to check the bounds
plot(x,'.');

% create a 10x10 matrix of random integers within our desired range
x = (a-1) + randi(b-a + 1,10,10);

% psuedo random number generator -> not truly random



