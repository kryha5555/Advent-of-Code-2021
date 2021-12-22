clear
clc

inputArray = importdata('input.txt').data;

%% Calculate result for part 1
tic
p1 = inputArray(1)-1; % -1 so mod works
p2 = inputArray(2)-1;

s1 = 0;
s2 = 0;
die = 0;

while true
    t1 = sum(die+1:die+3);
    die = die+3;
    
    p1 = mod(p1+t1,10);
    s1 = s1+ p1+1; % +1 because we did -1 in input
    if s1>=1000
        s2*die
        break
    end
    
    t2 = sum(die+1:die+3);
    die = die+3;
    
    p2 = mod(p2+t2,10);
    s2 = s2 + p2+1;
    if s2>=1000
        s1*die
        break
    end
    
end
toc