function y = GenerateExtendedKnotVector(a, b, dimension, degree, numberInteriorKnots)

y = zeros(1, dimension + degree + 1);
y(1:degree+1) = a;
y(dimension+1:dimension+degree+1) = b;

interior = linspace(a, b, numberInteriorKnots + 2);

y(degree+2:dimension) = interior(2:end-1);

end
