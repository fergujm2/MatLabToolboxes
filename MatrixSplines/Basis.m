clear;

% Must choose number of coefficients = number of knots

num_seg = 6;
num_knots = num_seg + 7; % Note must choose M + 7
num_basis = num_seg + 3; % Note must choose M + 3

% Let's choose these knots as they did in the paper.
t_k = -3:9;

% As for the coefficients, they need to be a certain length
c = zeros(num_basis, 1);
c(4) = 1;
c(4) = 1;

order = 4; % Arbitrary
degree = 3; % Must choose order - 1;


% We have chosen equally spaced knots with separation of 1. Given this,
% along with the fact that we're using K = 4, our M is this:
M4 = 1/factorial(3).*[ 1  4  1  0;
                      -3  0  3  0;
                       3 -6  3  0;
                      -1  3 -3  1];               

% Evaluation points
t_s = t_k(1):0.1:t_k(end);
x_s = zeros(size(t_s));

for iii = 1:length(t_s)
    interval = find_interval(t_s(iii), t_k); % 4 is here to make sure we're actually indexing correctly staring at -3
    
    % If it wasn't actually inside of an interval, don't define output
    if isempty(interval)
        x_s(iii) = nan;
        continue;
    end
    
    % If not fully supported by basis here, don't define output
    if interval < 4 || interval > 9
        x_s(iii) = nan;
        continue;
    end
    
    t_i = t_k(interval - 3);
    t_ip1 = t_k(interval - 3 + 1);
    
    u = (t_s(iii) - t_i)/(t_ip1 - t_i);
    U = [1, u, u.^2, u.^3];
    
    c_i = c((interval - 3):(interval - 0));
    x_s(iii) = U*M4*c_i;
end

figure(1);
clf;

plot(t_s, x_s);


function i = find_interval(t, t_i)
    t_greater = t >= t_i;
    t_less = t < t_i;
    
    dt_greater = diff(t_greater);
    dt_less = diff(t_less);
    
    i = find(and(dt_greater == -1, dt_less == 1));
end