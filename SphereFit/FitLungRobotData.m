%% Get the data from a script and it it to a circle

[X, Y, Z] = GetLungRobotData();

[center, normal, r] = CircleFit(X, Y, Z);

%% Plot the original data

h = figure(1);
clf;
h.Color = [1,1,1];
hold on;

scatter3(X, Y, Z, 10, 'Filled');

%% Plot Fitted Circle

% First draw a circle on the x-y plane at the origin with the correct radius
s = linspace(0, 2*pi, 10000);
x = r*cos(s);
y = r*sin(s);
z = zeros(1, length(s));

% Now figure out the correct rotation matrix for the circle based on the 
% normal and the center
ez = [0;0;1];
ax = cross(ez, normal);

if all(ax == 0)
    ax = ez;
end

ax = ax./norm(ax);
ang = atan2(norm(cross(ez,normal)),dot(ez,normal));
R = axang2rotm([ax', ang]);

% Now rotate and translate the points based on center and R
pts = (hom2cart((rotm2tform(R)*((cart2hom([x',y',z']))'))'))' + center*ones(1,length(s));

plot3(pts(1,:),pts(2,:),pts(3,:));

daspect([1,1,1]);
axis equal;
grid on;