clear
clc

inputArray = importdata('input.txt');
inputArray = split(inputArray,'-');

%% Prepare data and calculate result for part 1
tic
G = graph(inputArray(:,1), inputArray(:,2)); % maps strings to numbers
startNode = find(strcmp(G.Nodes.Name,'start')); % find start node

adjacent = {}; % create neighbors table, so we don't call neighbors() every recursion
for i = 1:numel(G.Nodes) % calling it every recursion causes 50x increase in processing time for my input
    adjacent{end+1} = neighbors(G,i);
end

result1 = visit(adjacent, G.Nodes.Name, startNode,[],[],0)
toc

%% Calculate result for part 2
tic
result2 = visit(adjacent, G.Nodes.Name, startNode,[],[],1)
toc

%% Graph traversal function
function retVal = visit(adjacent, names, node, seen, dupFlag, part2)
nodeName = names{node}; % get node name from node number

if strcmp(nodeName,'end') % if end node
    retVal = 1; % set route as valid
    return % end immediately
end

if part2 && ... % only for part 2 
        strcmp(nodeName,'start') && any(node == seen) % if returning to start node
    retVal = 0; % set route as invalid
    return % end immediately
end

if any(node == seen) && ( ... % if node was already visited
        nodeName(1) >='a' && nodeName(1) <='z') % and is lowercase
    
    if part2 && ... % only for part 2
            isempty(dupFlag) % if wasn't visited 
        dupFlag = 1; % set duplicate flag 
    else
        retVal = 0; % set route as invalid
        return % end immediately
    end
end

seen = union(seen,node); % add current node to visited nodes
outVal = 0; 

for i = adjacent{node}' % for each adjacent node
    outVal = outVal + visit(adjacent, names, i, seen, dupFlag, part2); % add number of valid routes via adjacent node
end

retVal = outVal; % return number of valid routes from passed node
end