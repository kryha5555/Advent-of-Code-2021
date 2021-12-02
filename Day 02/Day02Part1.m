%% Import data
clear
clc
inputArray = importdata('input.txt');
dir = string(inputArray.textdata);
val = inputArray.data;

%% Calculate result for part 1
tic

idxF = dir == "forward";
idxU = dir == "up";
idxD = dir == "down";

h = sum(val(idxF));
d = sum(val(idxD)) - sum(val(idxU));

result = h*d
toc