clear
clc

inputArray = readmatrix('input.txt', 'Delimiter', '->', 'OutputType', ...
    'string', 'NumHeaderLines', 0);

%% Parse data
tic
poly = inputArray{1};

pairs = strings(length(inputArray)-1,3);
for i = 2:length(inputArray) % for each rule 
    pairs(i-1,:) = [inputArray(i,1) inputArray{i,1}(1)+inputArray(i,2) ...
        inputArray(i,2)+inputArray{i,1}(2)]; % get two pairs from every pair
    rules.(pairs(i-1,1)) = pairs(i-1,2:3); % map pair -> two pairs
end

pairs = char(sort(pairs(:,1))); % leave only 1st column, sorted

for i = 1:length(pairs) % for every possible pair
    mapClear.(pairs(i,:)) = 0; % map pair -> no occurences
end

for i = 1:length(poly)-1 % for every pair in poly (leaving last char)
    mapCurr.(poly(i:i+1)) = count(poly,poly(i:i+1)); % map pair -> occurences    
end

%% Calculate result for part 1 or 2
% steps = 10;
steps = 40;

for step = 1:steps
    mapNew = mapClear; % get clean map to count new occurences
    for pair = string(fieldnames(mapCurr))' % for every pair in current map
        if mapCurr.(pair) == 0
            continue % skip if pair doesn't occur in poly
        end
        r = rules.(pair);
        mapNew.(r(1)) = mapNew.(r(1)) + mapCurr.(pair); % count new pairs
        mapNew.(r(2)) = mapNew.(r(2)) + mapCurr.(pair);
    end
    mapCurr = mapNew; % carry new count to next step
end

elements = unique(pairs); % get all possible chars 
occ = zeros(1,numel(elements));

for i = 1:numel(elements) % for each possible char
    occ(i) = 0;
    for pair = pairs(pairs(:,1) == elements(i),:)' % count by 1st letter in pair
        occ(i) = occ(i) + mapCurr.(pair); 
    end
end

last_el = elements == poly(end); % last char isn't 1st letter of any pair
occ(last_el) = occ(last_el) + 1; % add to count, last letter is always last

result = max(occ) - min(occ)
toc