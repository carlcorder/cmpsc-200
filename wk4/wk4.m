%% 1. RC circuit
% Capacitor is initially charged to 100 volts and the power supply is
% detached. The voltage across the capacitor decays exponentially with time
% and is recorded every 0.5s

% For the discharging capacitor we have Vc(t) = V0*exp(-t/RC) where tau = RC
% is the time constant.

% data: capacitor voltage measured every half second
t = [0.0 0.5 1.0 1.5 2.0 2.5 3.0 3.5 4.0];
Vc = [100 62 38 21 13 7 4 2 3];

% a)
% tau = RC = 0.9971, rsquare = 0.9989
ftv = fittype('100*exp(-x/a0)');
[v, gofv] = fit(t',Vc',ftv);

%b)
figure('name','RC circuit');
% plot the data points
plot(t,Vc,'k.'); xlabel('Time [s]'); ylabel('Voltage [V]'); grid on;
title('RC circuit: capacitor decay'); hold on;

% plot the fit curve
plot(t,v(t),'g--');

%% 2. Solubility of salt in water as a function of temperature
% Let S represent the solubility of NaCl as grams of salt per 100 g of
% water. Let the temperature T be in Celsius. In this experiment, the
% solubility was measured every 10 degrees.

T = [10 20 30 40 50 60 70 80 90];% C
S = [35 35.6 36.25 36.9 37.5 38.1 38.8 39.4 40];% g NaCl / g H2O

% a)
% Upon reviewing the data we decide on a linear fit
% a0 = 34.36, a1 = 0.06283, rsquare = 0.9998
fts = fittype('a0 + a1*x');
[s, gofs] = fit(T',S',fts);

% b)
figure('name','Solubility of Salt');
% Plot the data
plot(T,S,'k.'); xlabel('Temperature [C]'); ylabel('Solubility [g NaCl / g H2O]');
grid on; hold on;

% Plot the linear fit
plot(T,s(T),'g--');

% c)
sol_at_75 = s(75);% 39.0764

%% 3. The drying time T for paint as a function of additive A in the mix

% raw data
A = [0 1 2 3 4 5 6 7 8 9];% [oz]
T = [130 115 110 90 89 89 95 100 110 125];% [min]

% a) polynomial fits order 1-4
ft1 = fittype('poly1');
ft2 = fittype('poly2');
ft3 = fittype('poly3');
ft4 = fittype('poly4');

[F1, gof1] = fit(A',T',ft1);
[F2, gof2] = fit(A',T',ft2);
[F3, gof3] = fit(A',T',ft3);
[F4, gof4] = fit(A',T',ft4);

% We see that the second order polynomial is the simplest model which
% captures all of the important behavior.
rsq = [gof1.rsquare gof2.rsquare gof3.rsquare gof4.rsquare];

% b)
figure('name','Drying Time');
plot(A,T,'k.'); xlabel('Additive in mix [oz]'); ylabel('Time [min]');
grid on; hold on; title('Drying times for paint');

a = linspace(min(A),max(A),1e3);
plot(a,F2(a),'g--');

% c) Using your best fit, estimate the amount of additive that will
% minimize the drying time.
best_mix = fminsearch(@(x) F2(x), 4.5);

%% 4. Population growth
% population data for various countries from 1960 - 2013

% read in the entire array of population data
pops = xlsread('hw4/pops.xlsx','B2:BC244');

% read in the raw country data [num txt raw]
[~, country, ~] = xlsread('hw4/pops.xlsx','A2:A244');

% read in the year data
year = xlsread('hw4/pops.xlsx','B1:BC1');

% Use exp1 as the fit type: y = a*exp(bt) to perform a regression for every
% country's population over time. Refer to 'b' as the growth rate and 'a'
% as the initial population.

% a) find the growth rate and rquared value for each country

%growth_rates = [];
%rsq = [];
s = struct('country',[],'growth_rate',[],'rsquare',[]);
% preallocate an array of structs using repmat (stil takes > 7 sec)
data = repmat(s,length(country),1);
ft = fittype('exp1');

for i = 1:length(country)
    % create a structure for each country holding all of the relevant data
    [F, gof] = fit(year', pops(i,:)', ft);
    %growth_rates = [growth_rates F.b];
    %rsq = [rsq gof.rsquare];
    data(i).country = country(i);
    data(i).pops = pops(i,:);
    data(i).F = F;
    data(i).growth_rate = F.b;
    data(i).rsquare = gof.rsquare;
end

% b) We consider the countries that have a well-fit exponential growth
% curve. i.e. rsquare > cut_off
cut_off = 0.99;
% structure array of best fits (81 make the cutoff)
best_fits = data(find([data.rsquare] > cut_off));

% i. of these, which country has the highest growth rate?
% Explosive population growth in Niger
Niger = best_fits(find([best_fits.growth_rate] == ...
    max([best_fits.growth_rate])));

figure('name','pops.xls');
% to search by country name: data(find(isequal(char([data.country]), 'xyz')))
% plot the raw data
Nig = plot(year,Niger.pops,'k.'); xlabel('Year'); ylabel('Population'); grid on;
hold on;

% plot the fit curve
plot(year,Niger.F(year),'g--'); hold on;

% ii. of these, which country has the lowest growth rate?
% Finland is a developed sparsely country
Finland = best_fits(find([best_fits.growth_rate] == ...
    min([best_fits.growth_rate])));

Fin = plot(year,Finland.pops,'b.'); xlabel('Year'); ylabel('Population'); grid on;
hold on;

% plot the fit curve
plot(year,Finland.F(year),'r--');
legend([Nig, Fin],'Niger','Finland','Location','Northwest');

% c) considering all countries, which one has the lowest rsquare value?
% this would also have the worst fit
Estonia = data(find([data.rsquare] == min([data.rsquare])));

figure('name','Bad Fit');
% plot the raw data
plot(year,Estonia.pops,'k.'); xlabel('Year'); ylabel('Population'); grid on;
title('Estonia'); hold on;

% plot the fit curve
% low fertility rate, migration, communist party
plot(year,Estonia.F(year),'g--');
