function [cost] = trade_cost(titan_dem, nodeA, nodeB, max_slope)

titan_radius = 2575e3; % m
dist = great_circle(titan_dem, titan_radius, nodeA, nodeB);

time = dist/robot.max_speed;
energy = robot.power*time;

elev1 = titan_dem(nodeA(1), nodeA(2));
elev2 = titan_dem(nodeB(1), nodeB(2));
slope = abs(elev1-elev2)/dist;

cost = alpha*time + (1-alpha)*energy;


if atan(slope) > max_slope
    cost = inf;
else
    % cost = linear combination of distance and elevation gain
    cost = dist + slope*dist*3000;
end

% cost is made of up
% energy
% time = dist/robot.max_speed
% risk (?)
% energy per distance

