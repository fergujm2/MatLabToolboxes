
% Here we try to copy the kalibr c++ code into matlab to make it work


% Evaluation points
t_s = t_k(1):0.1:t_k(end);
x_s = zeros(size(t_s));

for iii = 1:length(t_s)
    x_s = eval(t_s(iii));
end











function x = eval(t)
    x = evalD(t,0);
end

function xd = evalD(t, derivativeOrder)
    % Returns the normalized u value and the lower-bound time index.
    ui = computeUAndTIndex(t);
    u = computeU(ui(1), ui(2), derivativeOrder);

    bidx = ui(2) - splineOrder + 1;

    % Evaluate the spline (or derivative) in matrix form.
    %
    % [c_0 c_1 c_2 c_3] * B^T * u
    % spline coefficients

%     xd = coefficients_.block(0, bidx, coefficients_.rows(), splineOrder_) * basisMatrices_[bidx].transpose() * u;
end

function [index, width] = computeTIndex(t)
    if(t == t_max())
        % This is a special case to allow us to evaluate the spline at the boundary of the
        % interval. This is not stricly correct but it will be useful when we start doing
        % estimation and defining knots at our measurement times.
        i = knots_.end() - splineOrder_;
    else
        i = std::upper_bound(knots_.begin(), knots_.end(), t);
    end

    % Returns the index of the knot segment this time lies on and the width of this knot segment.
    t_index = *i - *(i-1);
    width = i - knots_.begin()) - 1;
end
    
function [u, index] = computeUAndTIndex(t)
    [index, denom] = computeTIndex(t);

    if(denom <= 0.0)
        % The case of duplicate knots.
        u = 0;
        return;
    end
    
    u = (t - knots_[index])/denom;
end
    
    
    
    
function computeU(uval, segmentIndex, derivativeOrder)
    u = Eigen::VectorXd::Zero(splineOrder_);
    delta_t = knots_[segmentIndex+1] - knots_[segmentIndex]; 
    multiplier = 0.0;

    if(delta_t > 0.0)
        multiplier = 1.0/pow(delta_t, derivativeOrder);
    end

    uu = 1.0;
    for(int i = derivativeOrder; i < splineOrder_; i++)
        u(i) = multiplier * uu * dmul(i,derivativeOrder) ; 
        uu = uu * uval;
    end

    return u;
end
    
    
    
    
    
    
    
    
    