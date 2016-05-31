%% 3. Quality control on a batch of resisters
% You recieve an order of one million 50 ohm resistors. You take a random
% sample of 200 as a control batch and measure each resistance by placing
% them into a test circuit and measuring the associated voltage and
% current 25 times. You then find the resistance using ohm's law (V = IR).
close all; clear all; clc;

% supress warnings (fit requires a starting point) 
w = warning('off','all');

% read in the data, each column represents a different resistor and each row
% represents an individual measurement
v = csvread('voltage.csv');% 25x200
i = csvread('current.csv');% 25x200
N = length(v);
% NOTE: the mean function is not a "linear" operator
% i.e mean(v ./ i) != mean(v) ./ mean(i)
%R = v./i;
% row vector of mean resistor values
%Rbar = mean(R);

% linear regression (V = IR) ASK: should I use a y-intercept?
% allowing a small DC voltage for noise in the circuit.
ft = fittype('v0 + R*x');

% pre allocate memory for resistor & v0
R = zeros(1,N);
v0 = zeros(1,N);

% extract the R value from the best fit line
for k = 1:N
    V = fit(i(:,k),v(:,k),ft);
    R(k) = V.R;
    v0(k) = V.v0;
end

% a) create a relative frequency histogram of your estimated resistances
bins = ceil(log2(N) + 1);
[freq, center] = hist(R,bins);
figure('name','Quality Control of Resistors');
bar(center, freq/sum(freq),'y'); hold on;
grid on; xlabel('Resistance [\Omega]'); ylabel('Relative Frequency');

% b) is the resistance normally distributed

% p = 0.05 -> h = 0 we accecpt the null hypothesis that this data is
% normally distibuted
[h, p] = lillietest(R);

% c) require all resisters to be 50 +/- 2 ohms to be acceptable
r = 50;
tol = 2;
pass = sum(R < (r + tol) & R > (r - tol))/length(R);% 80% pass rate

% alternatively since we can model the data with a normal distribution.
% but should we use Rbar or r = 50 for the mean, and what should we use for
% the standard deviation? 
Rbar = mean(R);% 50.8109
Rstd = std(R);% 1.3382
norm0 = (1/(Rstd*sqrt(2*pi)));% 0.2981 vs 0.27 -> almost no scaling needed
scale = (max(freq)/sum(freq))/norm0;
% overlay a normal distribution
x = linspace(min(R),max(R),1e3);
norm = normpdf(x,Rbar,Rstd);
plot(x,scale * norm,'r--');
