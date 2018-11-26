function c = LeastSquaresSpline(degree, dimension, extendedKnotVector, xd, zd)
assert(issorted(xd), 'Must sort xd!');

B = zeros(length(xd), dimension);

for iii = 1:length(xd)
    row = EvaluateBasis(degree, dimension, xd(iii), extendedKnotVector);
    B(iii, :) = row;
end

% Now solve (B^T)*B*c = (B^T)*z (normal equations)
A = (B')*B;
y = (B')*zd;

c = A\y;
end
