%% Import data
clear
clc
inputArray = importdata('input.txt');

%% Calculate result for part 1
tic
result = sum(diff(inputArray)>0);
toc