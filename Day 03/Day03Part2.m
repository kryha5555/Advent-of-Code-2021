%% Import data
clear
clc

fid = fopen('input.txt');
inputArray = textscan(fid,'%s');
inputArray = cell2mat(inputArray{1})-'0';
fclose(fid);

%% Calculate result for part 2
tic
i = 1;
inputOxy = -inputArray;
while size(inputOxy,1) > 1
    m = mode(inputOxy(:,i));
    inputOxy(inputOxy(:,i) ~= m,:) = [];
    i = i+1;
end

i = 1;
inputCo2 = -inputArray;
while size(inputCo2,1) > 1
    m = mode(inputCo2(:,i));
    inputCo2(inputCo2(:,i) == m,:) = [];
    i = i+1;
end

result = bin2dec(num2str(-inputOxy)) * bin2dec(num2str(-inputCo2))
toc