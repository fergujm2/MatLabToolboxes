% Follow this Wikipedia page for model equations: 
%   https://en.wikipedia.org/wiki/Kalman_filter#Example_application.2C_technical

% State vector definition: x_k = [p_k; v_k], i.e. position and velocity.
% Evolution of state vector: x_k = F*x_km1 + G*a_k, a_k is random accel.
% This is the same as: x_k = F*x_km1 + w_k, w_k ~ N(0, Q); Q = G*(G')*sig_a

F = [1, T; 0, 1];
G = [1/2*T^2; T];

siga = 10; % STD of the unknown accelleration "noise"
sigz = 0.01; % STD of the position measurements

% Measurement equation: z_k = H*x_k + v_k, v_k ~ N(0, sig_z)
H = [1, 0];
Q = G*(G')*siga^2;
R = sigz^2;

% Suppose that the ground-truth trajectory is sinusoidal:
p = @(t) sin(2.*t);
v = @(t) 2.*cos(2.*t);
a = @(t) -4.*sin(2.*t);

T = 0.01;
t = 0:0.01:10;

pGt = p(t);
vGt = v(t);
aGt = a(t);

z = pGt' + mvnrnd(0, R, length(t)); % position measurement data

% Initialize estimates
xHat = zeros(2,1);
pHat = eye(2);

% Run filter
for k = 2:length(t)
    [xHat(:,k), pHat] = KalmanUpdate(xHat(:,k-1), pHat, 0, z(k), F, 0, H, Q, R);
end

% Plot results
figure(1);
clf;

subplot(1,2,1);
title('Position: Estimated vs. Truth');
hold on;

plot(t, pGt, '--k');
plot(t, xHat(1,:), '-k');

xlabel('time (sec)');
ylabel('position (m)');
legend('Truth', 'Kalman');

subplot(1,2,2);
title('Velocity: Estimated vs. Truth');
hold on;

plot(t, vGt, '--k');
plot(t, xHat(2,:), '-k');
plot(t(2:end), diff(z)./T, '.k', 'MarkerSize', 2);

xlabel('time (sec)');
ylabel('velocity (m/s)');
legend('Truth', 'Kalman', 'Numeric Deriv.');
