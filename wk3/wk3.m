%% 1. Modeling the return on a Roth IRA account

% a) using the function roth.m - see function documentation for more detail

% we get the account totals for the next 47 (67 - 20) years
amounts_8 = roth(47,[],[]);
balance_at_67 = amounts_8(end);
year = [20:1:67];

% plot the account balance until account holder is 67 yrs old
figure('name','Roth IRA');
plot(year,amounts_8/1e6,'-k'); xlabel('years open'); ylabel('balance amount (millions)');
title('Roth IRA Account Growth'); grid on; hold on;

% b) how old will they be when they first have over 1 million dollars in the
% account. Hint: use the find function
age_of_a_millionaire = 20 + (find(amounts_8 > 1e6,1) - 1);

% c) how much more money would they have at age 67 with a 10% annual return
% compared to results in part (a)
amounts_10 = roth(47,[],1.10);
plot(year,amounts_10/1e6,'g'); legend('8%','10%');
advantage = amounts_10(end) - amounts_8(end);

%% 2. Modeling a diode

% a) the ideal diode model
t = linspace(0,10,1e5);
voltage_s = 15 .* exp(-t ./ 3) .* sin(pi .* t);
% plot the source voltage
figure('name','Ideal Diode'); 
plot(t,voltage_s,'--'); xlabel('time'); ylabel('voltage'); title('Load Voltage');
grid on; hold on;

% using a logical operator to get the load voltage
filter = voltage_s > 0.6;
voltage_l = voltage_s .* filter;
plot(t,voltage_l); hold on;

% b) the off-set diode model
voltage_l(voltage_l > 0) = voltage_l(voltage_l > 0) - 0.6;
plot(t,voltage_l,'g'); legend('source','ideal', 'off-set');

%% 3. Heat transfer on a rectangular plate

% a) find the steady-state temperature at the center of the plate for
% partial sums of w from n = 1 to n = 19. Find the value for n in which we
% consider the solution converged -> the change in T is less than 1% of its
% value at the previous n.

W = 2;
L = 3;
T = [];
% evaluate the temperature only at odd integers
for i = 1:2:19
    % can I evaluate a function without a handle?
    t = temp(i);
    T = [T t(W/2,L/2)];
end

percent_change = [];
for jj = 1:length(T) - 1
    percent_change(jj) = 100*abs((T(jj + 1) - T(jj))/T(jj));
end

% we see that n = 7 in order for our solution to be considered as converged
n_of_one_percent = 2*find(percent_change > 0 & percent_change < 1,1) + 1;

% b) use one of the converged solutions to create a contour plot of the
% temperature distribution across the entire plate

x = linspace(0,L);
y = linspace(0,W);
[X Y] = meshgrid(x,y);
z = temp(19);

figure('name','Temperature distribution of rectangular plate (n = 19)');
%surfc(X,Y,z(X,Y));
meshc(X,Y,z(X,Y));
%contourf(X,Y,z(X,Y),20);
xlabel('x'); ylabel('y'); zlabel('Temperature');
title('T(x,y)');
colormap('jet'); colorbar;

%% 4. The Collatz conjecture

% a) refer to the function collatz.m

% b) properties of the collatz conjecture

n = 2:100;
steps = [];
max_vals = [];
for ii = 2:100
    [seq iter max_info] = collatz(ii);
    steps = [steps iter];
    max_vals = [max_vals max_info(1)];
end

% i. N vs iterations
figure('name', 'The Collatz Conjecture');
title('3N + 1 game');
subplot(3,1,1);
plot(n,steps,'.'); xlabel('N'); ylabel('steps');

% ii. N vs max value in sequence
subplot(3,1,2);
semilogy(n,max_vals,'.'); xlabel('N'); ylabel('max seq val');

% iii. max value vs number of steps
subplot(3,1,3);
loglog(max_vals,steps,'.'); xlabel('max seq val'); ylabel('steps');

