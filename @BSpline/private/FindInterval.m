function interval = FindInterval(degree, dimension, y, t)
% y is the extended knot vector.  This means that
% a = y1 = y2 = ... = ydp1 and 
% b = ynp1 = ynp2 = ... = ynpdp1
% So there must be n + d + 1 elements of y

assert(length(y) == dimension + degree + 1, 'Wrong number of elements of y!');

a = y(1);
allEqualA = all(y(1:degree+1) == a);
assert(allEqualA, 'Wrong left endpoint format for y!');

b = y(end);
allEqualB = all(y(dimension+1:dimension+degree+1) == b);
assert(allEqualB, 'Wrong right endpoint format for y!');

assert(t >= a && t <= b, 't must be in the interval!');
assert(issorted(y), 'y must be sorted in ascending order!');

for iii = 1:length(y)
    if t < y(iii)
        interval = iii - 1;
        return
    end
    
end

interval = dimension;

end
