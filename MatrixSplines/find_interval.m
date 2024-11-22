function i = find_interval(t, t_i)
    t_greater = t >= t_i;
    t_less = t < t_i;
    
    dt_greater = diff(t_greater);
    dt_less = diff(t_less);
    
    i = find(and(dt_greater == -1, dt_less == 1));
end