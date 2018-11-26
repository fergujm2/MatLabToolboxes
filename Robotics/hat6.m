function ahat = hat6(a)

if (size(a,1) == 6) && (size(a,2) == 1)
    v = a(1:3);
    w = a(4:6);
    
    ahat = zeros(4,4);
    
    ahat(1:3,1:3) = hat3(w);
    ahat(1:3,4)   = v;
else
    error('Input vector should be size 6x1.')
end

end