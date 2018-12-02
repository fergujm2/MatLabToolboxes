classdef BSpline < handle
    properties
        a
        b
        degree
        numberInteriorKnots
        dimension
        
        extendedKnotVector
        cVector
    end
    
    methods (Access = public)
        function instance = BSpline(tSpan, degree, numberInteriorKnots)
            instance.a = tSpan(1);
            instance.b = tSpan(2);
            
            instance.degree = degree;
            instance.numberInteriorKnots = numberInteriorKnots;
            
            instance.dimension = numberInteriorKnots + degree + 1;
            
            instance.extendedKnotVector = GenerateExtendedKnotVector(...
                instance.a, instance.b, instance.dimension, ...
                instance.degree, numberInteriorKnots);
            
        end
        
        function [xe, ye] = evaluate(instance, numEvalPts)
            xe = linspace(instance.a, instance.b, numEvalPts);
            ye = zeros(numEvalPts, 1);
            
            for iii = 1:length(ye)
                ye(iii) = EvaluateSpline(instance.degree, ...
                    instance.dimension, instance.extendedKnotVector, ...
                    instance.cVector, xe(iii));
            end
        end
        
        function [xe, ye] = evaluateDeriv(instance, numEvalPts)
            % TODO
        end
        
        function leastSquaresFit(instance, xd, zd)
            instance.cVector = LeastSquaresSpline(instance.degree, ...
                instance.dimension, instance.extendedKnotVector, xd, zd);
        end
    end
    
    methods(Static)
        TestBSpline
    end
end
