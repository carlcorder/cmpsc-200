%% 1. Lifespans of human red blood cells from a clinical experiment.
clear all; close all; clc;

% lifespans of red blood cells in days
lifespans = csvread('blood.csv');

% use Rice's formula to determine the number of bins
bins = ceil(2 * length(lifespans)^(1/3));

% get the frequency of the data per bin and the center of each bin
[freq, center] = hist(lifespans,bins);

% a) plot relative frequency histogram
figure('name','Lifespans of Red Blood Cells');
bar(center, freq/sum(freq),'y');
grid on; xlabel('Time [days]'); ylabel('Relative Frequency');

% b)
% NOTE:
% use Lilliefors test to determine if data is normally distributed
% p > 0.05 -> h = 0 -> do not reject null hypothesis
% p < 0.05 -> h = 1 -> reject null hypothesis

% because h = 1 -> we reject the null hypothesis and conclude that this
% data is NOT normally distributed.
[h_blood, p_blood] = lillietest(lifespans);

%c)
median_lifespan = median(lifespans);
percentile_95 = quantile(lifespans,0.95);
percentile_05 = quantile(lifespans,0.05);

%% 2. Simulate the throwing of two six sided dice

% set the total number of dice throws
throws = 1e5;

% NOTE:
% generate a random number on the intervale [a,b]
% (a - 1) + randi(b - a + 1,rows,cols)

% throw die 1
die_1 = randi(6,1,throws);
% shuffle the random number generator
rng('shuffle')
% throw die 2
die_2 = randi(6,1,throws);
% add dice
dice_total = die_1 + die_2;

% a) plot the relative frequency histogram for the sum of the dice
%centers = 1.5:1:11.5;
bins = 11;
edges = 2:1:12;
figure('name','Sum of Two Dice');
[freq] = hist(dice_total,bins);% can optionally replace bins with centers
bar(edges, freq/sum(freq),'c');
grid on; xlabel('Sum'); ylabel('Relative Frequency');

% b) assess if we can treat this as a normal distribution
% h = 1 and p < 0.05 -> NOT normally distributed
% this is in fact a uniform sum distribution with n = 2 -> triangle
% distribution
[h_dice, p_dice] = lillietest(dice_total);

% c)
% should be 1/36 + 2/36 = 3/36 = 1/12 = 0.08333..
P_of_11_or_12 = sum(freq(10:11))/sum(freq);

%% 3. Weight of lobsters caught in MA

lobsters = csvread('lobster.csv');

% use Sturges' formula to calculate the number of bins
bins = ceil(log2(length(lobsters)) + 1);% 18

% a)
[freq, center] = hist(lobsters,bins);
figure('name','Weight of Lobsters in MA');
bar(center, freq/sum(freq),'r');
grid on; xlabel('Weight [oz]'); ylabel('Relative Frequency');

% b)
avg_lobster = mean(lobsters);% 20.0266
dev_lobster = std(lobsters);% 2.2750

% c)
% p > 0.05 -> h = 0 we accecpt the null hypothesis that this data is
% normally distibuted
[h_lobster, p_lobster] = lillietest(lobsters);

% d)
% there is a very close agreement between our raw data and estimated normal
% distribution
% i) using our raw data
over_24 = sum(lobsters > 24)/length(lobsters);% 0.0406
% ii) using a normcdf model
above_24 = 1 - normcdf(24,avg_lobster,dev_lobster);% 0.0404

%% 4. Monte Carlo simulation of pallet weight

boxes = 10;
num_x = 225;
num_y = 175;
ppp_x = boxes*num_x;
ppp_y = boxes*num_y;

% x is normally distributed
xbar = 1.2;
sx = 0.13;
vx = sx^2;% 0.0169

% y is uniformly distributed
ymin = 1.1;
ymax = 1.2;
ybar = (ymin + ymax)/2;
vy = (1/12)*(ymax - ymin)^2;% 0.0008333..
sy = sqrt(vy);% 0.028867..

% assuming x and y are independent -> covariance = 0
% Var(aX + bY) = a^2*Var(X) + b^2*Var(y) - 2ab*Cov(X,Y)
avg_pallet = (ppp_x*xbar + ppp_y*ybar);% 4,712.5 lbs
% the sum of normally distributed variates is normal. The sum of uniformly
% distributed variates also approaches normality (Irwin-Hall distribution).
% Thus, to find the variance, we look at the 'sum of normally distributed
% random variables'.
var_pallet = ppp_x*vx + ppp_y*vy;
s_pallet = sqrt(var_pallet);%

% specify number of pallets and create enough parts to fill them all
num_pallets = 5e4;
% parts x
x = xbar + sx*randn(1,num_pallets*ppp_x);
% parts y
y = ymin + (ymax - ymin) * rand(1,num_pallets*ppp_y);

% pre allocate pallets
pallets = zeros(1,num_pallets);

% fill the pallets with parts
for i = 1:num_pallets
    pallets(i) = sum(x((i-1)*ppp_x + 1 : i*ppp_x)) + ...
                 sum(y((i-1)*ppp_y + 1 : i*ppp_y));
end

% a)
% we numerically compute the mean and standard deviation of the pallet
% weight
mean_pallet = mean(pallets);% theoretical is 4,712.5 lbs
std_pallet = std(pallets);% theoretical is 6.2836 lbs

% b)
% use Sturges formula to compute the number of bins
bins = ceil(log2(num_pallets) + 1);
figure('name','Monte Carlo Simulation of Pallet Weights');
[freq center] = hist(pallets,bins);
bar(center, freq/sum(freq),'m');
grid on; hold on;
xlabel('Pallet Weight [lbs]'); ylabel('Relative Frequency');

% overlay a normal distribution
x = linspace(min(pallets),max(pallets),1e3);
norm = normpdf(x,avg_pallet,s_pallet);
% scale by 3.10 because our bin size is finite
plot(x,3.10*norm,'r--');

% c)
% we test for convergence based on the mean of subsets of pallets

N = 10:num_pallets;% number of pallets used in our subset
m = zeros(1,length(N));

for k = 1:length(N)
    m(k) = mean(pallets(1:N(k)));
end

% by graphical inspection, it is reasonable to assume that a sample size
% greater than 1e4 is required for the simulated to mean converge within
% tolerable bounds of the true mean.
figure('name','Convergence of the Mean');
semilogx(N,m);
grid on; xlabel('Number of Samples'); ylabel('Mean Weight [lbs]');

% d)
% p > 0.05 -> h = 0 -> we accept the null hypothesis that the data is
% sourced from a normally distributed variable
[h_pallet, p_pallet] = lillietest(pallets);

% e)
% i) percent of overloaded pallets based on simulated data
overload = sum(pallets > 4735)/num_pallets;%1.0e-04
% ii) percent of overloaded pallets based on normal cumulative dist
above_4735 = 1 - normcdf(4735,mean_pallet,std_pallet);%1.8e-04