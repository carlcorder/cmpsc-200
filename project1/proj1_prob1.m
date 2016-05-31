%% 1. Simulated trade of Quorzonium

% the price of Quorzonium over the past year is approximately normally
% distributed with mean $225 per ounce and standard deviation of $8. We 
% assume there is no temporal correlation in the price (i.e. the value
% between any two given days is independent).

% a) simulate the trading of 100 oz (daily) over one year (250 days) on
% the commodities market. You only have enough cash on hand to hold 100 oz
% at one time. Our tactic is to purchase 100 oz when the price drops below
% its mean and to sell when the price is above $232. Define profit as the
% sale price minus buying price on each transaction minus brokerage fees of
% $150. If the commodity is still owned at the end of the year, add its
% year-end value minus its price to your profit.

% define parameters
days = 250;% trading days per year
qty = 100;% ounces (the holding limit and max trade qty per day)
sell_trigger = 230;% USD
buy_trigger = 225; % USD
trade_fee = 150;% USD per transaction

% Quorzonium price parameters
quor_bar = 225;% USD mean price of Quorzo
quor_std = 8;% USD standard deviation

% number of trials / years that we repeat the exeriment
n = 1e4;
% simulate trade over n year(s) -> an (n x days) matrix
quor = quor_bar + quor_std*randn(n,days);

% there are no limitations on buying Quorzo
buy = quor < buy_trigger;
% Can't sell Quorzo if we don't have it, so these are just sale attempts
sale_attempt = quor > sell_trigger;

% cumulative sum of sale attempts
csa = cumsum(sale_attempt,2);

% cumulative sum of purchases
cb = cumsum(buy,2);

% true sales are a subset of our sale attempts
sell = sale_attempt;

for row = 1:n
    for col = 1:days
        if(csa(row,col) > cb(row,col))
            sell(row,col) = 0;
            csa(row,:) = csa(row,:) - 1;
        end
    end
end
clear row col;

% a history of how much Quorzo we have in our possession on any given day
in_stock = cumsum((buy - sell),2);

% buying and selling prices
purchases = qty * buy .* quor;
sales = qty * sell .* quor;

% brokerage fee associated with each buying & selling transaction
fees = trade_fee * (buy + sell);

% current value of Quorzo in possession
assets = qty * in_stock .* quor;

% track the daily influx of money
daily_profits = (sales - purchases) - fees;

% cash earnings to date
cash = cumsum(daily_profits,2);

% net gains = cash + assets
net = cash + assets;

% our net gain at the end of the year, repeated with n trials
annual_gain = net(:,end);
mu = mean(annual_gain);
s = std(annual_gain);

% i.
% we test for convergence based on the mean of subsets of annual gain

N = 10:n;% size of sample
m = zeros(1,length(N));

for k = 1:length(N)
    m(k) = mean(annual_gain(1:N(k)));
end

% by graphical inspection, it is reasonable to assume that a sample size
% greater than 1e4 is required for the simulated to mean converge within
% tolerable bounds of the true mean, which is in [1.06, 1.08]x10^5
figure('name','Convergence of the Mean');
semilogx(N,m);
grid on; xlabel('Number of Samples'); ylabel('Mean Annual Gain [USD]');

% ii.
% create a properly binned relative frequency histogram
bins = ceil(log2(n) + 1);
figure('name','Monte Carlo Simulation of Quorzonium Trade');
[freq center] = hist(annual_gain,bins);
bar(center, freq/sum(freq),'y');
grid on; hold on;
xlabel('Annual Gain [USD]'); ylabel('Relative Frequency');

% overlay line of loss
x = zeros(1,1e2);
y = linspace(0,max(freq/sum(freq)),1e2);
plot(x,y,'r--');

% b)
% Using the current strategy, we have about 80% certainty that we will net
% at least $52K for the year.
chance_of_52k = sum(annual_gain > 52e3)/n;

% c)
% there are many ways to adjust the strategy to give us a better expected
% value
% 1) increase our daily selling limit
% 2) buy lower or sell higher
% 3) be able to 'borrow' an intial amount of Quorzonium that you can sell
% up front in the case the market increases

% i.
% by simply decreasing the purchase trigger to $220. Our certainty of
% netting 52K goes up to 98%

