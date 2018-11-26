function a = wedge3(hata)

if (size(hata,1) == 3) && (size(hata,2) == 3)
    a = zeros(3,1);
    
    a(3) = hata(1,2)*(-1);
    a(2) = hata(1,3)*(1);
    a(1) = hata(2,3)*(-1);
else
    error('Input matrix should be of size 3x3.');
end

end