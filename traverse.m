function [time, energy, distance] = traverse(titan_dem, shortest_path, robot, alpha)

numsteps = size(shortest_path,1);
slope = zeros(1, numsteps-1);
titan_radius = 2575e3; % m
time = zeros(1, numsteps-1);
energy = zeros(1, numsteps-1);
distance = 0;

for i = 2:numsteps
    nodeA = shortest_path(i-1,:);
    nodeB = shortest_path(i,:);
    
    dist = great_circle(titan_dem, titan_radius, nodeA, nodeB);

    elev1 = titan_dem(nodeA(1), nodeA(2));
    elev2 = titan_dem(nodeB(1), nodeB(2));
    slope(i-1) = (elev2-elev1)/dist;
    
    if alpha == 0 % maximize endurance
        speed = robot.speed_max_endurance;
        power = robot.power(robot.speed == speed);
    else % maximize range
        speed = robot.speed_max_range;
        power = robot.power(robot.speed == speed);
    end
    
%     time = time + dist/speed;
%     energy = energy + power*time;
    time(i-1) = dist/speed;
    energy(i-1) = power*time(i-1);

    distance = distance + dist;
end

figure(1);
plot(1:numsteps-1, time);
figure(2);
plot(1:numsteps-1, energy);

% plot(1:numsteps-1, slope, '.-');
% xlabel('steps');
% ylabel('slope');