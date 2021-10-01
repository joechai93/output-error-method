clear all;

raw_data = csvread('test_system_id_log.csv');

w = raw_data(:,4);
phi = raw_data(:,8);
theta = raw_data(:,9);
Tl = raw_data(:,58);
Tr = raw_data(:,59);
Tt = raw_data(:,60);
g = 9.81 * ones(1,length(w));
u_ = [Tl';
      Tr'; 
      Tt';
      g];

theta_const = theta(4000);
phi_const = 0;

fig = figure('visible','on');
subplot(3,1,1);
plot(rad2deg(theta),'linewidth',2,':');
hold on
plot(rad2deg(phi),'linewidth',2,':');
legend('theta','phi');
subplot(3,1,2);
plot(w,'linewidth',2,':');
legend('w');
subplot(3,1,3);
plot(Tl,'linewidth',2,':');
hold on
plot(Tr,'linewidth',2,':');
plot(Tt,'linewidth',2,':');
legend('Tl','Tr','Tt');

%
rho = 1.225;
S = 1;
m = 4.5;
Cd = 1;
V0 = -2.6;
g = 9.81;

A = -rho*S*Cd*norm(V0)/(2*m);
%% output error method
theta0 = [A -2.45]; % guess theta
[theta_oem,cost_oem] = output_error(theta0,u_(:,5000:5500),0.01,w(5000:5500)');
theta_oem

ddt = 0.01; end_time = 5;
t_ = linspace(0,end_time,end_time/ddt);
x_validate = zeros(1, length(t_));

x_validate(1) = theta_oem(2);
A_validate = theta_oem(1);
%

for i=2:length(t_)
    xdot = state_dynamics(x_validate(:,i-1),u_(:,5000+i-1),theta_oem);
    x_validate(:,i) = x_validate(:,i-1) + xdot*ddt;
end

figure()
subplot(2,1,1);
plot(w(5000:5500));
hold on
plot(x_validate,'k-');
legend('training','validation');
subplot(2,1,2);
plot(u_(1,5000:5500));
hold on;
plot(u_(2,5000:5500));
plot(u_(3,5000:5500));

% this drag coeff is what is used in the xplane simulation
drag_estimate = -A_validate*m/norm(V0) %A_validate*2*m/(-rho*S*norm(V0))
