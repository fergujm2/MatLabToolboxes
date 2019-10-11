function HCG = CalibrateHandEye(HGi, HCi)

numStations = size(HGi, 3);

% Preprocess
stations = 1:numStations;

stationPairs = nchoosek(stations, 2);

numPairs = size(stationPairs, 1);

pGij = zeros(3, numPairs);
tGij = zeros(3, numPairs);
RGij = zeros(3, 3, numPairs);

pCij = zeros(3, numPairs);
tCij = zeros(3, numPairs);

for iii = 1:numPairs
    pair = stationPairs(iii,:);
    
    HGij = (HGi(:,:,pair(2))) \ HGi(:,:,pair(1));
    HCij = (HCi(:,:,pair(2))) / HCi(:,:,pair(1));
    
    tGij(:,iii) = tform2trvec(HGij);
    tCij(:,iii) = tform2trvec(HCij);
    RGij(:,:,iii) = tform2rotm(HGij);
    
    axang = rotm2axang(tform2rotm(HGij));
    ax = axang(1:3);
    ang = axang(4);
    pGij(:,iii) = ang*ax/norm(ax);
    
    axang = rotm2axang(tform2rotm(HCij));
    ax = axang(1:3);
    ang = axang(4);
    pCij(:,iii) = ang*ax/norm(ax);
end

% Solve Step 1

A = zeros(3*numPairs, 3);
b = zeros(3*numPairs, 1);

% Fill in A and b
for iii = 1:numPairs
    APart = skew(pGij(:,iii) + pCij(:,iii));
    bPart = pCij(:,iii) - pGij(:,iii);
    
    indexLo = 3*(iii - 1) + 1;
    indexHi = indexLo + 3 - 1;
    
    A(indexLo:indexHi,:) = APart;
    b(indexLo:indexHi,:) = bPart;
end

pCGPrime = A \ b;

% Solve Step 3

pCG = 2*pCGPrime/sqrt(1 + norm(pCGPrime)^2);

alpha = sqrt(4 - 0.5*norm(pCG)^2);
RCG = (1 - 0.5*norm(pCG)^2)*eye(3) + 0.5*(pCG*(pCG') + alpha*skew(pCG));

% Solve Step 4

A = zeros(3*numPairs, 3);
b = zeros(3*numPairs, 1);

% Fill in A and b
for iii = 1:numPairs
    APart = RGij(:,:,iii) - eye(3);
    bPart = RCG*tCij(:,iii) - tGij(:,iii);
    
    indexLo = 3*(iii - 1) + 1;
    indexHi = indexLo + 3 - 1;
    
    A(indexLo:indexHi,:) = APart;
    b(indexLo:indexHi,:) = bPart;
end

tCG = A \ b;

% Build result for Hcg

HCG = [RCG, tCG; [0, 0, 0, 1]];

end

function wHat = skew(w)
    wHat = [0, -w(3), w(2); w(3), 0, -w(1); -w(2), w(1), 0];
end