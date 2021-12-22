clear
clc

inputArray = readmatrix('input.txt','Delimiter', {'..',',','='}, ...
    "OutputType","string");

%% Parse input
tic
cubes = str2double(inputArray(:,[2,3,5,6,8,9]));
steps = inputArray(:,1) == "on x";
cubes = [steps, cubes];

%% Calculate result for both parts
result1 = calculateCubesOn(cubes(1:20,:));
toc
result2 = calculateCubesOn(cubes);
toc
fprintf("Part 1: %d \nPart 2: %d \n", result1, result2);

%% Main calculating function
function ret = calculateCubesOn(cubesInput)
n = size(cubesInput,1);
cubes = [];

for i = 1:n
    curr = cubesInput(i,:);
    cubesLit = [];
    cubesOld = [];
    if curr(1) == 1 % if cube turns light on, add to array
        cubesLit = curr;
    end
    for j = 1:size(cubes, 1) % for each cube that was lit before
        toIntersect = cubes(j,:);
        if cubesIntersect(toIntersect,curr) % if it intersects with current cube
            cubesUpdate = separateCubes(toIntersect,curr);
            cubesLit = [cubesLit; cubesUpdate]; % add separated cubes to array
            cubesOld(end+1) = j; % mark non-separated cube as old
        end
    end
    cubes(cubesOld,:) = []; % remove non-separated cubes
    cubes = [cubes; cubesLit]; % save all newly lit cubes
end

edgesLength = cubes(:,[3,5,7]) - ...
    cubes(:,[2,4,6]) + 1; % counting cubes, not distance -> +1
volumes = prod(edgesLength, 2); % multiply row-wise
ret = sum(volumes);
end

%% Check if cube A and cube B intersects
function ret = cubesIntersect(A,B)
% Find the maximum of the coordinates closest to each axis.
% Then find the minimum of the coordinates furthest from each axis.
% What remains is the intersection.
% If first values are not greater than the second values, cubes intersect
closest = max([ A([2,4,6]) ;
                B([2,4,6]) ]);  % max of  closest  to  axis values
furthest = min([ A([3,5,7]) ;
                 B([3,5,7]) ]); % min of furthest from axis values

ret = all(closest <= furthest, 'all');
end

%% Return lit cubes calculated from intersection of cubes A and B
function C = separateCubes(A,B)
closest = max([ A([2,4,6]) ;
                B([2,4,6]) ]);  % max of  closest  to  axis values
furthest = min([ A([3,5,7]) ;
                 B([3,5,7]) ]); % min of furthest from axis values

I = [B(1), closest(1), furthest(1), closest(2), furthest(2), ...
    closest(3), furthest(3),]; % get intersection cube, won't be lit

C = [A; A; A; A; I; I]; % get base for 6 subcubes

C(1,3) = I(2) - 1; % C1's X-axis max is I's X-axis min -1 -> lower part

C(2,2) = I(3) + 1; % C2's X-axis min is I's X-axis max +1 -> upper part

C(3,2) = I(2);     % C3's X-axis min is I's X-axis min
C(3,3) = I(3);     % C3's X-axis max is I's X-axis max
C(3,5) = I(4) - 1; % C3's Y-axis max is I's Y-axis min -1 -> left  part

C(4,2) = I(2);     % C4's X-axis min is I's X-axis min
C(4,3) = I(3);     % C3's X-axis max is I's X-axis max
C(4,4) = I(5) + 1; % C3's Y-axis min is I's Y-axis max -1 -> right part

C(5,1) = A(1);     % C5's value is same as A's value
C(5,6) = A(6);     % C5's Z-axis min is A's Z-axis min
C(5,7) = I(6) - 1; % C5's Z-axis max is I's Z-axis min -1 -> front part

C(6,1) = A(1);     % C6's value is same as A's value
C(6,7) = A(7);     % C5's Z-axis max is A's Z-axis max
C(6,6) = I(7) + 1; % C5's Z-axis min is I's Z-axis max +1 -> back  part

valid = C(:,2) <= C(:,3) & ... % minX <= maxX
        C(:,4) <= C(:,5) & ... % minY <= maxY
        C(:,6) <= C(:,7) ;     % minZ <= maxZ

C = C(valid,:);
end