function a = wedge6(hata)

if (size(hata,1) == 4) && (size(hata,2) == 4)
    
    w = wedge3(hata(1:3,1:3));
    v = hata(1:3,4);
    
    a = [v;w];
else
    error('Input matrix should be of size 4x4.');
end

end