function [phi,theta,psi] = zyz_euler(R)

if ~((R(1,3) == 0) && (R(2,3) == 0))
    theta = atan2(sqrt(1-R(3,3)^2),R(3,3));
    phi = atan2(R(2,3),R(1,3));
    psi = atan2(R(3,2),-R(3,1));
    %these determine one of the two solutions
elseif ((R(1,3) == 0) && (R(2,3) == 0))
    theta = 0;
    phi = 0;
    psi = atan2(R(2,1),R(1,1));
else
    error('Your rotation matrix may be ill-conditioned.');
end

end