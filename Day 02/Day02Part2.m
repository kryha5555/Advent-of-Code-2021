%% Import data
clear
clc
inputArray = importdata('input.txt');
dir = string(inputArray.textdata);
val = inputArray.data;

%% Calculate result for part 2
tic

idxF = dir == "forward";
idxU = dir == "up";
idxD = dir == "down";

diffH = val;
diffH(idxU) = -diffH(idxU);
diffH(idxF) = 0;

h = sum(val(idxF));
a = cumsum(diffH);
d = sum(a(idxF) .* val(idxF));

result = h*d
toc