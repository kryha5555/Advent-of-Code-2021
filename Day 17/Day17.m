clear
clc
input = importdata('input.txt');

%% Parse data
tic
pos = sscanf(input{1},"target area: x=%d..%d, y=%d..%d");
pos0 = [0,0]; % starting position, (y,x)

pos1 = [pos(3), pos(1)]; % bounding box lower corner, (y,x)
pos2 = [pos(4), pos(2)]; % bounding box upper corner, (y,x)

%% Calculate result for both parts 
maxY = [];
for vy0 = -100:100
    for vx0 = 0:pos2(2)+1
        vy = vy0; vx = vx0;
        pos = pos0;
        currMaxY = 0;
        for step = 1:200
            if all(pos1<=pos & pos<=pos2) % if pos between pos1 and pos2
                maxY(end+1) = currMaxY;
                break     
            end
            pos(1) = pos(1)+vy;
            pos(2) = pos(2)+vx;
            if vx > 0
                vx = vx-1;
            elseif vx < 0
                vx = vx+1;
            end
            vy = vy-1;            
            currMaxY = max(currMaxY, pos(1));
        end
    end
end
result1 = max(maxY)
result2 = length(maxY)
toc