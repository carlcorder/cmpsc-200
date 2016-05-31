%% Testing data sets for normaility

% We use Lilliefors test, a normaility based on the Kolmogorov-Smirnov
% test, which is a nonparametric (we make no assumptions about the
% distribution of the data) test to determine if two datasets differ
% significantly. The statistic D is the maximum vertical distance between
% the two cumulative fraction plots. The D statistic is not affected by
% scale changes.

clear all; close all; clc;

% height in mm
stature = xlsread('/home/carl/MATLAB/ANGEL/code/csv/ansur_men.xlsx','A2:A1775');

% use Sturges rule for the number of bins to use
k = ceil(log2(length(stature)) + 1);

% make histogram (this data looks normally distributed)
[freq, center] = hist(stature,k);
bar(center,freq/sum(freq),'c');
grid on; xlabel('Stature [mm]');

% get the mean and standard deviation
xbar = mean(stature);
s = std(stature);

% data that is not normally distributed (uniformly)
%Q = 1:0.05:90;
%hist(Q);

% the question is can we treat our stature data as normally distributed? 
% We use the Lilliefors test to determine this.


