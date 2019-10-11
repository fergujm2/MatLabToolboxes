clear;

numStations = 100;
stdRot = 3*pi/180;
stdPos = 1.0;

[HGi, HCi] = GenerateMeasurements(numStations, stdRot, stdPos);
[HCG] = CalibrateHandEye(HGi, HCi);

fprintf('HCG is estimated to be: \n')
disp(HCG);
