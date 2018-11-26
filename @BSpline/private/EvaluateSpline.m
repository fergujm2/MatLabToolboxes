function val = EvaluateSpline(degree, dimension, y, c, t)
% get basis evals at the point of interest
row = EvaluateBasis(degree, dimension, t, y);

% form linear combination as output
assert(iscolumn(c), 'c should be column!');
val = row*c;
end
