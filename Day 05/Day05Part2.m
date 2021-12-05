%% Import data
clear
clc

inputArray = importfile('input.txt');
x1 = inputArray(:,1)+1;
y1 = inputArray(:,2)+1;
x2 = inputArray(:,3)+1;
y2 = inputArray(:,4)+1;

%% Calculate result for part 1
tic
M = zeros(max(inputArray,[],'all')+1);
for i = 1:numel(x1)
    dX = abs(x1(i)-x2(i))+1;
    dY = abs(y1(i)-y2(i))+1;
    
    X = linspace(x1(i),x2(i),dX);
    Y = linspace(y1(i),y2(i),dY);
    
    if x1(i) == x2(i) || y1(i) == y2(i)
        M(X,Y) = M(X,Y)+1;
    else
        for j = 1:length(X)
            M(X(j),Y(j)) = M(X(j),Y(j)) + 1;
        end
    end
end
sum(M>1,'all')
toc