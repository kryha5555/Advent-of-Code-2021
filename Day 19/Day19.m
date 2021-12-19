clear
clc

inputArray = readmatrix('input.txt', 'Delimiter', '', ...
    'OutputType', 'string','NumHeaderLines', 0);

%% Parse data
tic
M = rotmats();
beacons = cell(1,36);
for i = 1:numel(inputArray)
    if inputArray{i}(1:2) == "--"
        idx = sscanf(inputArray(i),"--- scanner %d ---") + 1;
        beacons{idx} = [];
    else
        beacons{idx} = [beacons{idx}; sscanf(inputArray(i),"%d,%d,%d")'];
    end
end

%%  Calculate result for part 2
scanners = [0 0 0];
knownBeacons = beacons{1};
unknownScanners = 2:length(beacons);
idx = 1;
while ~isempty(unknownScanners)
    if idx > length(unknownScanners) % cycle through unknown scanners
        idx = 1;
    end
    beaconIdx = unknownScanners(idx);
    currentBeacon = beacons{beaconIdx};
    
    for r = 1:length(M) % for each of 24 rotations
        rot = M{r};
        beaconCopy = currentBeacon * rot; % rotate beacons positions
        dst = pdist2(knownBeacons, beaconCopy); % distance between known beacons and current beacons
        if nnz(dst == mode(dst,'all')) >= 12 % if most common distance occurs >= 12 times
            [p,q] = find(dst == mode(dst,'all'),1); % find 1st occurence
            relPos = knownBeacons(p,:) - currentBeacon(q,:) * rot;
            
            knownBeacons = [knownBeacons; beaconCopy + relPos]; % calculate position of beacons 
            knownBeacons = unique(knownBeacons,'rows'); % keep only unique beacons
            
            scanners = [scanners; relPos]; % save scanner position
            unknownScanners(unknownScanners == beaconIdx) = [];
            idx = idx-1; % remove scanner from list
            break % only one rotation to consider
        end    
    end  
    idx = idx+1;
end
result1 = length(knownBeacons)
toc

%% Calculate result for part 2
result2 = max(pdist(scanners,'cityblock'),[],'all')
toc

%% Function to get all rotations matrix of cube (Symmetric group S4)
function M = rotmats()
Mx = [1 0 0
    0 1 0
    0 0 1
    1 0 0
    0 0 -1
    0 1 0
    1 0 0
    0 -1 0
    0 0 -1
    1 0 0
    0 0 1
    0 -1 0
    0 -1 0
    1 0 0
    0 0 1
    0 0 1
    1 0 0
    0 1 0
    0 1 0
    1 0 0
    0 0 -1
    0 0 -1
    1 0 0
    0 -1 0
    -1 0 0
    0 -1 0
    0 0 1
    -1 0 0
    0 0 -1
    0 -1 0
    -1 0 0
    0 1 0
    0 0 -1
    -1 0 0
    0 0 1
    0 1 0
    0 1 0
    -1 0 0
    0 0 1
    0 0 1
    -1 0 0
    0 -1 0
    0 -1 0
    -1 0 0
    0 0 -1
    0 0 -1
    -1 0 0
    0 1 0
    0 0 -1
    0 1 0
    1 0 0
    0 1 0
    0 0 1
    1 0 0
    0 0 1
    0 -1 0
    1 0 0
    0 -1 0
    0 0 -1
    1 0 0
    0 0 -1
    0 -1 0
    -1 0 0
    0 -1 0
    0 0 1
    -1 0 0
    0 0 1
    0 1 0
    -1 0 0
    0 1 0
    0 0 -1
    -1 0 0];
M = cell(1,24);
for i = 0:23
    idx = 3*i+1 : 3*i+3;
    M{i+1} = Mx(idx,:);
end
end