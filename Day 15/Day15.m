clear
clc

inputArray = readmatrix('input.txt','Delimiter','','OutputType','string');
inputArray = single(char(inputArray)) - '0';

%% Calculate result for part 1
tic
result1 = findMinimalPathCost(inputArray)
toc

%% Calculate result for part 2
tic
inputArray = [inputArray, inputArray+1, inputArray+2, ...
    inputArray+3, inputArray+4]; % pad array horizontally 
inputArray = [inputArray; inputArray+1; inputArray+2; ...
    inputArray+3; inputArray+4]; % pad array vertically 

gt9 = inputArray > 9 ; % all elements greater than 9
inputArray(gt9) = inputArray(gt9) - 9; % subtract 9 from them

result2 = findMinimalPathCost(inputArray)
toc

%% Solving function
function cost = findMinimalPathCost(M)
[H,W] = size(M); % get dimmensions of array
S = (H-2)*(W-2)*4 + (2*(H-2) + 2*(W-2))*3 + 4*2; % calculate nodes number

source = strings(1,S); target = strings(1,S); % nodes are in form of "a,b"
weight = zeros(1,S); % weight(i) = weight(source(i) -> target(i))

i = 1;
for h = 1:H
    for w = 1:W
        if h > 1  % up
           source(i) = h + "," + w;
           target(i) = (h-1) + "," + w;
           weight(i) = M(h-1,w);
           i = i+1;
        end
        if h < H  % down
           source(i) = h + "," + w;
           target(i) = (h+1) + "," + w;
           weight(i) = M(h+1,w);
           i = i+1;
        end
        if w > 1  % left
           source(i) = h + "," + w;
           target(i) = h + "," + (w-1);
           weight(i) = M(h,w-1);
           i = i+1;
        end
        if w < W  % right
           source(i) = h + "," + w;
           target(i) = h + "," + (w+1);
           weight(i) = M(h,w+1);
           i = i+1;
        end        
    end
end

G = digraph(source,target,weight); % weight(a->b) ~= weight(b->a) => digraph
[~,cost] = shortestpath(G,"1,1",H + "," + W);
end