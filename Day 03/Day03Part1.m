%% Import data
clear
clc

fid = fopen('input.txt');
inputArray = textscan(fid,'%s');
inputArray = cell2mat(inputArray{1})-'0';
fclose(fid);

%% Calculate result for part 1
tic
gamma = mode(inputArray);
epsilon = 1-gamma;

result = bin2dec(num2str(gamma)) * bin2dec(num2str(epsilon))
toc