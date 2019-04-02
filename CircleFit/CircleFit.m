function [center, normal, r] = CircleFit(X, Y, Z)

objective = @(params) obj(X, Y, Z, params);

opts = optimoptions('fminunc', 'Disp', 'Iter', 'MaxFunctionEvaluations', 10000);
sol = fminunc(objective, [mean(X); mean(Y); mean(Z); 0; 0; 1; 1], opts);

x = sol(1);
y = sol(2);
z = sol(3);
n1 = sol(4);
n2 = sol(5);
n3 = sol(6);
r = sol(7);

center = [x; y; z];
normal = [n1; n2; n3];
normal = normal./norm(normal);
end

function err = obj(X, Y, Z, params)
    x = params(1);
    y = params(2);
    z = params(3);
    n1 = params(4);
    n2 = params(5);
    n3 = params(6);
    r = params(7);
    
    center = [x; y; z];
    n = [n1; n2; n3];
    n = n./norm(n);
    
    res = zeros(length(X), 1);
    
    for iii = 1:length(X)
        pt = [X(iii); Y(iii); Z(iii)];
        v = pt - center;
        
        distToPlane = dot(v, n);
        pointOnPlane = v - distToPlane*n;
        directionToArc = pointOnPlane./norm(pointOnPlane);
        pointOnCircle = center + r*directionToArc;
        
        distFromCircle = norm(pt - pointOnCircle);
        
        res(iii) = distFromCircle;
    end
    
    err = sum(res);
end