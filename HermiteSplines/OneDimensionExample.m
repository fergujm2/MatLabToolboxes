%% Caluculating HermiteSpline on [0, 1]

clear;

p_a = 1;
p_b = 0;
v_a = 1;
v_b = 1;

c = [p_a; v_a; p_b; v_b];

phi = @(t) [(1 + 2.*t).*(1 - t).^2, t.*(1 - t).^2, t.^2.*(3 - 2.*t), -t.^2.*(1 - t)];

p = @(t) phi(t)*c;

figure(1);
clf;

t_s = 0:0.01:1;
p_s = p(t_s');

plot(t_s, p_s);

%% Caluculating HermiteSpline on any Interval

clear;

b = 10;
a = 4;

p_a = 1;
p_b = -1;
v_a = 1;
v_b = 10;

x = a:0.01:b;

h =    b - a;
df = ( p_b - p_a ) ./ h;

c2 = - ( 2.0 * v_a - 3.0 * df + v_b ) ./ h;
c3 =   (       v_a - 2.0 * df + v_b ) ./ h ./ h;

dx = x - a;
f = p_a + dx .* ( v_a + dx .* (        c2 + dx .*        c3 ) );
d =               v_a + dx .* ( 2.0 .* c2 + dx .* 3.0 .* c3 );
s =                             2.0 .* c2 + dx .* 6.0 .* c3;
t =                                               6.0 .* c3;
  
  

figure(2);
clf;

plot(x, f);