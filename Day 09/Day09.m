clear
clc

fid = fopen('input.txt');
M = textscan(fid,'%s');
fclose(fid);
M = cell2mat(M{1});
M = double(M)-'0';

%% Calculate result for part 1, prepare for part 2
tic
M = padarray(M,[1,1],9); % add border to input matrix
x0 = []; y0 = []; % low points location
result1 = 0;

for i = 2:size(M,1)-1
    for j = 2:size(M,2)-1
        if M(i-1,j) > M(i,j) && M(i+1,j) > M(i,j) ...
                && M(i,j-1) > M(i,j) && M(i,j+1) > M(i,j)
            result1 = result1 + M(i,j) + 1;
            x0(end+1) = i;
            y0(end+1) = j;
        end
    end
end

result1
toc

%% Calculate result for part 2
visited = zeros(size(M));

for i = 1:numel(x0) % floodfill for every low point
    [M, visited] = floodfill(M, visited, x0(i), y0(i), i);
end

basins = hist(visited,unique(visited)); % get occurences of each basin per column
basins = sum(basins(2:end,:),2); % sum basins in columns, omitting '0'
result2 = prod(maxk(basins,3)) % result is product of 3 basins of max count
toc

%% Recursive floodfill function
function [M,visited] = floodfill(M, visited, x, y, val)
if visited(x,y) > 0 || M(x,y) == 9 % if already flooded or is a wall
    return % don't flood
end

visited(x,y) = val; % flood with number of low point

[M, visited] = floodfill(M, visited, x + 1, y, val);
[M, visited] = floodfill(M, visited, x - 1, y, val);
[M, visited] = floodfill(M, visited, x, y + 1, val);
[M, visited] = floodfill(M, visited, x, y - 1, val);
end