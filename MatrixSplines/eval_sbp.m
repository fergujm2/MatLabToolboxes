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