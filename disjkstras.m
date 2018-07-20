function [path] = disjkstras(alist, startpt, endpt, numnodes)
    visited = inf*ones(numnodes, 5); % [toX toY fromX fromY cost]
    visited(1, :) = [startpt, nan, nan, 0];
    vIdx = 2;
        
    node = startpt;
    cost = 0;

    
    G = zeros(numnodes, 4);
    G(1,:) = [startpt nan nan]; % [to from];
    gIdx = 2;
    
    while ~isequal(node, endpt)
        neighbors = getNeighbors(alist, node);
        for n = 1:size(neighbors,1)
            loc = ismember(visited(:,1:2), neighbors(n,1:2), 'rows');
            if isempty(visited(loc))
                % node has never been visited
                new_cost = neighbors(n,3) + cost;
                visited(vIdx,:) = [neighbors(n,1:2) node new_cost];
                vIdx = vIdx + 1;
            elseif ~isnan(visited(loc,5))
                % we have been to this neighbor before, and haven't added
                % it to the graph yet
                old_cost = visited(loc,5); % old cost to get to neighbor n
                new_cost = cost + neighbors(n,3); % cost to get to neighbor n through node
                if new_cost < old_cost
                    visited(loc,3:5) = [node new_cost];
                end
            %else
                % this neighbor is already in the graph; ignore
            end
        end
        
        % find next best node: min cost from visited(_,3)
        [~, i] = min(visited(:,5));
        next_node = visited(i, 1:2);
        
        if isnan(visited(i,5)) || isinf(visited(i,5))
            path = [];
            return;
        end

        % update
        node = next_node;
        cost = visited(i,5);
        visited(i,5) = nan; % don't keep using the same nodes
        
        % add node -> new node to graph (with new node's cost?)
        G(gIdx,:) = [node visited(i, 3:4)];
        gIdx = gIdx + 1;
                
    end

    % construct path
    path = zeros(100, 2);
    path(1, :) = node;
    pIdx = 2;
    while ~isequal(node, startpt)
        edge = G(ismember(G(:,1:2), node, 'rows'), :);
        node = edge(3:4);
        
        path(pIdx, :) = node;
        pIdx = pIdx + 1;
    end
    
    path = flipud(path(1:pIdx-1,:));
    
end