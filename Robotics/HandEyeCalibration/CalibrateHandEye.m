function HCG = CalibrateHandEye(HGi, HCi)
% Algorithm is based on "A New Technique for Fully Autonomous and Efficient 
% 3D Robotics Hand/Eye Calibration" by Tsai and Lenz

numStations = size(HGi, 3);

% Preprocess
stations = 1:numStations;
stationPairs = nchoosek(stations, 2);

numPairsTotal = size(stationPairs, 1);
numPairsChosen = ceil(numPairsTotal/1);

% We want to choose the numPairsChosen station pairs that have the highest
% rotation angle between them. We'll loop through all of them to decide.
angles = zeros(1, numPairsTotal);

pGij = zeros(3, numPairsTotal);
tGij = zeros(3, numPairsTotal);

pCij = zeros(3, numPairsTotal);
tCij = zeros(3, numPairsTotal);

for iii = 1:numPairsTotal
    pair = stationPairs(iii,:);
    
    HGij = (HGi(:,:,pair(2))) \ HGi(:,:,pair(1));
    HCij = (HCi(:,:,pair(2))) / HCi(:,:,pair(1));
    
    axang = tform2axang(HGij);
    angles(iii) = axang(4);
    
    tGij(:,iii) = tform2trvec(HGij);
    tCij(:,iii) = tform2trvec(HCij);
    pGij(:,iii) = rotm2p(tform2rotm(HGij));
    pCij(:,iii) = rotm2p(tform2rotm(HCij));
end

% Now sort the data from biggest rotation Rij to smallest
[~, indSorted] = sort(angles, 'descend');

pGij = pGij(:,indSorted);
tGij = tGij(:,indSorted);
pCij = pCij(:,indSorted);
tCij = tCij(:,indSorted);

% Solve Step 1 using only the first numPairsChosen pairs
A = zeros(3*numPairsChosen, 3);
b = zeros(3*numPairsChosen, 1);

% Fill in A and b
for iii = 1:numPairsChosen
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
RCG = p2rotm(pCG);

% Solve Step 4 using only the first numPairsChosen pairs

A = zeros(3*numPairsChosen, 3);
b = zeros(3*numPairsChosen, 1);

% Fill in A and b
for iii = 1:numPairsChosen
    RGij = p2rotm(pGij(:,iii));
    APart = RGij - eye(3);
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

function p = rotm2p(R)
    % Now, this is important, in the paper, they do not define the 3D
    % rotation vector normally. Instead, they do it this way:
    axang = rotm2axang(R);
    ax = axang(1:3);
    ang = axang(4);
    
    p = 2*sin(ang/2)*ax/norm(ax);
end

function R = p2rotm(p)
    % The following should hold for the above vector:
    alph = sqrt(4 - norm(p)^2);
    R = (1 - 1/2*norm(p)^2)*eye(3) + 1/2*(p*(p') + alph*skew(p));
end