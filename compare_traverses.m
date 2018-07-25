% NOTE: need to run trade_runner first.

figure(1); hold on;
figure(2); hold on;

% TODO: cobot x 12 

trade_cobot;
[~, ~, ~] = traverse(titan_dem, shortest_path, robot, 0);
[~, ~, ~] = traverse(titan_dem, shortest_path, robot, 1);

trade_trex;
[~, ~, ~] = traverse(titan_dem, shortest_path, robot, 0);
[~, ~, ~] = traverse(titan_dem, shortest_path, robot, 1);

trade_roller;
[~, ~, ~] = traverse(titan_dem, shortest_path, robot, 0);
[~, ~, ~] = traverse(titan_dem, shortest_path, robot, 1);

figure(1);
ylabel('time');
legend('cobot, max endurance', 'cobot, max range',...
    'dragonfly, max endurance', 'dragonfly, max range',...
     'roller, max endurance', 'roller, max range');

figure(2);
ylabel('energy');
legend('cobot, max endurance', 'cobot, max range',...
    'dragonfly, max endurance', 'dragonfly, max range', ...
     'roller, max endurance', 'roller, max range');
 
 % NOTE: doesn't really make sense to compare cobot to dragonfly without
 % including the base station requirements


