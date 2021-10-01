function [z1, z2, x1, x2] = gen_sig(A,B,H,x0,u,t)
%A,B and H are 2 by 2 matrices
% u is input signal
% t is time signal
x = zeros(2,length(u));
z = zeros(2,length(u));
xdot = zeros(2,length(u));
dt = (t(2)-t(1)) ; % assuming equally spaced samples
x(:,1) = x0;
z(:,1) = H*x0;
for n=2:length(u)
    % State dynamics equation
    xdot(:,n-1) = A*x(:,n-1) + B*u(n-1);% + [normrnd(0,0.1); normrnd(0,0.1)];
    % Integration with adams-bashford
    if n==2
        x(:,n) = xdot(:,n-1)*dt + x(:,n-1);
    else
        x(:,n) = x(:,n-1) + (3/2.)*dt*xdot(:,n-1) - (1/2.)*dt*xdot(:,n-2);
    end
    % Measurement equation with noise
    z(:,n) = H*x(:,n) + [normrnd(0,0.1) ; normrnd(0,0.1)];
end
z1 = z(1,:);
z2 = z(2,:);
x1 = x(1,:);
x2 = x(2,:);
end
    


