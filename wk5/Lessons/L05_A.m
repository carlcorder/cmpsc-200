%% Statistical functions: mean, median, standard deviation etc..
clear all; close all; clc;

load /home/carl/MATLAB/ANGEL/code/mat/L05_sample

% Run section & highlighting + F9 is equivalent to typing the command in
% the Command Window. To get the proper behavior of this function we need
% to run the script from a batch job or by clicking the Run button in the
% Toolstip.
%path = mfilename('fullpath')

% these functions will work on vectors and matrices

% mean
avg1 = mean(A);
avg2 = sum(A)/length(A);

% median
med = median(A);

% mode
mod = mode(A);

% percentiles and quantiles - need the Statistics and Machine Learning
% Toolbox :(
quan25 = quantile(A,0.25);
quan90 = quantile(A,0.90);
quan50 = quantile(A,0.5);% should be the same as the median

% 10th - 90th percentiles
quans = quantile(A,[0.1:0.1:0.9]);

% standard deviation
standard = std(A);

% sorting (ascending by default)
sort_ascA = sort(A);
sort_descA = sort(A,1,'descend')% could use ascend as an option

% testing on a smaller data source
B = [1 3 3 5 9 10];
medB = median(B);
modeB = mode(B);

% testing on a matrix

% mean
C = rand(3);
meanC = mean(C);% will find the mean of each column
mean_colC = mean(C,1);% 1 -> col, 2 -> row
mean_rowC = mean(C,2);

% median
med_colC = median(C,1);
med_rowC = median(C,2);