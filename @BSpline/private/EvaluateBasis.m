function row = EvaluateBasis(degree, dimension, evalPoint, extendedKnotVector)
interval = FindInterval(degree, dimension, extendedKnotVector, evalPoint);
b = bspl(degree, interval, evalPoint, extendedKnotVector);

% b is the basis evaluations of blmd:bl. all others eval to 0

row = zeros(1, dimension);
row((interval-degree):interval) = b;
end
