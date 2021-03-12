function state = PackRodState(p, R, n, u)

state = [p; R(:,1); R(:,2); R(:,3); n; u];

end