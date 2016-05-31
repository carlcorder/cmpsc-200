%% 1D Linear interpolation example
% using linear interpolation to find the enthalpy and entropy values of
% steam at a specified temperature not on the steam table.

close all; clear all; clc;

% start 1 row down to skip the header and 0 rows over
steam_data = csvread('/home/carl/MATLAB/ANGEL/code_data/csv/L06_steamtable.csv',1,0);

% temperature [K] is in column 1 (119 data points)
T = steam_data(:,1);

% enthalpy of gas [kJ/kg] in column 9
h = steam_data(:,9);

% entropy of gas [kJ/(kg K)] in column 11
s = steam_data(:,11);

% plot our raw enthalpy data
figure(1);
plot(T,h,'k.'); grid on; hold on;
xlabel('Temperature [^\circC]'); ylabel('Enthalpy [kJ/kg]');

% estimate the enthalpy at 23.3 C (23 - 24) -> (2543.5 - 2545.4)
t = 23.3;
ht = interp1(T,h,t);% 2544.1

% we can estimate both dependent variables at once: entropy and enthalpy at T = 23.3
% entropy at 23.3 C (23 - 24) -> (8.6011 - 8.5794)
hst = interp1(T,[h s],t);% 2544.1 & 8.6

% NOTE: T must be strictly monotonic -> ordered ascending or descending or 
% else the interpolation cannot be performed.

% what does the interpolation look like across the entire range?
Te = linspace(min(T),max(T),1e3);

% get the interpolated enthalpy values across the entire linspace
% e = estimate
he = interp1(T,h,Te,'linear');% default type in linear
% overlay interpolated data
plot(Te,he,'r--');

% again, we can interpolate both dependent variable simultaneously
hse = interp1(T,[h s],Te,'linear');% two columns of data

se = hse(:,2);
% plot our raw entropy data
figure(2);
plot(T,s,'k.'); grid on; hold on;
xlabel('Temperature [^\circC]'); ylabel('Entropy [kJ/kg K]');

% overlay our estimate
plot(Te,se,'r--');
