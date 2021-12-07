%% Import data
clear
clc
inputArray = importdata('input.txt');

%% Calculate result for part 1
tic
result1 = sum(abs(inputArray - median(inputArray)))
toc

%% Calculate result for part 2
tic
range = min(inputArray):max(inputArray);
dx = abs(inputArray' - range);
fuel = sum(dx.^2 + dx) / 2;
result2 = min(fuel)
toc