function [dist] = great_circle(titan_dem, titan_radius, nodeA, nodeB)
% latitude
phi1 = deg2rad(nodeA(1) - 90);
phi2 = deg2rad(nodeB(1) - 90);
dphi = abs(phi1 - phi2);

% longitude
lam1 = deg2rad(nodeA(2) - 180);
lam2 = deg2rad(nodeB(2) - 180);
dlam = abs(lam1 - lam2);

% TODO: compute better distance
% for now, just use great circle distance with radius = average elevation
dsig = atan2(sqrt((cos(phi2)*sin(dlam))^2 + (cos(phi1)*sin(phi2) - sin(phi1)*cos(phi2)*cos(dlam))^2),...
             sin(phi1)*sin(phi2) + cos(phi1)*cos(phi2)*cos(dlam));
avg_rad = (titan_dem(nodeA(1),nodeA(2)) + titan_dem(nodeB(1),nodeB(2)))/2 + titan_radius;
dist = avg_rad*dsig;
