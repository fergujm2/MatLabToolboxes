function map = expMap3(w,theta)

if (size(w,1) == 3) && (size(w,2) == 1)
    M = norm(w);
    wHat = hat3(w);
    if M == 0
        map = eye(3);
    else
        map = eye(3) + wHat/M*sin(M*theta) + wHat*wHat/(M^2)*(1-cos(M*theta));
    end
else
    error('Input vector w should be size 3x1.');
    
end