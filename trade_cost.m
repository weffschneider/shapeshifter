function [cost] = trade_cost(titan_dem, node1, node2, max_slope)
                    
titan_radius = 2575e3; % m
dist = great_circle(titan_dem, titan_radius, node1, node2);

elev1 = titan_dem(node1(1), node1(2));
elev2 = titan_dem(node2(1), node2(2));
slope = abs(elev1-elev2)/dist;

if atan(slope) > max_slope
    cost = inf;
else
    % cost = linear combination of distance and elevation gain
    cost = dist + slope*dist*100;
end

% cost is made of up
% energy
% time = dist/robot.max_speed
% risk (?)
% energy per distance

