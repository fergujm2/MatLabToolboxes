function T = invert_transform(T)

[R0, t0] = disassemble_transform(T);

R = R0.';
t = -(R0.')*t0;

T = assemble_transform(R,t);

end