function draw_frame(h, H, axis_mag, cone_scale, syslabel)

R = H(1:3,1:3);
t = H(1:3,4);

draw_coords(h, R, t, axis_mag, cone_scale, [], [], syslabel);

end