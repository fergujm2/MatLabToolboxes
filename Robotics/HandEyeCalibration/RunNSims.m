clear;

N = 100;

te = zeros(1, N);
re = te;

for iii = 1:N
    [te(iii), re(iii)] = SimCalibrateHandeye();
end

%% Plotting

h = figure(1);
subplot(1, 2, 1);
histogram(te);
title('Translation Error');
xlabel('Translation Error (mm)');

subplot(1, 2, 2);
histogram(re);
title('Rotation Error');
xlabel('Rotation Error (deg)');