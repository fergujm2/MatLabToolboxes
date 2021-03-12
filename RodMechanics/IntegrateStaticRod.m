function [s, state] = IntegrateStaticRod(state_0, N, sSpan, f, K)
% Given an intialization for state y0, the number of points in the
% integration N, the initial and final arclengts sSpan, an arclength
% parameterized force distribution function f, and the rod bending matrix
% K, this returns the state y at every integration point s.

% The rod state y is defined by:
%   state_1-3:   position of rod, p
%   state_4-12:  rotation matrix of rod, R
%   state_13-15: internal force of rod, n
%   state_16-18: curvature of rod, u

[s, state]  = ode45(@(s, state) deriv(s, state, f, K), linspace(sSpan(1), sSpan(2), N), state_0);
end

function state_dot = deriv(s, state, f, K)
    % Derivative assumptions:
    %   1. Linear constitutive law for calculating changes in curvature
    %   2. Shear and extension infinitely stiff and neglected 
    %   3. The rod is perfectly straight before deformation
    %   4. The rod's profile is constant with arclength
    
    % Unpack y
    [~, R, n, u] = UnpackRodState(state);
    
    e_3 = [0; 0; 1];
    
    p_dot = R*e_3;
    R_dot = R*hat(u);
    n_dot = -[f(s); 0];
    u_dot = -inv(K)*((hat(u)*K*u) + hat(e_3)*R'*n);
    
    % Pack y_dot
    state_dot = PackRodState(p_dot, R_dot, n_dot, u_dot);
end

function matrix = hat(vector)
    x = vector(1);
    y = vector(2);
    z = vector(3);
    
    matrix = [0 -z y; z 0 -x; -y x 0];
end

