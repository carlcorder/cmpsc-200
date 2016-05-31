%% Normal Product Distribution
% The product of two normal distributions..
% This should be a modified Bessel function of the second kind (BesselK)
n = 1e7;
%bins = ceil(log2(n) + 1);
% this is the optimal number of bins so that our histogram matches our
% model
bins = 70;
% A normal distribution with mean 'b' and standard deviation 'a' is given
% by a .* randn(1,n) + b
sigmaX = 1;
sigmaY = 2;
muX = 0;
muY = 0;
X = sigmaX .* randn(1,n);
Y = sigmaY .* randn(1,n);

K = X .* Y;
sigmaK = std(K);%predict it should be sqrt(1^2 * 2^2) = 2
muK = mean(K);%predict it should be 0

[freq center] = hist(K,bins);
bar(center, freq/sum(freq),'y');
grid on; xlabel('u = xy'); ylabel('P(u)'); hold on;

sigmaK = std(K);%predict it should be sqrt(1^2 * 2^2) = 2

u = linspace(min(K),max(K),bins);
BesselK = ...
    besselk(0,abs(u)/(sigmaX * sigmaY))./(pi * sigmaX * sigmaY);
plot(u,BesselK);