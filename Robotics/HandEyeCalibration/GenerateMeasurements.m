function [Hg, Hc] = GenerateMeasurements(Hcg, Hcr, numStations, stdRotC, stdPosC, stdRotR, stdPosR)

Hg = zeros(4, 4, numStations);
Hc = zeros(4, 4, numStations);
for iii = 1:numStations
    HgGt = getRandomTransform();
    HcGt = inv((Hcr\HgGt)*Hcg);
    HgNoise = addNoiseToTransform(HgGt, stdRotR, stdPosR);
    HcNoise = addNoiseToTransform(HcGt, stdRotC, stdPosC);
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
    t = 1000*(2*rand(3, 1) - 1.0);

    T = [R, t; [0, 0, 0, 1]];
end

function TNoise = addNoiseToTransform(T, stdTheta, stdPos)
    R = tform2rotm(T);
    t = tform2trvec(T)';
    
    % Get random axis
    axis = randn(1, 3);
    axis = axis./norm(axis);
    
    % Get gaussian random angle
    theta = stdTheta*randn();
    RNoise = R*axang2rotm([axis, theta]);
    
    axis = randn(3, 1);
    axis = axis./norm(axis);
    
    et = stdPos*randn();
    tNoise = t + et.*axis;
    
    TNoise = [RNoise, tNoise; [0, 0, 0, 1]];
end