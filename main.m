% gen noisy sig
[u, t] = gensig('square',3,10,.005);
A = [0.1 0.1; 0.05 0.1];
B = [0; 0.2];
H = [1 0;0 1];
x0 = [0;0];
[z1,z2,x1,x2] = gen_sig(A,B,H,x0,u,t);

fig = figure('visible','on');
plot(t,x1,t,x2,'linewidth',2);
hold on
plot(t,z1,'.');
plot(t,z2,'.');

% output error method
theta_true = [A B [x1(1); x2(1)]]; % true theta
theta0 = theta_true + 5;
% test on signal with no noise`
%theta_est = output_error(theta0,u(400),0.005,[x1(400); x2(400)],[x1(401); x2(401)])
% Try on signal with noise
x_combined = [x1; x2];
x_in = x_combined(:,300:450);
u_in = u(300:450);
z_combined = [z1; z2];
z_in = z_combined(:,300:450);

[theta_oem,cost_oem] = output_error(theta0,u_in,0.005,z_in);
theta_oem
theta_true
%cost_oem

A_oem = theta_oem(:,1:2);
B_oem = theta_oem(:,3);
H_oem = [1 0;0 1];%theta_oem(:,4:5);
x0_oem = theta_oem(:,4);
[z1o,z2o,x1o,x2o] = gen_sig(A_oem,B_oem,H_oem,x0_oem,u,t);
plot(t,x1o,'r--','linewidth',2);
plot(t,x2o,'b--','linewidth',2);
legend('x1', 'x2', 'z1','z2','x1_{OEM}','x2_{OEM}');

