%% Import data
clear
clc

inputArray = importdata('input.txt');
order = sscanf(inputArray.textdata{1},'%d,')';
B = inputArray.data;
B = permute(reshape(B',[5,5,size(B,1)/5]),[2,1,3]);

%% Calculate result for part 1
tic
boardList = 1:size(B,3);
for num = order
    B(B == num) = NaN; % swap every drawn number with NaN
    for idx = 1:5 % for each row/col
        for board = boardList % for each board
            if all(isnan(B(:,idx,board))) || ...
                    all(isnan(B(idx,:,board))) % if row or col is all NaN
                B(isnan(B)) = 0; % swap back zeros to NaN
                result = num*sum(B(:,:,board),'all')
                toc
                return
            end
        end
    end
end