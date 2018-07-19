function [path, total_time, total_energy] = disjkstras(alist, startpt, endpt)
    visited = inf*ones(180*360, 7); % [toX toY fromX fromY cost time energy]
    visited(1, :) = [startpt, nan, nan, 0, 0, 0];
    vIdx = 2;
        
    node = startpt;
    cost = 0;
    time = 0;
    energy = 0;
    
    G = zeros(180*360, 6);
    G(1,:) = [startpt nan nan 0 0]; % [to from time energy];
    gIdx = 2;
    
    while ~isequal(node, endpt)
        neighbors = getNeighbors(alist, node);
        for n = 1:size(neighbors,1)
            loc = ismember(visited(:,1:2), neighbors(n,1:2), 'rows');
            if isempty(visited(loc))
                % node has never been visited
                new_cost = neighbors(n,3) + cost;
                new_time = neighbors(n,4) + time;
                new_energy = neighbors(n,5) + energy;
                visited(vIdx,:) = [neighbors(n,1:2) node new_cost new_time new_energy];
                vIdx = vIdx + 1;
            elseif ~isinf(visited(loc,5))
                % we have been to this neighbor before, and haven't added
                % it to the graph yet
                old_cost = visited(loc,5); % old cost to get to neighbor n
                new_cost = cost + neighbors(n,3); % cost to get to neighbor n through node
                if new_cost < old_cost
                    new_time = neighbors(n,4) + time;
                    new_energy = neighbors(n,5) + energy;
                    visited(loc,3:7) = [node new_cost new_time new_energy];
                end
            %else
                % this neighbor is already in the graph; ignore
            end
        end
        
        % find next best node: min cost from visited(_,3)
        [~, i] = min(visited(:,5));
        next_node = visited(i, 1:2);

        % update
        node = next_node;
        cost = visited(i,5);
        time = visited(i,6);
        energy = visited(i,7);
        visited(i,5) = inf; % don't keep using the same nodes
        
        % add node -> new node to graph (with new node's cost?)
        G(gIdx,:) = [node visited(i, 3:4) time energy];
        gIdx = gIdx + 1;
                
    end

    % construct path
    path = zeros(100, 2);
    path(1, :) = node;
    pIdx = 2;
    total_time = 0;
    total_energy = 0;
    while ~isequal(node, startpt)
        edge = G(ismember(G(:,1:2), node, 'rows'), :);
        node = edge(3:4);
        total_time = total_time + edge(5);
        total_energy = total_energy + edge(6);
        
        path(pIdx, :) = node;
        pIdx = pIdx + 1;
    end
    
    path = path(1:pIdx-1,:);
    
end