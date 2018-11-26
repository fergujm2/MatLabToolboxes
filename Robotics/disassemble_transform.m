function [R, t] = disassemble_transform(T)

R = T(1:3,1:3);
t = T(1:3,4);

end