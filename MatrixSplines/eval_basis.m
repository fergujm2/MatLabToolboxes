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