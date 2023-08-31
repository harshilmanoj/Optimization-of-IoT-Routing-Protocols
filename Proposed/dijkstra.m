function [distances,hops,battery,delivered,dead] = dijkstra(map, source, battery, importance,destination)

% start with a map of distances among N nodes
N = length(map);
dead = 0;
%initialising all hops to 0
hops(1:N)=Inf;
hops(source)=0;

% Initialise all points to infinity
distances(1:N) = Inf;

% Note all nodes as unvisited
visited(1:N) = 0;
%finding the minimum battery percentage of nodes which can be used to
%transmit

minpower=0;

if(importance==2)
    minpower=25;
end

if(importance == 1)
    minpower= 50;
end

%assuming the message will be delivered
delivered=1;

%showing the path followed
path(1:N)=0;

for i=1:N
    if battery(i)<minpower
        visited(i)=1;
    end
end
% Initialize the starting points distance as 0
distances(source)=0;

%find the unvisited Node with the smallest distance value
x=sum(visited);

while x<N
    candidates(1:N) = Inf;
    for i = 1:N
        if (visited(i) == 0)
                candidates(i)=distances(i);
        end
    end
    [minval,minpos]=min(candidates);
    if(minpos==destination)
        break;
    end
    for i=1:N
        if distances(i)>minval+map(minpos,i)
            path(i)= minpos;
            hops(i)=hops(minpos)+1;
            distances(i)=minval+map(minpos,i);
        end
    end
    visited(minpos)=1;
    x=x+1;
end
disp(distances)
if distances(destination)==Inf
    if(importance ~= 3)
        [distances,hops,battery,dead] = dijkstra(map, source, battery, importance+1, destination);
        return
    end
end
if distances(destination)==Inf
    delivered=0;
    return
end
temp=destination;
while temp~= source
    temp=path(temp);
    battery(temp)=battery(temp)- 5*0.1;
end

