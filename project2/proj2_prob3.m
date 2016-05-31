%% Trajectory of a Rubber Ball
% A rubber ball is released from an initial height of 10m and hits the
% ground with a restitution coefficient of 0.8. Neglecting air resistance,
% determine the height of the ball as a function of time.

g = 9.81;% m/s^2
y0 = 10;% meters
t_range = [0 12];% sec
v0 = 0;% m/s
R = 0.80;% coefficient of restitution

% geometric sequence for impact time and velocity
%
% time elapsed between bounce n and n+1
t1 = sqrt(2*y0/g);  t = @(n) (n < 1 & n >= 0).*t1 + (n > 0).*2.*R.^(n).*t1;  

% the velocity just after impact n
v1 = sqrt(2*y0*g);  v = @(n) (n > 0).*R.^(n).*v1;% encodes v0 = 0

% cumulative time to bounce n > 0
% NOTE: 12 sec occurs between the 12th and 13th bounce
% t_cum = @(n) 2.*t1.*((1-R^n)./(1-R))-t1;

% alternatively
bounce = -1:1:12;
t_cum = cumsum(t(bounce));

% path of the ball from t = [t_cum(n) t_cum(n+1)]
y = @(n,t) (n < 1).*y0 + v(n).*t - 0.5.*g.*t.^2;

figure('name','Bouncing Rubber Ball');
tc = 0;
for k = 0:bounce(end)
   time = linspace(0,t(k));
   % shift the time window for each bounce
   tc = tc(end) + time;
   plot(tc,y(k,time),'b-');
   hold on;
end

xlabel('Time [s]'); ylabel('Height [m]');
grid on;
