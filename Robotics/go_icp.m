function [R,t,time] = go_icp(model,data,plot_results)
% assume model is 3xn

t0_M = mean(model,2);
t0_D = mean(data ,2);

model = model - t0_M;
data  = data  - t0_D;

norms = [sum(model.^2,1),sum(data.^2,1)];
scale = sqrt(max(norms));

model = model/scale;
data  =  data/scale;

Nm = size(model,2);
Nd = size(data ,2);

%build .txt files out of model and data

fn_M = fullfile(pwd,'model.txt');

fileID_M = fopen(fn_M,'w');
fprintf(fileID_M,'%d\n',Nm);
fprintf(fileID_M,'%2.20f %0.20f %0.20f\n',model);
fclose(fileID_M);

fn_D = fullfile(pwd,'data.txt');

fileID_D = fopen(fn_D ,'w');
fprintf(fileID_D,'%d\n',Nd);
fprintf(fileID_D,'%0.20f %0.20f %0.20f\n',data);
fclose(fileID_D);

binary = '"C:\Libraries\C++\GoICP_V1.3 - A\bin\Debug\GoICP.exe"';
config = '"C:\Libraries\C++\GoICP_V1.3 - A\demo\config_JMF.txt"';
out    = fullfile(pwd,'output.txt');

file = fopen(out,'w'); fclose(file);

% fn_M = ['"' fn_M '"'];
% fn_D = ['"' fn_D '"'];
% out  = ['"' out  '"'];

cmd = [binary ' ' 'model.txt' ' ' 'data.txt' ' ' num2str(Nd) ' ' 'config_JMF.txt' ' ' 'output.txt'];

system(cmd);

file = fopen('output.txt', 'r');
time = fscanf(file, '%f', 1);
R = fscanf(file, '%f', [3,3])';
t = fscanf(file, '%f', [3,1]);
fclose(file);

t = t*scale;
model = model*scale;
data  = data *scale;

if(plot_results)
    figure;
    subplot(1,2,1);
    plot3(model(1,:), model(2,:), model(3,:), '.r');
    hold on;
    plot3(data(1,:),  data(2,:),  data(3,:), '.b');
    hold off; axis equal; title('Initial Pose');
    subplot(1,2,2);
    data_ = bsxfun(@plus, R*data, t);
    plot3(model(1,:), model(2,:), model(3,:), '.r');
    hold on;
    plot3(data_(1,:), data_(2,:), data_(3,:), '.b');
    hold off; axis equal;  title('Result');
end

botRow = [0 0 0 1];

Tr_t0D = [eye(3), -t0_D; botRow];
Tr_t0M = [eye(3),  t0_M; botRow];

Tr_R  = [R, [0;0;0]; botRow];
Tr_t  = [eye(3), t ; botRow];

Tr = Tr_t0M*Tr_t*Tr_R*Tr_t0D;

R = Tr(1:3,1:3);
t = Tr(1:3, 4);

end
