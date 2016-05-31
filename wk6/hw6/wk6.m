%% 1. Interpolation of water heater data

t = 0:10;% time [min]
T = [65 68 71 73 94 100 102 105 107 108 109];% temperature [F]

% a) plot the raw data, linear & spline interpolations
figure('name','Water Heater');
plot(t,T,'ko'); grid on; hold on;
xlabel('Time [min]'); ylabel('Temperature [\circF]');

te = linspace(min(t),max(t),1e3);
T_linear = interp1(t,T,te,'linear');
T_spline = interp1(t,T,te,'spline');

plot(te,T_linear,'r--'); plot(te,T_spline,'b--');
legend('Raw Data','Linear Interp','Spline Interp','Location','NorthWest');

% b) using both interpolations, estimate the temp at 3.3 and 6.75 min
times = [3.3 6.75];
temp_at_times_linear = interp1(t,T,times,'linear');% 79.30 & 104.25
temp_at_times_spline = interp1(t,T,times,'spline');% 78.44 & 104.28

% c) using both interpolations, estimate the time when the temp = 98.6
% two methods for doing this. Refer to:
% http://matlab.cheme.cmu.edu/2012/02/02/better-interpolate-than-never/

% method 2: switch the interpolation order
temp = 98.6;
time_at_temp_linear = interp1(T,t,temp,'linear');% 4.77 min
time_at_temp_spline = interp1(T,t,temp,'spline');% 4.48 min

%% 2. Force sensor data analysis

% [channel, voltage, timestamp] 6498x3 matrix
force = csvread('/home/carl/MATLAB/ANGEL/HWs/wk6/forcetest.csv');

% voltage (column 1) vs time (column 2)
sensor0 = force(1:3:end,2:3);
sensor1 = force(2:3:end,2:3);
sensor2 = force(3:3:end,2:3);

% a) because the recordings are not exactly synchronized, use a linear
% interpolation to resample the reading for each sensor between 1 and 17
% seconds in increments of 1/120 sec
start = 1; stop = 17; freq = 120; t = start:1/freq:stop;

% we get the linear interpolated voltage at each timestamp in t
v0 = interp1(sensor0(:,2),sensor0(:,1),t,'linear');
v1 = interp1(sensor1(:,2),sensor1(:,1),t,'linear');
v2 = interp1(sensor2(:,2),sensor2(:,1),t,'linear');

% b) convert each channel from the measured voltage to the calculated force
% and plot them

% set up voltage to force conversions (linear maps)
m0 = -32.58; b0 =  0.2677; F0 = @(x) (m0 .* x + b0);
m1 = -34.70; b1 = -1.2080; F1 = @(x) (m1 .* x + b1);
m2 = -36.11; b2 = -1.9930; F2 = @(x) (m2 .* x + b2);

figure('name','Force Test');
plot(t,F0(v0),'b',t,F1(v1),'r',t,F2(v2),'g'); grid on;
xlabel('Time [sec]'); ylabel('Force [N]');
legend('Sensor 0','Sensor 1','Sensor 2','Location','East');

%% 3. Nighttime temperatures over an area of land

x = 0:3;% [mi]
y = 0:3;% [mi]

% temperature as function of (x,y) coordinate
T = [28 26 24 26;
     24 25 21 25;
     24 27 24 22;
     23 22 23 21];

% a) estimate the temperature at a location (x,y) = (1.30,2.25) miles
% using a cubic spline interpolation
px = 1.30; py = 2.25;
T_at_p = interp2(x,y,T,px,py,'spline');% 26.45 

% b) create a contour plot of the estimated temperature field within the
% given area

% we need to sample our coordinate space more in order to get a smooth
% looking plot
x_sample = linspace(min(x),max(x),1e2);
y_sample = linspace(min(y),max(y),1e2);

[X,Y] = meshgrid(x_sample,y_sample);
 
% 2D interpolation
Te_spline = interp2(x,y,T,X,Y,'spline');
 
figure('name','Temperature over Land');
contourf(X,Y,Te_spline,25);% use 25 contours
colormap('jet'); c = colorbar; c.Label.String = 'Temp [\circF]';
xlabel('x [mi]'); ylabel('y [mi]');
% set axis to scale and tighten
axis equal; axis tight;
 
