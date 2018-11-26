function ahat = hat3(a)

if (size(a,1) == 3) && (size(a,2) == 1)
    ahat = [...
        0   -a(3)   a(2)
        a(3)   0    -a(1)
        -a(2)   a(1)    0
        ];
else
    error('Input vector should be size 3x1.')
end

end
    

