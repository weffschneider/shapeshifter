function [cost] = trade_cost(titan_dem, node1, node2)

titan_radius = 2575e3; % m
dist = great_circle(titan_dem, titan_radius, node1, node2);

% TODO: elevation gain

cost = dist;

% cost is made of up
% energy
% time = dist/robot.max_speed
% risk (?)
% energy per distance

