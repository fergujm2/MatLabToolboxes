function [te, re] = SimCalibrateHandeye()

numStations = 100;

stdRotC = 0.5*pi/180;
stdPosC = 0.2;
stdRotR = 3.0*pi/180;
stdPosR = 1.0;

% Ground truth X
% HcgGt = [axang2rotm([1,1,1,pi/4]), [100; 200; 300]; [0, 0, 0, 1]];
HcgGt = [   -0.0086   -0.0315   -0.9995  -23.5051
             0.9982    0.0596   -0.0104  -57.7768
             0.0599   -0.9977    0.0309   25.4037
             0         0         0         1.0000];

% fprintf('HCG ground truth is: \n');
% disp(HcgGt);

% Ground truth calib to robot
HcrGt = [axang2rotm([1,1,0,pi/3]), [2000; 0; 0]; [0, 0, 0, 1]];

[HGi, HCi] = GenerateMeasurements(HcgGt, HcrGt, numStations, stdRotC, stdPosC, stdRotR, stdPosR);
Hcg = CalibrateHandEye(HGi, HCi);
% Hcg = CalibrateHandEyeNaive(HGi, HCi);

% fprintf('HCG is estimated to be: \n');
% disp(Hcg);

He = HcgGt \ Hcg;

te = norm(He(1:3,4)); % mm
axang = rotm2axang(He(1:3,1:3)); 
re = rad2deg(axang(4)); % deg

% fprintf('Translation error: %.2f mm\nRotation error: %.2f deg\n\n', te, re);

end