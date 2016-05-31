%% Histograms, bars and bin sizing
% hist = value of data vs frequency it appears
clear all; close all; clc;

load /home/carl/MATLAB/ANGEL/code/mat/L05_sample

% by default there are 10 bins in a histogram
subplot(3,1,1)
hist(A,10); grid on;
title('Standard');

% the hist looks different depending on the number of bins. What is the
% proper number of bins to use?

% Sturges' rule: the number of bins (k) should be 
% k = ceil(log2(n) + 1) where n is the number of data points
n = length(A);
k = ceil(log2(n) + 1);% 8
subplot(3,1,2);
hist(A,k);
title('Sturges');

% Rice's rule: k = ceil(2*n^(1/3))
k = ceil(2*n^(1/3));% 10
subplot(3,1,3);
hist(A,k);
title('Rice');

% we can get the data out of hist - frequencies and center of each bin
[f c] = hist(A);
figure(2);
bar(c,f,'g'); axis tight;

% indicate bin centers on the x-axis
h = gca;
set(h,'XTick',c);

% we can use relative frequencies in our histogram
rel_f = f/sum(f);
figure(3);
bar(c,rel_f); ylabel('%'); grid on;

quan5 = rel_f(1) + rel_f(2);% 0.05 -> 5 percentile
% this should give us the right edge of the second bar
alt_quan5 = quantile(A,0.05);