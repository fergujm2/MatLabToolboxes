clear;
        
% In this script, we make the assumption that we are dealing with cubic 
% B-splines where the spacing between knots is unitity for all t_i. Given 
% this, we can write down the 16 equations of constraint between all of the 
% segment basis polynomials. If all of the polynomials are parameterized as 
% a_i, b_i, c_i, d_i (i = 1 ... 4), then we can form the linear equation:

%    a1  b1  c1  d1  a2  b2  c2  d2  a3  b3  c3  d3  a4  b4  c4  d4
A = [1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
     0,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
     0,  0,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
     1,  1,  1,  1, -1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
     0,  1,  2,  3,  0, -1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
     0,  0,  2,  6,  0,  0, -2,  0,  0,  0,  0,  0,  0,  0,  0,  0
     0,  0,  0,  0,  1,  1,  1,  1, -1,  0,  0,  0,  0,  0,  0,  0
     0,  0,  0,  0,  0,  1,  2,  3,  0, -1,  0,  0,  0,  0,  0,  0
     0,  0,  0,  0,  0,  0,  2,  6,  0,  0, -2,  0,  0,  0,  0,  0
     0,  0,  0,  0,  0,  0,  0,  0,  1,  1,  1,  1, -1,  0,  0,  0
     0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  2,  3,  0, -1,  0,  0
     0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  2,  6,  0,  0, -2,  0
     0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  1,  1,  1
     0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  2,  3
     0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  2,  6
     0,  0,  0,  0,  0,  0,  0,  0,  1,  0,  0,  0,  0,  0,  0,  0];
     
b = [zeros(1, 15), 1]';

v = A \ b;

% Now v comes out as [a1 b1 c1 d1 ... d4], so reshape to make each column
% be the coefficients of the sement basis polynomial.
B = reshape(v, 4, 4);

% Make up some knots with unit spacing
t_i = [2, 3, 4, 5, 6];

% Create a bunch of sample points for plotting
t_s = 0:0.01:7;
x_s = zeros(size(t_s));
x_dot_s = zeros(size(t_s));
x_ddot_s = zeros(size(t_s));

% Evaluate value and derivs at the sample points
for iii = 1:length(t_s)
    [x_s(iii), x_dot_s(iii), x_ddot_s(iii)] = eval_basis(t_s(iii), t_i, B);
end

% Plot the results
figure(1);
clf;
hold on;

plot(t_s, x_s);
plot(t_s, x_dot_s);
plot(t_s, x_ddot_s);

legend('x', 'x_{dot}', 'x_{ddot}');

% The B that we get:
%          0    0.2500    1.0000    0.2500
%          0    0.7500   -0.0000   -0.7500
%     0.0000    0.7500   -1.5000    0.7500
%     0.2500   -0.7500    0.7500   -0.2500

% The B with no rounding:
%          0      0.25   1      0.25
%          0      0.75   0     -0.75
%          0      0.75  -1.5    0.75
%          0.25  -0.75   0.75  -0.25

function [x, x_dot, x_ddot] = eval_basis(t, t_i, B)
    % First, we need to find which segment of the basis t falls into
    i = find_interval(t, t_i);
    
    % If we couldn't find an interval, then it's outside the domain
    if isempty(i)
        x = nan;
        x_dot = nan;
        x_ddot = nan;
        return
    end
    
    % Given the correct segment, evaluate the polynomial at t
    [x, x_dot, x_ddot] = eval_sbp(t, t_i(i), t_i(i + 1), B(:,i));
end

function i = find_interval(t, t_i)
    t_greater = t >= t_i;
    t_less = t < t_i;
    
    dt_greater = diff(t_greater);
    dt_less = diff(t_less);
    
    i = find(and(dt_greater == -1, dt_less == 1));
end

function [x, x_dot, x_ddot] = eval_sbp(t, t_i, t_ip1, abcd)
    
    % Check to make sure that t is in fact in the correct interval
    if t < t_i || (t - t_i) > (t_ip1 - t_i)
        x = nan;
        x_dot = nan;
        x_ddot = nan;
        return;
    end
    
    % Form the U vector
    u = (t - t_i)/(t_ip1 - t_i);
    U = [1, u, u^2, u^3];
    
    % Given that we have a cubic polynomial, we can construct the correct
    % multipliers to get x_dot and x_ddot.
    abcd_dot = [abcd(2); 2*abcd(3); 3*abcd(4); 0];
    abcd_ddot = [2*abcd(3); 6*abcd(4); 0; 0];
    
    % Multiply to get the values and then extract them.
    A = [abcd, abcd_dot, abcd_ddot];
    v = U*A;
    
    x = v(1);
    x_dot = v(2);
    x_ddot = v(3);
end