clear
clc
inputArray = readmatrix('input.txt', 'Delimiter', '', 'OutputType', 'char');

%% Calculate result for part 1
tic
numbers = cellfun(@parse,inputArray,'UniformOutput',false);

n = numbers{1};
for i = 2:numel(numbers)
    n = reduce(add(n, numbers{i}));
end
result = magnitude(n)
toc

%% Calculate result for part 2
tic
magnitudeMax = 0;
for i = 1:numel(numbers)
    for j = 1:numel(numbers)
        n = reduce(add(numbers{i}, numbers{j}));
        magnitudeMax = max(magnitudeMax,magnitude(n));
    end
end
result2 = magnitudeMax
toc

%% Parse
function numbers = parse(str)
depth = (str == '[') - ([0, str(1:end-1) == ']']);
depth = cumsum(depth); % increase depth at '[', decrease after ']'
values = str - '0'; % char to int
values(values < 0 | values > 9) = -1; % save '[', ',', and ']' as -1
numbers = [values; depth];
end

%% Add
function n = add(a,b)
n = [[-1; 0] a [-1; 0] b [-1; 0]]; % add '[', ',', and ']'
n(2,:) = n(2,:) + 1; % increase depth
end

%% Reduce
function n = reduce(n)
explodeFlag = true;
splitFlag = true;
while(explodeFlag || splitFlag) % if did either action in iteration before
    [n, explodeFlag] = tryExplode(n);
    if explodeFlag
        continue % check for explode again after exploding
    end
    [n, splitFlag] = trySplit(n);
end
end

%% Explode
function [n, explodeFlag] = tryExplode(n)
idx = find(n(2,:) >= 5 ,1); % depth of 5 -> 4 nested pairs

if isempty(idx)
    explodeFlag = false;
    return
end

explodeFlag = true;
a = n(1,idx+1); % 1st number in pair
b = n(1,idx+3); % 2nd number in pair

for j = idx:-1:1 % from opening '[', left
    if n(1,j) >= 0 % if number
        n(1,j) = n(1,j) + a; % add left value to it 
        break % only first one
    end
end
for j = idx+5:size(n,2) % from closing ']', right
    if n(1,j) >= 0 % if number
        n(1,j) = n(1,j) + b; % add right value to it 
        break % only first one
    end
end

left = n(:, 1:idx-1); % up to opening '['
right = n(:, idx+5:end); % from closing ']'
n = [left, [0; 4], right]; % replace pair "[a,b]" with '0';
end

%% Split
function [n, splitFlag] = trySplit(n)
idx = find(n(1,:) >= 10, 1); % get index of first number >= 10

if isempty(idx)
    splitFlag = false;
    return
end

splitFlag = true;
left = n(:,1:idx-1);
right = n(:,idx+1:size(n,2));
value = n(1,idx);
depth = n(2,idx) + 1;
toInsert = [[-1, floor(value/2), -1, ceil(value/2), -1]; ... 
    depth*ones(1,5)]; 
n = [left, toInsert, right]; % replace number with "[f,c]"
end

%% Magnitude
function m = magnitude(x)
depth = x(2,1);
idx = find(x(2,:) == depth); % find occurences of outermost depth

if numel(idx) == 5 % -> only "[a,b]" of this depth -> two numbers
    left = x(1,2);
    right = x(1,4);
elseif numel(idx) == 3  % only '[', ',' and ']' of this depth -> two pairs
    left = x(:, idx(1)+1:idx(2)-1);
    right = x(:, idx(2)+1:idx(3)-1);
    left = magnitude(left);
    right = magnitude(right);
else % only "[a," and ']' or '[' and ",b]" of this depth -> pair and number
    if idx(2)-idx(1) == 1 % "[a," and ']' -> number, pair
        left = x(1, idx(1)+1);
        right = x(:, idx(3)+1:idx(4)-1);
        right = magnitude(right);
    else % '[' and ",b]" -> pair, number
        left = x(:, idx(1)+1:idx(2)-1);
        left = magnitude(left);
        right = x(1, idx(2)+1);
    end
end
m = 3 * left + 2 * right;
end
