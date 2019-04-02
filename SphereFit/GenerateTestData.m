function [X, Y, Z] = GenerateTestData(n)

s = linspace(0, pi/4, n);

x = cos(s);
y = sin(s);

z = zeros(1, length(s));

pts = cart2hom([x', y', z']);


R = axang2rotm([1,1,1,pi/4]);
t = [123;456;789];

Tr = rotm2tform(R);
Tt = [eye(3), t; [0,0,0,1]];


ptsTransformed = (Tr*Tt*(pts'))';

X = ptsTransformed(:,1);
Y = ptsTransformed(:,2);
Z = ptsTransformed(:,3);

noiseFactor = 0.005;

X = X + noiseFactor*randn(length(s),1);
Y = Y + noiseFactor*randn(length(s),1);
Z = Z + noiseFactor*randn(length(s),1);
end