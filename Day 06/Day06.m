%% Import data
clear
clc
inputArray = importdata('input.txt');

%% Calculate result for part 1
days = 80;
part1 = countLanternfish(inputArray,days)

%% Calculate result for part 2
days = 256;
part2 = countLanternfish(inputArray,days)

%% Helper function
function y = countLanternfish(M,n)
tic
A = hist(M,0:8);
for i = 1:n
      A(8) = A(8) + A(1);
      A = circshift(A,-1);    
end
y = sum(A);
toc
end