%  Blsq0d
% SplinePAK: Copyright Larry Schumaker 2014
%  Compute the least-squares fit of data sampled from a test function 
%     using a C0 spline of degree d 

% Read in a triangulation
[n,x,y,nt,TRI] = readtri;
[nb,ne,nt,v1,v2,v3,e1,e2,e3,ie1,ie2,tril,trir,bdy,...
   vadj,eadj,adjstart,tadj,tstart,area,TRI] = trilists(x,y,TRI);

% Input data points
[nd,xd,yd] = readxy; 

% Sample the test function and set the weights
f = @(x,y) franke2(x,y);
zd = franke2(xd,yd);  wd = ones(nd,1);

% Plot the triangulation and data points
figure; hold; axis equal; axis off;
h = triplot(TRI,x,y); set(h,'LineWidth',2.5);
plot(xd,yd,'LineStyle','none','LineWidth',4,'Marker','.',...
  'MarkerFaceColor','g', 'MarkerEdgeColor','k',  'MarkerSize',20)

d = input('input the degree of the spline  d =  '); 

% Compute the coefficients of the lsq spline fit from S^0_d
t1 = cputime;
[c,G] = lsq0d(d,x,y,v1,v2,v3,e1,e2,e3,ie1,nd,xd,yd,zd,wd);
t2 = cputime - t1;
fprintf('computational time  is %g\n ',t2);
fprintf('condition number of G is %g\n ',cond(full(G)));

% Evaluate the spline on a grid
ng = 51; xmin = min(x); xmax = max(x); ymin = min(y); ymax = max(y);
[xg,yg,g] = valspgrid(d,x,y,v1,v2,v3,e1,e2,e3,ie1,c,ng,xmin,xmax,ymin,ymax);

% Plot the spline
figure; surfl(xg,yg,g');  colormap(copper); 

% Compute the max and RMS errors on the grid
e = errg(xg,yg,g,f);
fprintf('emax =%5.2e, RMS = %5.2e\n',norm(e,inf),erms(e));

% Plot the x-derivative
u = [1,0];
[xg,yg,g] = valspdergrid(d,x,y,v1,v2,v3,e1,e2,e3,ie1,c,ng,u,...
    xmin,xmax,ymin,ymax);
figure; surfl(xg,yg,g');  colormap(copper);

% Calculate the error of the x-derivative
eder = errgder(xg,yg,g,@franke2d,2);
fprintf('Derivative: emax =%5.2e, RMS = %5.2e\n',norm(eder,inf),erms(eder));
