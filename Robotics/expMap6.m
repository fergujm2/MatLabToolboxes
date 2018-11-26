function map = expMap6(z,theta)

if (size(z,1) == 6) && (size(z,2) == 1)
    v = z(1:3);
    w = z(4:6);
    
    if w == [0 0 0].'
        map = assemble_transform(eye(3),v*theta);
    else
        map3 = expMap3(w,theta);

        oneone = map3;
        onetwo = (eye(3) - map3)*(cross(w,v)) + w*(w.')*v*theta;
        twoone = [0 0 0];
        twotwo = 1;
        map = [ ...

            oneone onetwo
            twoone twotwo

                ];
    end
else
    error('Input vector z should be size 6x1.');

end
