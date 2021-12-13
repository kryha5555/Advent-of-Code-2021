clc
clear
inputArray = readmatrix('input.txt','OutputType','string');

%% Parse data
tic
points = str2double(inputArray); % gives NaN on lines with fold
folds = inputArray(isnan(points(:,1)),1); % leaves only line with fold
folds = arrayfun(@(s)sscanf(s,'fold along %c=%d'), folds, ...
    'UniformOutput',false); % split direction and line number
points = points(~isnan(points(:,1)),:); % leaves only coordinates

range = flip(max(points)+1); % get size of sheet 
M = false(range); % define sheet
M(sub2ind(range, points(:,2)+1, points(:,1)+1)) = 1; % put points on sheet

%% Fold
for i = 1:numel(folds) 
    if folds{i}(1) == 'x'
        Mnew = M(:,1:folds{i}(2)); % get only left side of sheet
        M = Mnew | flip(M(:,(folds{i}(2)+2):end),2); % add values from flipped right side to left side 
    else
        Mnew = M(1:folds{i}(2),:); % get only top side of sheet
        M = Mnew + flip(M((folds{i}(2)+2):end,:)); % add values from flipped bottom side to top side
    end 
   
    if i == 1 % Get result for part 1
        result1 = sum(M,'all')
    end
end
toc
result2 = imshow(M);
