function [xdot] = state_dynamics(x,u,theta)
% computes state dynamics given:
% x = current state vector
% u = current input vector
% theta = vector of system parameters = elements of A, B, H, initial condition of x

A = theta(:,1:2);
B = theta(:,3);
H = [1 0;0 1];%theta(:,4:5);
x0 = theta(:,4);

xdot = A*x + B*u;
end

