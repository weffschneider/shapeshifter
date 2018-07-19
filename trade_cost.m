function [cost, time, energy] = trade_cost(robot, titan_dem, node1, node2, alpha)

titan_radius = 2575e3; % m

dist = great_circle(titan_dem, titan_radius, node1, node2);
time = dist/robot.max_speed;
energy = robot.power*time;

cost = alpha*time + (1-alpha)*energy;

% cost is made of up
% energy
% time = dist/robot.max_speed
% risk (?)
% energy per distance

