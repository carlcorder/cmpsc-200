%% using random numbers to create simulated data for an LC circuit

% inductors (L) drawn from a normal distribution and capacitors (C) drawn
% from a unifrom distribution - the resonance frequency omega_0 depends on
% L and C in the following way: omega_0 = 1/sqrt(L*C)

% L normally distributed with mean and standard deviation given below
Lbar = 1.5;% Henries
Lstd = 0.07;
Lvar = Lstd^2;

% C uniformly distibuted between 400 - 800 micro Farads
Cmin = 400e-6;
Cmax = 800e-6;
Cbar = (Cmin + Cmax)/2;
Cvar = (Cmax - Cmin)^2/12;
Cstd = sqrt(Cvar);

% specify sampe size
n = 5e4;

% sample the inductors
L = Lbar + Lstd*randn(1,n);

% sample the capacitors
C = Cmin + (Cmax - Cmin)*rand(1,n);

% Rice rule
bins = ceil(2*nthroot(n,3));

% resonance frequency. This distribution is some transform of the erfi ->
% imaginary error function
w0 = 1./sqrt(L.*C);
hist(w0,bins); grid on; xlabel('\omega_0 [rad/sec]');

% indeed this is not normally distributed p < 0.05 -> h = 1
[h,p] = lillietest(w0)

% track the mean of the resonance frequency to see if it converges to a 
% specific value. If yes, then we assume our sample size is sufficiently
% large.

% pre allocate a vector to hold the mean value of w0
m = zeros(1,n);
% create a sequence of means by increasing the sample size
for k = 1:n
    m(k) = mean(w0(1:k));
end

% plot the mean value -> 10,000 samples seems to provide convergence
figure('name','Convergence of the Mean');
semilogx(m,'r-'); grid on;
xlabel('Sample Size'); ylabel('Mean of \omega_0');

% what percentage of our circuits will have a resonance frequency between
% 30 rad/s - 40 rad/s (tolerable)
tol = (w0 >= 30 & w0 <=40);
per_tol = 100*sum(tol)/length(tol);