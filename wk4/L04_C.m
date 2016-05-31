%% regressions
clc; close all; clear all;



%% collecting data on amount of precipitate at each minute
% 10 minutes
t = 1:10;
% this could come from a csv file
y = [5.46 9.43 15.54 18.8 22.78 28.56 31.32 35.22 40.75 44.12];
% specify a linear fit
% ft = fittype('a0+a1*x');
ft = fittype('poly1');

plot(t,y,'ko');
grid on; hold on; xlabel('Time [min]'); ylabel('Mass of Precipitate [g]');
title('Linear Regression');

% fit takes two column vectors (note the transpose) and a fittype
% returns fit function, goodness of fit (gof) and output
% notice a warning about the starting point not provided
[F, gof, output] = fit(t',y',ft);

% fill in more data points with the regression
t2 = linspace(min(t),max(t),1e3);
plot(t2,F(t2),'r--'); legend('Empirical data', 'Regression','Location','Northwest');

% how much precipitate was there at 2.5 minutes?
% interpolate
precip1 = F(2.5);

% how much precipitate will there be at 11 minutes?
% extrapolate - more dangerous to assume the relation holds up outside of
% the collected data.
precip2 = F(11);
