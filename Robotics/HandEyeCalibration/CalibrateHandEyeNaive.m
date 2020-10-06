function Hcg = CalibrateHandEyeNaive(Hgi, Hci)

obj = @(x) computeResidual(x, Hgi, Hci);

x0 = [0 0 0  0.1 0 0  0 0 0  0.1 0 0]';
opts = optimoptions('lsqnonlin');
opts.Algorithm = 'levenberg-marquardt';
opts.Display = 'iter';

x = lsqnonlin(obj, x0, [], [], opts);

Hcg = buildTransform(x(1:3), x(4:6));
end

function res = computeResidual(x, Hgi, Hci)
    % Build transform from camera to gripper
    tcg = x(1:3);
    rcg = x(4:6);
    Hcg = buildTransform(tcg, rcg);
    
    % Build transform from calibration points to robot 
    tpr = x(7:9);
    rpr = x(10:12);
    Hpr = buildTransform(tpr, rpr);
    
    % Compute translation and rotation error for each station
    numStations = size(Hgi, 3);
    
    er = zeros(numStations, 1);
    et = zeros(numStations, 1);
    
    for iii = 1:numStations
        HcrComputed = Hpr / Hci(:,:,iii);
        HcrMeasured = Hgi(:,:,iii)*Hcg;
        
        He = HcrMeasured \ HcrComputed;
        
        et(iii) = norm(He(1:3,4));
        axang = rotm2axang(He(1:3,1:3));
        er(iii) = axang(4);
    end
    
    res = [er; et];
end

function H = buildTransform(t, r)
    ang = norm(r);
    ax = r/ang;
    R = axang2rotm([ax', ang]);
    
    H = [R, t; [0, 0, 0, 1]];
end
