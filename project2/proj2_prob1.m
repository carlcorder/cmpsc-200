%% 1. Support beam loaded with snow
clear all; close all; clc;

L = 2;% meters

% weight intensity with a,b > 0
w = @(a,b,x) a + b .* sqrt(sinh(x.^2));% N/m

% maximum allowed force on supports A & B
Ra_max = 75; Rb_max = 90;% Newtons

% total force on the beam [N]
F = @(a,b) integral(@(x) w(a,b,x),0,L);

% moment about the center of mass [Nm] (expected value of the weight
% intensity)
Fd = @(a,b) integral(@(x) x .* w(a,b,x),0,L);

% in static equilibrium, forces and moments sum to zero. We create a 2x2
% coefficient matrix A whose columns are the support forces, Ra & Rb. we
% want to solve the eqn Ax = y

%    Ra  Rb
T = [1   1;
     0   L];
        
y = @(a,b) [F(a,b);
            Fd(a,b)];
        
% solution vector for the force on each support
R = @(a,b) T\y(a,b);% [Ra; Rb]

% use arrayfun so the function R can map over vectors
% the output is non scalar so we set uniform output to false
% non uniform outputs to cells so we convert it back to arrays
R_ab = @(a,b) cell2mat(arrayfun(@(a,b) R(a,b),a,b,'UniformOutput',false));

n = 2e2;% space divisions
a_min = -60; a_max = 125; a = linspace(a_min,a_max,n);
b_min = -60; b_max = 75; b = linspace(b_min,b_max,n); 

[A,B] = meshgrid(a,b);

% creates a 2*n x n array if we can't load it
if exist('R.mat','file')
    display('Loading Data...');
    load('R.mat','R_AB');
else   
    display('Calculating Data...');
    tic;
    % this is a costly calculation which takes about 
    % ~  22 sec when n ~ 1e2 
    % ~ 100 sec when n ~ 2e2
    % So we save the data and load it if possible
    R_AB = R_ab(A,B);
    toc;
end

% reshape R so that we can apply a filter
Rv = reshape(R_AB,2,n*n);

% filter out the solutions that exceed our tolerances
filter = Rv(1,:) <= Ra_max & Rv(1,:) > 0 & Rv(2,:) <= Rb_max & Rv(2,:) > 0;
% reshape filter for plotting
accept = reshape(filter,n,n);
figure('name','Acceptable Parameters');
imagesc(a,b,accept); xlabel('a'); ylabel('b'); grid on; axis tight;
% add a legend
N = 2;
cmap = summer(N);
colormap(cmap); hold on;
L = line(ones(N),ones(N), 'LineWidth',2);
set(L,{'color'},mat2cell(cmap,ones(1,N),3));
legend('Reject','Accept','Location','NorthWest');
title('$w(x) = a + b\sqrt{\sinh(x^2)}$','interpreter','latex','FontSize',15);

% since we only care about the a,b space which satisfies our constraint, we
% don't need to retain the Ra,Rb data
% % reshape the filter so that it matches the dimension of Rv
% R_filter = repmat(filter,2,1);
% % apply our filter
% Rv = Rv .* R_filter;
% % reshape the data back into a grid
% Rf_AB = reshape(Rv,2*n,n);
