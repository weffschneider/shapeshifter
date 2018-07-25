% large quad (TREx) specs for trade study
robot.max_slope = pi/2; % rad
robot.speed = 0:14; % m/s
robot.power = [1800 1750 1680 1560 1440 1300 1250 1260 1300 1400 1500 1650 1800, 2000, 2200]; % W

robot.speed_max_endurance = 6;
robot.speed_max_range = 9;

% power vs. speed from https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=7943650&tag=1