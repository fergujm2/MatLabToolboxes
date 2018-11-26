function draw_coords(h, R, t, axis_mag, cone_scale, color, cone, syslabel)
% draw_coords() places a coordinate system in the desired figure
% h  => is in the format #s### for example 1s212 represents
%       figure(1) subplot(212)
% R  => the basis (rotation matrix) of the frame to be plotted
% t  => the [x;y;z] translation from [0;0;0] to the desired frame
% axis_mag => the length of the axes (basis vectors)
% cone_scale => the size of the cones at the tip of the axis (relative to 1)
% color => [r,g,b] color triplet where r,g, and b are between 0 and 1
% cone => the cone stl can be calculated externally and input to speed up
%         plotting when several frames are used (default for empty input 
%         is to calculate the cone at runtime)
% syslabel => the frame's label (can be char or number)
n=1;if nargin<n||isempty(h),h=1;end
if length(h)>1&&h(2)=='s',sbplot = str2double(h(3:5));else sbplot = [];end
n=n+1;if nargin<n||isempty(R),R=eye(3);end
n=n+1;if nargin<n||isempty(t),t=[0;0;0];else t=t(:);end
n=n+1;if nargin<n||isempty(axis_mag),axis_mag=1;end
n=n+1;if nargin<n||isempty(cone_scale),cone_scale=0.1*axis_mag;end
n=n+1;if nargin<n||isempty(color),color=[0,0,0];end
n=n+1;if nargin<n||isempty(cone),cone=cone_maker;end
n=n+1;if nargin<n||isempty(syslabel),syslabel='0';end
if ~ischar(syslabel)
    syslabel = num2str(syslabel);
end

if ~isempty(sbplot)
    figure(str2double(h(1)))
    subplot(sbplot)
else
    figure(h)
end
hold on
basis_pts = R*[axis_mag,0,0;0,axis_mag,0;0,0,axis_mag]+repmat(t,[1,3]);
init_spacer = 0.05; text_scaling = 0.05*(axis_mag-1);
axis_dist = axis_mag + init_spacer + text_scaling;
text_pts = R*[axis_dist,0,0;0,axis_dist,0;0,0,axis_dist]+repmat(t,[1,3]);
 
fsize = 6;

conex = cone;
conex.vertices = (R*R_y(pi/2)*cone_scale*conex.vertices.').'+repmat(basis_pts(:,1).', [size(conex.vertices,1),1]);
patch(conex, 'FaceColor', color, 'FaceAlpha', 0.6, 'EdgeColor', 'none');
plot3([t(1),basis_pts(1,1)], [t(2),basis_pts(2,1)], [t(3),basis_pts(3,1)], 'color', color)
text(text_pts(1,1), text_pts(2,1), text_pts(3,1), ['X_',syslabel], 'color', color, 'fontsize', fsize)
coney = cone;
coney.vertices = (R*R_x(3*pi/2)*cone_scale*coney.vertices.').'+repmat(basis_pts(:,2).', [size(coney.vertices,1),1]);
patch(coney, 'FaceColor', color, 'FaceAlpha', 0.6, 'EdgeColor', 'none');
plot3([t(1),basis_pts(1,2)], [t(2),basis_pts(2,2)], [t(3),basis_pts(3,2)], 'color', color)
text(text_pts(1,2), text_pts(2,2), text_pts(3,2), ['Y_',syslabel], 'color', color, 'fontsize', fsize)
conez = cone;
conez.vertices = (R*cone_scale*conez.vertices.').'+repmat(basis_pts(:,3).',[size(conez.vertices,1),1]);
patch(conez, 'FaceColor', color, 'FaceAlpha', 0.6, 'EdgeColor', 'none');
plot3([t(1),basis_pts(1,3)], [t(2),basis_pts(2,3)], [t(3),basis_pts(3,3)], 'color', color)
text(text_pts(1,3), text_pts(2,3), text_pts(3,3), ['Z_',syslabel], 'color', color, 'fontsize', fsize)
end

function cone = cone_maker(cone_sz, disp)
n = 1;
if nargin<n||isempty(cone_sz),cone_sz = [21;21;31];end
n=n+1;
if nargin<n||isempty(disp),disp = 0;end

cone_vol = zeros(cone_sz(2),cone_sz(1),cone_sz(3));
theta = 0:0.05:2*pi;
h=cone_sz(3)-1;r=cone_sz(1)/2-1;u=1:cone_sz(3)-1;
inds=[];
for i=u
    for j = 0:1:r
        cone_locs = round([(h-i)/h*j*cos(theta);(h-i)/h*j*sin(theta);repmat(i,[1,length(theta)])])+repmat([ceil(cone_sz(2)/2);ceil(cone_sz(1)/2);0],[1,length(theta)]);
        inds = [inds,sub2ind(size(cone_vol),cone_locs(2,:),cone_locs(1,:), cone_locs(3,:))];
    end
end
cone_vol(inds)=1;
cone_vol(:,:,1) = 0;
cone = isosurface(cone_vol);
cone.vertices = cone.vertices - repmat([ceil(cone_sz(1)/2),ceil(cone_sz(2)/2),cone_sz(3)],[size(cone.vertices,1),1]);
cone.vertices = cone.vertices/max(abs(cone.vertices(:)));
if disp>0
    figure(disp)
    clf
    hold on
    axis equal
    patch(cone, 'FaceColor', [0,0,0], 'FaceAlpha', 0.2, 'EdgeColor', 'none');
end
end

function [R_rx] = R_x(theta_x)
% Testing rotational transfomation matricies (about x axis)

R_rx = [1,  0,              0;
        0,  cos(theta_x),   -sin(theta_x);
        0,  sin(theta_x),   cos(theta_x)];
end

function [R_ry] = R_y(theta_y)
% Testing rotational transfomation matricies (about y axis)

R_ry = [cos(theta_y),   0,  sin(theta_y);
        0,              1,  0;
        -sin(theta_y),  0,  cos(theta_y)];
end

function [R_rz] = R_z(theta_z)
% Testing rotational transfomation matricies (about z axis)

R_rz = [cos(theta_z),   -sin(theta_z),  0;
        sin(theta_z),   cos(theta_z),    0;
        0,              0,              1];
end