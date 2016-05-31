%% 1D cubic spline
% instead of using only two neighbroring points to make an estimate, higher
% order polynomial interpolation makes the estimate using more surrounding
% points. We stipulate that boundry points must match value, slope, 2nd
% derivative, 3rd derivative etc..

% sparse sample of linspace
t = linspace(0,2*pi,8);
y = sin(t);

% based on only these sample points, we can't get a good understanding of
% what the function looks like
figure('name','Interpolation','position',[50,50,1000,1000]);
plot(t,y,'ks'); grid on; hold on;
xlabel('t'); ylabel('sin(t)');

% linear interpolation between our sampled data points
te = linspace(min(t),max(t),1e3);
ye1 = interp1(t,y,te,'linear');

% this doesn't really look like the sine function (veryy jagged)
plot(te,ye1,'r--'); hold on;

% use cubic order interpolation
ye2 = interp1(t,y,te,'spline');

% plot spline interpolation and notice it has a better fit
plot(te,ye2,'b--');
legend('Raw Data','Linear Interp','Spline Interp');