% Make up some knots with correct spacing

num_segments = 7;
num_knots = num_segments + 7;
num_basis = num_segments + 3;

t_i = linspace(2, 10, num_knots);
spacing = mean(diff(t_i));

B = get_basis_matrix();

c = zeros(num_basis, 1);
c(3) = 1;

% Create a bunch of sample points for plotting
t_s = 0:0.01:7;
x_s = zeros(size(t_s));
x_dot_s = zeros(size(t_s));
x_ddot_s = zeros(size(t_s));

% Evaluate value and derivs at the sample points
for iii = 1:length(t_s)
    [x_s(iii)] = eval_spline(t_s(iii), t_i, B, c);
end

% Plot the results
figure(1);
clf;
hold on;

plot(t_s, x_s);
plot(t_s, x_dot_s);
plot(t_s, x_ddot_s);

legend('x', 'x_{dot}', 'x_{ddot}');



