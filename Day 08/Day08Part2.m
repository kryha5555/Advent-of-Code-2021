clear
clc

inputData=readcell('input.txt');
inputData = string(cellfun(@sort,inputData,'UniformOutput',false));
patterns = inputData(:,1:10);
values = inputData(:,12:end);

%%
tic
result = 0;
for i = 1:size(patterns,1)
    map = cell(10,1);
    for n = 1:10
        number = char(patterns(i,n));
        switch length(number)
            case 2
                map{1} = number;
            case 3
                map{7} = number;
            case 4
                map{4} = number;
            case 7
                map{8} = number;
        end
    end  
    
    for n = 1:10
        number = char(patterns(i,n));
        if length(number) == 5
            if length(intersect(number,map{1})) == 2 
                map{3} = number; % 3 has 2 intersects with 1
            elseif length(intersect(number,map{4})) == 2 % when 1 intersect with 1
                map{2} = number; % 2 has 2 intersects with 4
            else
                map{5} = number; % else it must be 5
            end
        elseif length(number)== 6
            if length(intersect(number,map{1})) == 1 
                map{6} = number; % 6 has 1 intersects with 1
            elseif length(intersect(number,map{4})) == 3 % when 2 intersects with 1
                map{10} = number; % 0 has 3 intersects with 4
            else
                map{9} = number; % else it must be 9
            end
        end
    end
    
    map = string(map);
    [decoded,~] = find(map==values(i,:)); % map output to numbers
    decoded = mod(decoded,10); % swap 10 with 0
    result = result + str2double(num2str(decoded','%d'));
end
result
toc