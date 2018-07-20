% Import Titan elevation data
addpath('dem');
fileID = fopen('titan_elevation.txt', 'r'); % use less detail for now
titan_dem = fscanf(fileID, '%f', [360 180]);
titan_dem = flipud(titan_dem'); % elements in this matrix == nodes of graph

% Import start/end point
trade_trajectory;

% Import robot
trade_wheeled;
% trade_dragonfly;
% trade_shapeshifter;
% trade_hytaq;

alpha = 0.1;

alist = AList;
initialize(alist, titan_dem, robot.max_slope, ...
    @(a, b) heuristic(@trade_cost, titan_dem, a, b, endpt, robot));

% dijkstras
[shortest_path] = disjkstras(alist, startpt, endpt);

% % Plot DEM
figure;
dem(0:1:359, 0:1:179, titan_dem, 'Legend');
set(gca, 'YDir','reverse')

hold on;
plot(startpt(2), startpt(1), 'gs');
plot(endpt(2), endpt(1), 'gp');
plot(shortest_path(:,2), shortest_path(:,1), 'r-.');

function [cost] = heuristic(cost_fn, titan_dem, node1, node2, goal, robot)
    g = cost_fn(titan_dem, node1, node2, robot.max_slope);
    titan_radius = 2575e3; % m
    h = great_circle(titan_dem, titan_radius, node1, goal);
    cost = g + h/100;
end