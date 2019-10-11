function [Hg, Hc] = GenerateMeasurements(numStations, stdRot, stdPos)

% Ground truth X
Hcg = [eye(3), [1; 2; 3]; [0, 0, 0, 1]];

% Ground truth calib to robot
Hcr = [eye(3), [10; 20; 30]; [0, 0, 0, 1]];

Hg = zeros(4, 4, numStations);
Hc = zeros(4, 4, numStations);
for iii = 1:numStations
    HgGt = getRandomTransform();
    HcGt = inv((Hcr\HgGt)*Hcg);
    HgNoise = addNoiseToTransform(HgGt, stdRot, stdPos);
    HcNoise = addNoiseToTransform(HcGt, stdRot, stdPos);
    Hg(:, :, iii) = HgNoise;
    Hc(:, :, iii) = HcNoise;
end

end

function T = getRandomTransform()
    % Get uniformly random axis
    axis = rand(1, 3) - 0.5;
    axis = axis./norm(axis);
    
    % Get random theta
    theta = pi*rand();
    
    R = axang2rotm([axis, theta]);
    t = 20*(2*rand(3, 1) - 1.0);

    T = [R, t; [0, 0, 0, 1]];
end

function TNoise = addNoiseToTransform(T, stdTheta, stdPos)
    R = tform2rotm(T);
    t = tform2trvec(T)';
    
    % Get uniformly random axis
    axis = rand(1, 3) - 0.5;
    axis = axis./norm(axis);
    
    % Get gaussian random angle
    theta = stdTheta*randn();
    
    RNoise = R*axang2rotm([axis, theta]);
    tNoise = t + stdPos*randn(3, 1);
    
    TNoise = [RNoise, tNoise; [0, 0, 0, 1]];
end