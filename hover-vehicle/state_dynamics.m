function [xdot] = state_dynamics(x,u,theta)
% computes state dynamics given:
% x = current state vector
% u = current input vector
% theta = vector of system parameters = elements of A, B, H, initial condition of x
m = 4.5;
%pitch = deg2rad(10);
%phi = deg2rad(0);
pitch = -0.52664;
phi =  -0.026180;
B = [-1/m -1/m -1/m (cos(pitch)*cos(phi))];
A = theta(1);
xdot = A*x + B*u;
end

