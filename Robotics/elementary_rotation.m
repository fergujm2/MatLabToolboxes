function R = ElementaryRotation(angle,string,vectorOperator)

if vectorOperator == true
    angle = angle*(-1);
elseif vectorOperator == false
else
    error('Enter true or false for whether to treat the rotation as an operation.');
end
    
c = cos(angle); %radians
s = sin(angle);

if (string == 'x')
    R = [1  0  0
         0  c -s
         0  s  c];
     
elseif (string == 'y')
    R = [c  0  s
         0  1  0
        -s  0  c];
    
elseif (string == 'z')
    R = [c -s  0
         s  c  0
         0  0  1];
else 
    error('Enter a standard basis vector, (x, y, or z) about which rotation is applied.');
end



end