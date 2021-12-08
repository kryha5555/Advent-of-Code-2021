clear
clc

inputData=readcell('input.txt');
inputData = inputData(:,12:end);

%%
tic
L = strlength(inputData);
M = ismember(L, [2,3,4,7]);
result = sum(M,'all')
toc