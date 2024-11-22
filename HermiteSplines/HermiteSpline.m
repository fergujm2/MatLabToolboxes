classdef HermiteSpline < handle
    properties

    end
    
    methods (Access = public)
        function instance = HermiteSpline(t_span, degree, dimensions, num_interior_knots)
            if nargin > 0

            end
        end
        
        function X = evaluate(instance, t)
            X = zeros(instance.m, length(t));

            for iii = 1:instance.m
                c = instance.C(iii,:);
                X(iii,:) = sval2(instance.d, instance.y, c, t);
            end
        end
        
        function instance_deriv = deriv(instance)
            Cd = zeros(instance.m, instance.n - 1);

            for iii = 1:instance.m
                [~, cd] = derspl(instance.d, instance.y, instance.C(iii,:));
                Cd(iii,:) = cd;
            end
            
            instance_deriv = BSpline([instance.a, instance.b], instance.d - 1, instance.m, instance.k);
            instance_deriv.C = Cd;
        end
        
        function instance_integ = integ(instance)
            C_int = zeros(instance.m, instance.n + 1);

            for iii = 1:instance.m
                c = instance.C(iii,:);
                [c_int, ~] = intsplco(instance.d, instance.y, c);
                C_int(iii,:) = c_int;
            end
            
            instance_integ = BSpline([instance.a, instance.b], instance.d + 1, instance.m, instance.k);
            instance_integ.C = C_int;
        end
    end
    
    methods(Static)
        function instance = interpolate(X, t, d)
            n = length(t);
            m = size(X, 1);
            C = zeros(m, n);
            
            for iii = 1:m
                z = X(iii,:);
                [y, c] = notaknot(d, t, z);
                C(iii,:) = c';
            end
            
            k = n - d - 1;
            instance = BSpline([t(1), t(end)], d, size(X,1), k);
            instance.C = C;
            instance.y = y;
        end
        
        function instance = least_squares_fit(X, t, d, n)
            m = size(X,1);
            C = zeros(m, n);
            
            k = n - d - 1;
            instance = BSpline([t(1), t(end)], d, size(X,1), k);
            
            for iii = 1:m
                z = X(iii,:)';
                c = lsqspl(instance.d, instance.n, instance.y, t, z);
                instance.C(iii,:) = c;
            end
        end
    end
end


function phi