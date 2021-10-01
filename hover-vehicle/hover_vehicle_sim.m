clear all;
rho = 1.225;
S = 1;
m = 4.5;
Cd = 0.6;
pitch = deg2rad(10);
phi = deg2rad(0);
V0 = -1.35;
g = 9.81;

A = -rho*S*Cd*norm(V0)/(2*m);
B = [-1/m -1/m -1/m (cos(pitch)*cos(phi))];
H = 1;
x0 = 0;

% simulation
ddt = 0.01; end_time = 10;
t_ = linspace(0,end_time,end_time/ddt);
x_ = zeros(1, length(t_)); x_(1) = V0;
z_ = zeros(1, length(t_)); z_(1) = V0;
u_ = zeros(4,length(t_));
A_ = zeros(1, length(t_));
x_validate = x_;

% generate the data
for i=2:length(t_)
    A = -rho*S*Cd*norm(x_(:,i-1))/(2*m);
    A_(i) = A;
    u_(:,i-1) = [m*g/3; m*g/3; m*g/3; g];
    xdot = A*x_(:,i-1) + B*u_(:,i-1);
    x_(:,i) = x_(:,i-1) + xdot*ddt;
    z_(:,i) = x_(:,i) + 0.003*randn(1);
end

fig = figure('visible','on');
plot(t_,z_,'linewidth',2,':');
hold on

%% output error method
theta_true = [A x_(1)]; % true theta
theta0 = theta_true + 0.7;
[theta_oem,cost_oem] = output_error(theta0,u_(:,800:1000),0.01,z_(800:1000));
theta_oem
theta_true

x_validate(1) = theta_oem(2);
A_validate = theta_oem(1);

%x_validate(1) = theta_true(2);
%A_validate = theta_true(1)
for i=2:length(t_)
    xdot = state_dynamics(x_validate(:,i-1),u_(:,i-1),theta_oem);
    x_validate(:,i) = x_validate(:,i-1) + xdot*ddt;
end

plot(t_,x_validate,'linewidth',2,'k-');
legend('training','validation');
%axis([0 end_time -2 0])

figure()
plot(t_,A_);
legend('A');

drag = Cd
drag_estimate = A_validate*2*m/(-rho*S*norm(V0))
