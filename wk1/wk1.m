%% Week 1 Homework for CMPSC200

%% 2. Response parameter s of parallel circuit
% a.

clear all; clc;

R = 200;
C = 1e-6;
L = 0.64;

S = (1/(2*R*C)) + sqrt((1/(2*R*C))^2 - (1/(L*C)));
% b.

r = linspace(0,400,1000);
s = (2*r*C).^-1 + sqrt(((2*r*C)).^-2 - (1/(L*C)));

% naming the figure window
figure('name', 'Response parameter of parallel circuit');
subplot(3,1,1);
plot(r,s);
axis([0 100 0 1e6]);
xlabel('R Ohms (C = 1e-6 F, L = 0.64 H)');
ylabel('S');
title('S vs R');

% c.

c = linspace(0.1e-6, 4e-6);
s = (2*R*c).^-1 + sqrt(((2*R*c)).^-2 - (L*c).^-1);

subplot(3,1,2);
plot(c,s);
xlabel('C Farads (R = 200 Ohms, L = 0.64 H)');
ylabel('S');
title('S vs C');

% d.

l = linspace(0.5,0.7);
s = (2*R*C).^-1 + sqrt(((2*R*C)).^-2 - (l*C).^-1);

subplot(3,1,3);
plot(l,s);
xlabel('L Henries (R = 200 Ohms, C 1e-6 Farads)');
ylabel('S');
title('S vs L');

%% 3. Range of projectile
% clf clears the figure
% hold on holds the figure in order to have multiplots
% sub plot (rows, column, plot number)
% a.

clear R;
g = 9.81;
v = 100;
x = linspace(0,pi/2,1000);

R = ((v.^2)/g)*sin(2*x);

figure(4);
subplot(2,1,1);
plot(x,R);
xlabel('Angle with respect to ground (radians)');
ylabel('Range of object');
title('Range vs Angle');

% we find the maximum value of the range and the angle for which it occurs
[maxRange index] = max(R);
maxTheta = x(index);

% b.

v = linspace(10,100);
R = ((v.^2)/g)*sin(2*maxTheta);


subplot(2,1,2);
plot(v,R);
xlabel('velocity m/s (@ theta max)');
ylabel('Range of object');
title('Range vs Velocity');
% The projectile range increases with the square of velocity (parabola
% shaped)

%% 4. Testing plot types

x = linspace(0,20*pi,2000);
y = x.*sin(x);
z = x.*cos(x);

% a.
figure(6);
plot(x,y);
grid on;
xlabel('x'); ylabel('y'); title('y = x sin(x)');

% b.
figure(7);
polar(x,y);
xlabel('\theta'); ylabel('r'); title('r = \theta sin(\theta)');

% c.
figure(8);
plot3(x,y,z);
grid on;
xlabel('x'); ylabel('x sin(x)'); zlabel('x cos(x)'); title('It''s a tornado!');

%% 5. Use Lagrangian multiplier to minimize the cost function under an area constraint

% a. Analytic solution

gamma = sqrt((70*(7.5*pi+35)+0.5*pi*35^2)/2000);
R_min = 35/gamma;
L_min = (7.5*pi+35)/gamma;
A_const = 2*R_min*L_min + 0.5*pi*R_min^2;
C_min = 2*(L_min+R_min)*35 + pi*R_min*50;

% b.

% use mesh or surf to plot 3d surfaces
clear C A R L;
[R, L] = meshgrid(0:1:50);
C = 2.*(L+R).*35 + pi.*R.*50;
A = 2.*R.*L + 0.5.*pi.*R.^2;
figure(9);

% plot the cost function
surf(R,L,C,'EdgeColor','none','FaceAlpha',0.4);
colormap(jet);
freezeColors;
xlabel('R'); ylabel('L'); zlabel('Cost'); title('Area and Cost');
grid on; hold on;
% plot the area function
surf(R,L,A,'EdgeColor','none','FaceAlpha',0.6); hold on;
colormap(parula(5));

% plot the area constraint
v = [500 1000 1500 2000 2500 3000];
contour(R,L,A,v); hold on;
[Con Hand] = contour3(R,L,A,[2000 2000],'g','LineWidth',5); hold on;
clabel(Con, Hand);

% get contour data using contourdata function
clear C R L;
s = contourdata(Con);
R = s.xdata;
L = s.ydata;

% re define the cost under the given constraint
C = 2.*(L+R).*35 + pi.*R.*50;

% finally we plot the  cost under the are constraint
plot3(R,L,C,'m','LineWidth',5);
[C_min2 index] = min(C);
L_min2 = L(index);
R_min2 = R(index);

%% 6. Fourier Series

clear x y;
x = linspace(-2*pi,2*pi,500);
f = sign(x);
figure(10);
plot(x,f,'k');
axis([-pi pi -1.5 1.5]); xlabel('x'); ylabel('y'); title('Fourier series approximation');
grid on; hold on;

A = 4/pi;
f2 = @(x) A*(sin(x)/1 + sin(3.*x)/3);
f4 = @(x) A*(sin(x)/1 + sin(3.*x)/3 + sin(5.*x)/5 + sin(7.*x)/7);
f8 = @(x) A*(sin(x)/1 + sin(3.*x)/3 + sin(5.*x)/5 + sin(7.*x)/7 + ...
    sin(9.*x)/9 + sin(11.*x)/11 + sin(13.*x)/13 + sin(15.*x)/15);

plot(x,f2(x),'r');
plot(x,f4(x),'g');
plot(x,f8(x),'m');
legend('f(x)','f2(x)','f4(x)','f8(x)');

%% 7. Small angle approximation

clear x;
x = linspace(0,1);
error = (sin(x) - x)./sin(x);
threshold = -0.05.*ones(1,100);

figure(11);
% ginput -> graphical input from mouse
% or use data cursor
plot(x,error); grid on; hold on;
plot(x,threshold,'r'); hold on;
xlabel('x'); ylabel('Error(x)'); title('Small angle approximation');

%% 8. Structural vibrations (beats)

clear f1 f2;
f1 = 3; f2 = 5;
amp = (1/(f1^2 - f2^2));
t = linspace(0,20,1000);
beat = @(t) (amp.*(cos(f2.*t) - cos(f1.*t)));

% a.
figure(12);

% 1000 points
subplot(3,1,1);
plot(t,beat(t)); grid on; hold on;
xlabel('t'); ylabel('y'); title('1000 pts');

% deomonstrate a beat frequency can be obtained by a carrier and envelope.
% the envelope takes the average freqeuncy while the beat frequency takes
% the difference of the two frequencies.
plot(t, 2*amp.*cos(((f1 + f2)/2).*t),'c'); hold on;
plot(t,2*amp.*cos(((f2 - f1)/2).*t),'m');

% 100 points
t = linspace(0,20,100);
subplot(3,1,2);
plot(t,beat(t)); grid on; hold on;
xlabel('t'); ylabel('y'); title('100 pts');

% 10 points
t = linspace(0,20,10);
subplot(3,1,3);
plot(t,beat(t),'o'); grid on; hold on;
plot(t,beat(t)); hold on;
% uncomment lines below to see aliasing
t = linspace(0,20,100);
plot(t,beat(t));
xlabel('t'); ylabel('y'); title('10 pts (aliasing)');

% b. aliased signal due to undersampling
% see Nyquist-Shannon sampling theorem
% B = max(f1,f2)/2*pi
% Then the sampling points should be spaced no more than 1/(2B) apart