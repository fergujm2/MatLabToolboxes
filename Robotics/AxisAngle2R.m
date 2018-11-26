function R = AxisAngle2R(k,theta)
k = k./norm(k);

c = cos(theta); s = sin(theta); v = 1 - c;
kx = k(1); ky = k(2); kz = k(3);

R = ...
    [kx^2*v+c,     kx*ky*v-kz*s, kx*kz*v+ky*s
     kx*ky*v+kz*s, ky^2*v+c,     ky*kz*v-kx*s
     kx*kz*v-ky*s, ky*kz*v+kx*s, kz^2*v+c];
end