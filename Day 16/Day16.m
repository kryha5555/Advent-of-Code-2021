clear
clc

inputArray = split(readmatrix('input.txt','Delimiter', '', 'OutputType', 'string'),'');

%% Parse input
tic
tape = inputArray(2:end-1);
tape = dec2bin(hex2dec(tape),4);
tape = char(join(string(tape),''));

%% Calculate result for both parts
[~, result1, result2] = processTape(tape)
toc

%% Tape processing function
function [head, versionSum, value] = processTape(tape)
head = 0;
versionSum = 0;

version = tape(1:3);
version10 = bin2dec(version);
versionSum = versionSum + version10;

type = tape(4:6);
type10 = bin2dec(type);
% fprintf("V: %s -> %d; T: %s -> %d\n",version,version10,type,type10);

if type10 == 4 % literal value
    head = 7; % 3 bits for version and 3 bits for type
    number = '';
    while true
        number = [number, tape(head+1:head+4)]; % skip prefix bit, get 4 bits of number
        if tape(head) == '0' % if prefix bit is 0
            break % current number was last in packet
        end
        head = head + 5; % put head after number we've just read
    end
    
    value = bin2dec(number); % get number from bits
%     fprintf("Num: %s -> %d\n",number,value);
    head = head + 5; % put head after last number
    
    return
end

bitsRead = 0;
numberArray = [];

% Type other than 4 means operator
if tape(7) == '0' % next 15 bits are length
    L = tape(8:22); % get length
    L10 = bin2dec(L);
%     fprintf("Len: %s -> %d\n",L,L10);
    while bitsRead < L10 % while whole length has not been read
        [head, versionPartial, value] = processTape(tape(23+bitsRead:end));
        versionSum = versionSum + versionPartial; % accumulate version sum
        bitsRead = bitsRead + head-1; % -1, because head is +1 of last read bit
        numberArray = [numberArray value]; % accumulate read numbers
    end
    head = 23 + bitsRead; % put head after last processed bit
    
elseif tape(7) == '1' % next 11 bits are occurences
    L = tape(8:18); % get length
    L10 = bin2dec(L);
%     fprintf("Occ: %s -> %d\n",L,L10);
    for j = 1:L10 % for each occurence
        [head, versionPartial, value] = processTape(tape(19+bitsRead:end));
        versionSum = versionSum + versionPartial;
        bitsRead = bitsRead + head-1;
        numberArray = [numberArray value];
    end
    head = 19 + bitsRead;
end

value = 0;
switch type10
    case 0
        value = sum(numberArray);
    case 1
        value = prod(numberArray);
    case 2
        value = min(numberArray);
    case 3
        value = max(numberArray);
    case 5
        value = numberArray(1) > numberArray(2);
    case 6
        value = numberArray(1) < numberArray(2);
    case 7
        value = numberArray(1) == numberArray(2);
end
end
