% extract elevation data 
addpath('dem');
fileID = fopen('titan_elevation_detailed.txt', 'r');
sizeA = [1440 720];
A = fscanf(fileID, '%f', sizeA);
A = A';

R= 10000; % 2575e3;
% use radius = 10km so we can see something
lon=linspace(-pi,pi,1440);
lat=linspace(-pi/2,pi/2,720);
[lon,lat]=meshgrid(lon,lat);
[X,Y,Z]=sph2cart(lon,lat,R + A);

% Plot surface map
figure; hold on;
h1 = surf(X,Y,Z,A, 'linestyle', 'none');
title('Elevation map of Titan');
xlabel('m'); ylabel('m'); zlabel('m');
axis equal;
c = colorbar;
c.Label.String = 'Elevation (meters)';

% Slope plot
[Nx, Ny, Nz] = surfnorm(X,Y,Z);
slope = zeros(size(Nx));
for i = 1:size(Nx,1)
    for j = 1:size(Nx,2)
        % Calculate slope as in Hopper traversability paper
        nrm = [Nx(i,j), Ny(i,j), Nz(i,j)];
        g = [X(i,j), Y(i,j), Z(i,j)];
        slope(i,j) = acosd(dot(nrm, g./norm(g)));
    end
end
figure; hold on;
h2 = surf(X,Y,Z,slope, 'linestyle', 'none');
title('Slope map of Titan');
xlabel('m'); ylabel('m'); zlabel('m');
axis equal;
c = colorbar;
c.Label.String = 'Slope (degrees)';

% Plot in 2D
figure;
surf(rad2deg(lon), rad2deg(lat), A, 'linestyle', 'none'); view(2);
c = colorbar;
c.Label.String = 'Elevation (meters)';
title('Elevation Map');
axis equal;

figure;
surf(rad2deg(lon), rad2deg(lat), slope, 'linestyle', 'none'); view(2);
c = colorbar;
c.Label.String = 'Slope (degrees)';
title('Slope Map');
axis equal;

% figure;
% surf(X, Y, Z, (slope > 10) + 1, 'linestyle', 'none');
% title('Slope < 10\circ'); axis equal;
% colorbar('Ticks',[1, 2], 'TickLabels',{'< 10\circ','> 10\circ'});
%    
% figure;
% surf(X, Y, Z, (slope > 20) + 1, 'linestyle', 'none');
% title('Slope < 20\circ'); axis equal;
% colorbar('Ticks',[1, 2], 'TickLabels',{'< 20\circ','> 20\circ'})
