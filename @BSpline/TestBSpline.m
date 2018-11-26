function TestBSpline()
tSpan = [0, 10];

% f = @(t) pulse(t);
f = @(t) curvyThing(t)';

degree = 3;
numberInteriorKnots = 40;

b = BSpline(tSpan, degree, numberInteriorKnots);

td = linspace(tSpan(1), tSpan(2), 5000);
yd = f(td);

b.leastSquaresFit(td, yd);

t = linspace(tSpan(1), tSpan(2), 1000);
y = f(t);

[te, ye] = b.evaluate(1000);


h = figure(1);
clf;
h.Color = [1,1,1];
hold on;
plot(t, y);
plot(te, ye);

end

function y = pulse(t)
    y = zeros(length(t), 1);
    for iii = 1:length(t)
        if t(iii) > 3 && t(iii) < 7
            y(iii) = 2;
        else
            y(iii) = 0;
        end
    end
end

function y = curvyThing(t)
    y = sin(exp(2*cos(t)));
end

function y = 
