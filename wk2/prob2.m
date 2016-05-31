% Compute the capacitance of two parallel conductors of lenght L and radius
% r, separated by a distance d.

function C = prob2(L, r, d)

% permittivity of air Farads/millimeter
epsilon = 8.854e-15;

C = pi*epsilon.*L./log((d - r)./r);