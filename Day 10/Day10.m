clear
clc

fid = fopen('input.txt');
M = textscan(fid,'%s');
fclose(fid);
M = M{1};

%%
tic
closing = [')', ']', '}', '>'];
openings = ['(', '[', '{', '<'];
errorScore = [3, 57, 1197, 25137];
result1 = 0;
result2 = [];

for i = 1:numel(M)
    stack = char([]);
    isLegal = 1;
    
    for j = 1:length(M{i}) % part 1
        
        whichOpening = (M{i}(j) == openings);
        whichClosing = (M{i}(j) == closing);
        
        if any(whichOpening) % if opening bracket
            stack(end+1) = M{i}(j); % push to stack
            
        else % if closing bracket
            if whichClosing == (stack(end) == openings) % if matches opening
                stack(end) = []; % pop bracket from stack
                
            else % if not matching opening
                result1 = result1 + errorScore(whichClosing);
                isLegal = 0; % set flag for part 2
                break
            end
        end
    end
    
    if isLegal % part 2
        tempScore = 0;
        stack = flip(stack); % flip order or brackets
        
        for k = 1:numel(stack)
            whichOpening = (stack(k) == openings);
            tempScore = 5*tempScore +  whichOpening*(1:4)';
        end
        
        result2(end+1) = tempScore;
    end
end

result1
result2 = median(result2)
toc