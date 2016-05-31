%% polynomial regression
% measureing 10 homes with different square ft to see how much electricity
% they use in kilowatt hours per month
clear all; close all; clc;

sf = [1290 1350 1470 1600 1710 1840 1980 2230 2400 2930];
kw = [1182 1172 1264 1493 1571 1711 1804 1840 1956 1954];

plot(sf,kw,'ko');
xlabel('Size [sq ft]'); ylabel('Energy Consumption [kWh/month]');
grid on; hold on;

% a linear fit
%ft = fittype('a0 + a1*x');
% if we look at the goodness of fit, rsquare = 0.8317, so let's try a
% second order polynomial. square value here is 0.9819
ft = fittype('a0 + a1*x + a2*x^2');

% cubic fit -> only a little better. Motto is use the simplest fit possible
%ft = fittype('a0 + a1*x + a2*x^2 + a3*x^3');
[F, gof] = fit(sf',kw',ft);

s = linspace(min(sf),max(sf),1e3);
plot(s,F(s),'r--');

legend('Empirical Data', 'Regression','Location', 'Southeast');

% Again we can use this to make estimations
