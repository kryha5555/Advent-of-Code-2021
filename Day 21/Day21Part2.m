clear
clc

inputArray = importdata('input.txt').data;

%% Calculate result for part 2
tic
p1 = inputArray(1)-1; % -1 so mod works
p2 = inputArray(2)-1;

s1 = 0;
s2 = 0;
die = 0;
[w1,w2] = countWins(p1,p2,s1,s2,[]);

fprintf("Part 2: %d\n",max(w1,w2));
toc

%% Count number of wins per players p1 and p2 with scores s1 and s2
function [w1, w2, map] = countWins(p1, p2, s1, s2, map)
if s1 >= 21 
    w1 = 1; % p1 wins if he has >=21 pts
    w2 = 0;
    return
end
 
if s2 >= 21
    w1 = 0;
    w2 = 1; % p2 wins if he has >=21 pts
    return
end

state = sprintf("v%d_%d_%d_%d",p1,p2,s1,s2); % state is key of map
if isfield(map, state) % if result of that state was calculated before
    W = map.(state);   % fetch that result 
    w1 = W(1);
    w2 = W(2);
    return
end

w1 = 0; w2 = 0;

for d1 = 1:3
    for d2 = 1:3
        for d3 = 1:3
            pTemp = mod(p1 + d1 + d2 + d3,10);
            sTemp = s1 + pTemp + 1; % +1 because we did -1 in input
            
            [t1, t2, map] = countWins(p2, pTemp, s2, sTemp, map); % switch player taking turn
            w1 = w1+t2; % switch player results (taking turns)
            w2 = w2+t1;  
        end
    end
end

map.(state) = [w1 w2]; % save calculated result under current state
end