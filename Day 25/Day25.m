clear
clc

M = importdata('input.txt');

%% Calculate result
tic
M = char(M);
i = 0;

while true
    i = i+1;
    Mnew = M;
    doesMove = Mnew == '>';
    canMoveTo = Mnew == '.';
    
    for r = 1:size(M,1)
        for c = 1:size(M,2)
            C = (c ~= size(M,2))*c+1; % C = c+1; for last: C = 1
            if doesMove(r,c) && canMoveTo(r,C)
                Mnew(r,C) ='>';
                Mnew(r,c) = '.';
            end
        end
    end
    
    M = Mnew;
    doesMove = Mnew == 'v';
    canMoveTo = Mnew == '.';
     
    for r = 1:size(M,1)
        for c = 1:size(M,2)
       R = (r ~= size(M,1))*r+1; % R = r+1; for last: R = 1
            if doesMove(r,c) && canMoveTo(R,c)
                Mnew(R,c) ='v';
                Mnew(r,c) = '.';
            end
        end
    end    
  
    if isequal(Mnew,M)
        result = i
        break
    end
    M = Mnew;
end
toc