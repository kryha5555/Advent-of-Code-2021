clear
clc

inputArray = readmatrix('input.txt', 'Delimiter', '', ...
    'OutputType', 'string','NumHeaderLines', 0);

%% Parse data
tic
algorithm = inputArray{1};
map = char(inputArray(2:end));

algorithm = algorithm == '#'; % translate '#' and '.' into 1 and 0
map = map == '#';

%% Calculate result for part 1
for i = 1:2
    map = enhance(map, algorithm, i);
end
result1 = sum(map, 'all')
toc

%% Calculate result for part 2
for i = 3:50
    map = enhance(map, algorithm, i);
end
result2 = sum(map, 'all')
toc

%% Enhancing function
function Y = enhance(X, A, step)
% for 9x 0's -> switch to 1
% for 9x 1's -> switch to 0
if mod(step,2) == 1 % for odd step number  -> pad with 0 
    X = padarray(X, [2,2], 0);
else                % for even step number -> pad with A(1) (to be consistent with example)
    X = padarray(X, [2,2], A(1));
end

n = size(X,1) - 2; % size of map after step (1 more in each direction)
Y = zeros(n,n);
kernel = flip(2.^(0:8));

for i = 2:n+1     % area outside (n x n) will be infinite '0' or '1'
    for j = 2:n+1 % we calculate only for area inside (n x n)
        bits = X(i-1:i+1, j-1:j+1)'; % 3x3 square around element
        Y(i-1,j-1) = kernel*bits(:); % transpose to order row-wise
    end
end
Y = A(Y+1); % create new map using algorithm
end