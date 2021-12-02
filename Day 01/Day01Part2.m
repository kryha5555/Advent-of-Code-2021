%% Import data
clear
clc
inputArray = importdata('input.txt');

%% Calculate result for part 2
tic
diffArray = inputArray(4:end) - inputArray(1:end-3) > 0;
result = sum(diffArray)
toc