function [a,v] = RealEigen(R)
[vec, vals] = eig(R,'vector');

j = 1;
for i = 1:length(vals)
    if isreal(vals(i))
        a(j) = vals(i);
        v(:,j) = vec(:,i);
        j = j + 1;
    end
end
end