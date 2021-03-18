clear;

t_span = [-2, 5];
d = 9;
n = 20;
dimensions = 2;
num_interior_knots = 7;

x = @(t) [sin(3*t) + t; cos(4*t)];

num_samples = 1000;
t = linspace(t_span(1), t_span(2), num_samples);
X = x(t);

s = BSpline.least_squares_fit(X, t, d, n);

ts = linspace(t_span(1), t_span(2), 1e5);
Xs_spline = s.evaluate(ts);
Xs_truth = x(ts);

figure(1);
clf;
hold on;

plot(Xs_spline(1,:), Xs_spline(2,:));
plot(Xs_truth(1,:), Xs_truth(2,:));

legend('Spline', 'Truth');

%% Plot the derivative and the acceleration 
s_dot = s.deriv();
s_ddot = s_dot.deriv();

ts = linspace(t_span(1) + 0.1, t_span(2) - 0.1, 20);

X = s.evaluate(ts);
X_dot = s_dot.evaluate(ts);
X_ddot = s_ddot.evaluate(ts);

figure(2);
clf;
hold on;

plot(Xs_spline(1,:), Xs_spline(2,:));
plot(X(1,:), X(2,:), '.k', 'MarkerSize', 20);

quiver(X(1,:), X(2,:), X_dot(1,:), X_dot(2,:), 0.5);
quiver(X(1,:), X(2,:), X_ddot(1,:), X_ddot(2,:), 0.5);

legend('Spline', 's(t_s)', 'v(t_s)', 'a(t_s)');

%% TODO: Finish integral test
s_int = s.integ();
s_int.evaluate(ts);