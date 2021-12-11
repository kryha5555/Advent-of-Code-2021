clear
clc

inputArray = importdata('input.txt');
M = dec2base(inputArray,10) - '0';

%% Calculate result for both parts
tic
convKernel = ones(3,3); convKernel(2,2) = 0; % 3x3 2D conv kernel
step = 0; % result for part 2
flashes = 0; % result for part 1
maskSum = false(size(M));

while ~all(maskSum,'all') % get result for part 2
    step = step + 1;
    M = M + 1; % increment energy
    mask = M > 9; % get elements that can flash
    maskSum = false(size(M));
    
    while any(mask,'all') % while any element will flash
        maskSum = maskSum | mask; % add current mask to sum of masks
        M = M + conv2(mask,convKernel,'same'); % increment energy for each flashing neighbour
        mask = M > 9 & ~maskSum; % get elements that can flash, but haven't flashed yet
    end
    
    M(maskSum) = 0; % set energy of elements that have flashed to 0
    flashes = flashes + (step<101) * sum(maskSum,'all'); % get result for part 1
end

result1 = flashes
result2 = step
toc