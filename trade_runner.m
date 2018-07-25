% Import Titan elevation data
addpath('dem');
fileID = fopen('titan_elevation_detailed.txt', 'r'); % use less detail for now
titan_dem = fscanf(fileID, '%f', [360 180].*4);
titan_dem = flipud(titan_dem'); % elements in this matrix == nodes of graph

% Only take Sotra Patera
titan_dem = titan_dem(420:460, 1260:1300);
numnodes = (440-400+1)*(1300-1260+1);

% Import start/end point
trade_trajectory;

% Import robot
trade_wheeled;
% trade_dragonfly;
% trade_shapeshifter;
% trade_hytaq;

alpha = 0.1;

alist = AList;
initialize(alist, titan_dem, ...
    @(a, b) heuristic(@trade_cost, titan_dem, a, b, endpt, robot));

% dijkstras
[shortest_path] = disjkstras(alist, startpt, endpt, numnodes);

%% Plot DEM
titan_radius = 2575e3; % m
lon=linspace(0,40,41);
lat=linspace(0,40,41);
[lon,lat]=meshgrid(lon,lat);

figure;
surf(lon, lat, titan_dem, 'linestyle', 'none'); view(2);
set(gca, 'YDir','reverse')
c = colorbar;
c.Label.String = 'Elevation (meters)';

hold on;
plot3(startpt(2), startpt(1), titan_dem(startpt(2), startpt(1)), 'rs');
plot3(endpt(2), endpt(1), titan_dem(endpt(2), endpt(1))+10, 'rp');
height = zeros(1, size(shortest_path, 1));
if ~isempty(shortest_path)
    for i = 1:length(shortest_path(:,1))
        height(i) = titan_dem(shortest_path(i,1), shortest_path(i,2));
    end
    % TODO: fix 3D version of this
%     plot3(shortest_path(:,2), shortest_path(:,1),...
%         titan_dem(shortest_path(:,2), shortest_path(:,1)), 'r.-');
%     
    plot3(shortest_path(:,2), shortest_path(:,1),height+20, 'r.-');

else
    disp('no path found');
end


function [cost] = heuristic(cost_fn, titan_dem, node1, node2, goal, robot)
    g = cost_fn(titan_dem, node1, node2, robot.max_slope);
    titan_radius = 2575e3; % m
    h = great_circle(titan_dem, titan_radius, node1, goal);
    cost = g + h/100;
end