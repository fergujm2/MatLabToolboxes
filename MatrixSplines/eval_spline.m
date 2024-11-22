function [x, x_dot, x_ddot] = eval_spline(t, t_i, B, c)

i = find_interval(t, t_i);

if isempty(i) || i < 4
    x = nan;
    return;
end

% Now we only need to deal with b_i to b_ip3
b_ip0 = eval_basis(t, t_i((i - 3):(i - 0)), B);
b_ip1 = eval_basis(t, t_i((i - 2):(i + 1)), B);
b_ip2 = eval_basis(t, t_i((i - 1):(i + 2)), B);
b_ip3 = eval_basis(t, t_i((i - 0):(i + 3)), B);

b = [b_ip0, b_ip1, b_ip2, b_ip3];

if any(isnan(b))
    x = nan;
    return
end

c_i = c(i:(i + 3));
x = b*c_i;

end