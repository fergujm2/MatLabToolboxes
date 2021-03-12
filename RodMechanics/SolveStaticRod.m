function [s, state] = SolveStaticRod(p_0, R_0, D, E, G, N, sSpan, f)
% Implements a shooting method in conjunction with IntegrateStaticRod in
% order to solve the static rod model given a known 2-D force distribution
% function in arclength.

I = pi/4*(D/2)^4; %m^4
K = [E*I 0 0; 0 E*I 0; 0 0 2*G*I];

n_0 = zeros(3,1);
u_0 = zeros(3,1);

state_0 = PackRodState(p_0, R_0, n_0, u_0);
nu_0_guess = zeros(6,1);

options = optimoptions('fsolve');
options.MaxFunctionEvaluations = 1e4;

nu_0 = fsolve(@(nu_0) compute_rod_tip_residual(nu_0, state_0, N, sSpan, f, K), nu_0_guess, options);

state_0 = PackRodState(p_0, R_0, nu_0(1:3), nu_0(4:6));

[s, state] = IntegrateStaticRod(state_0, N, sSpan, f, K);
end


function res = compute_rod_tip_residual(nu_0, state_0, N, sSpan, f, K)
    % Unknown is the internal forces and moments at rod base
    state_0(13:18) = nu_0;
    
    [~, state] = IntegrateStaticRod(state_0, N, sSpan, f, K);
    
    % Want the internal forces and moments to be zero at rod tip
    [~, ~, n_f, u_f] = UnpackRodState(state(end,:)');
    res = [n_f; u_f];
end