%% Linear Regression on a large data set
% we find the plane that best passes through the data to make estimates as
% to the value of the dependent variable

% using the ansure data set. Given stature & forearm length, can we
% estimate the foot length.

% load in ansur data 1774 x 3 -> data
load('/home/carl/MATLAB/ANGEL/code_data/mat/L07_ansur.mat');

% stature (height)
stat = data(:,1);
% forearm to hand length
fore = data(:,2);
% foot length
foot = data(:,3);

clear data;

% view the raw data
scatter3(stat,fore,foot,16,'k.'); hold on;
xlabel('Stature [mm]'); ylabel('Forearm-Hand Length [mm]'); zlabel('Foot Length [mm]');
% trend is showing us that a stature and forearm length aredirectly related
% to foot length

% assemble the A matrix w/o a constant term
A = [stat fore];
b = foot;

x_sol1 = A\b;% (stat,fore) = (0.0538, 0.3619) -> 0.0538*stat + 0.3619*fore = foot

% assemble the A matrix with a constant term
A = [stat fore ones(length(stat),1)];

x_sol2 = A\b;% [0.0434; 0.3590; 19.7664] -> 0.0434*stat + 0.3590*fore + 19.7664 = foot

% we can now use x to make estimates
p = [1800 480 1];% [stat fore one]
foot_estimate = p*x_sol2;% 270.15 mm

scatter3(p(1),p(2),foot_estimate,'rp'); hold on;

% what are the residuals i.e. difference between estimates and actual data
residuals = A*x_sol2 - b;
res = sqrt(sum(residuals.^2));% ~1e5
% same as: res = norm(residuals);
% A\x minimizes the norm -> any other plane passing through the data will
% have a greater norm value

% plot the plane of best fit
xx = linspace(min(stat),max(stat));
yy = linspace(min(fore),max(fore));
[X,Y] = meshgrid(xx,yy);
z = @(x,y) (x_sol2(1).*x + x_sol2(2).*y + x_sol2(3));
plot3(X,Y,z(X,Y));
legend('Raw Data','@P','Plane of Best Fit');






