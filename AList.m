classdef AList < handle
    properties
        theList
    end
    methods
        function initialize(obj, titan_dem, cost_fn)
            
            N = 1;
            NE = 2;
            E = 3;
            SE = 4;
            S = 5;
            SW = 6;
            W = 7;
            NW = 8;
            
            % make the list
            numNeighbors = 8; % horz, vert, diagonal
            width = size(titan_dem,1);
            height = size(titan_dem,2);
            obj.theList = cell(width, height);
            
            for i = 1:width
                for j = 1:height
                    hood = zeros(numNeighbors, 5); % the neighborhood
                    % [x y cost time energy]
                    
                    % NOTE: the directions are wrong, but it doesn't matter
                    hood(N, 1:2) = [i, wrapY(j+1)];
                    [c, t, e] = cost_fn([i,j], hood(N,1:2));
                    hood(N, 3:5) = [c, t, e];
                    hood(NE, 1:2) = [wrapX(i+1), wrapY(j+1)];
                    [c, t, e] = cost_fn([i,j], hood(NE,1:2));
                    hood(NE, 3:5) = [c, t, e];
                    hood(E, 1:2) = [wrapX(i+1), j];
                    [c, t, e] = cost_fn([i,j], hood(E,1:2));
                    hood(E, 3:5) = [c, t, e];
                    hood(SE, 1:2) = [wrapX(i+1), wrapY(j-1)];
                    [c, t, e] = cost_fn([i,j], hood(SE,1:2));
                    hood(SE, 3:5) = [c, t, e];
                    
                    hood(S, 1:2) = [i, wrapY(j-1)];
                    [c, t, e] = cost_fn([i,j], hood(S,1:2));
                    hood(S, 3:5) = [c, t, e];
                     hood(SW, 1:2) = [wrapX(i-1), wrapY(j-1)];
                    [c, t, e] = cost_fn([i,j], hood(SW,1:2));
                    hood(SW, 3:5) = [c, t, e];
                     hood(W, 1:2) = [wrapX(i-1), j];
                    [c, t, e] = cost_fn([i,j], hood(W,1:2));
                    hood(W, 3:5) = [c, t, e];
                     hood(NW, 1:2) = [wrapX(i-1), wrapY(j+1)];
                     [c, t, e] = cost_fn([i,j], hood(NW,1:2));
                    hood(NW, 3:5) = [c, t, e];
                    
                    obj.theList{i, j} = hood;
                end
            end
        end
        
        function neighbors = getNeighbors(obj, node)
           neighbors = obj.theList{node(1), node(2)};
        end
        
%         function weight = getWeight(obj, nodeA, nodeB)
%             neighbors = getNeighbors(obj, nodeA);
%             match = neighbors(ismember(neighbors(:,1:2), nodeB, 'rows'),:);
%             if isempty(match)
%                 weight = inf;
%             else
%                 weight = match(3);  
%             end
%         end
    end
end

% "X" = latitude
function wrapped = wrapX(x)
    if (x > 180)
        wrapped = x-180;
    elseif (x < 1)
        wrapped = x+180;
    else
        wrapped = x;
    end
end

% "Y" = longitude
function wrapped = wrapY(y)
    if (y > 360)
        wrapped = y-360;
    elseif (y < 1)
        wrapped = y+360;
    else
        wrapped = y;
    end
end