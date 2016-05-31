%% Monte Carlo Integration Example 6
% We compute a double integral under a surface to find the volume. Again we
% check for convergence of the solution to verify we used enough samples.

% function from example 3
z = @(x,y) 3 + sin(x.*y).*cos(y.^2);

xa = 0; xb = 6; ya = 0; yb = 3;

% +----xa----+----xb
% |     |         |
% |     |         |
% ya----+----+----+
% |     |/////////|
% |     |/////////|
% yb----+----+----|

% accepted value using numerical quadrature
Iz = integral2(@(x,y) z(x,y),xa,xb,ya,yb);% 56.1273

% N independent random samples generated within our variable bounds
N = 1e6;
xt = xa + (xb-xa)*rand(N,1);
yt = ya + (yb-ya)*rand(N,1);

% evaluate our function at the sample points
F = z(xt,yt);

% integral estimate via Monte Carlo Integration

% "volume" of sample space
V = (xb-xa)*(yb-ya);% 18
% integral estimate
Ize = mean(F)*V;% 56.12__

% test if we used enough sample points in our integration
Ize_cum = cumsum(F)./[1:N]';

figure('name','Monte Carlo Integration');
semilogx(V.*Ize_cum, 'k-'); grid on;
xlabel('Sample Size N'); ylabel('I','interpreter','latex','FontSize',15);
title('$I = \int^3_0\int^6_0 e^{\sin x^2}\,dx\,dy$','interpreter','latex','FontSize',15);

