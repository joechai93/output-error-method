function [thetaf,cost] = output_error(theta0,u,dt,z)
% output_error iterative solver for an arbitrary number of discrete points in time
% u = scalar of control input at time k to n
% x = vector of state at time k to n 
% z = vector of measured state at time k+1 to n+1

A= theta0(:,1:2);
B = theta0(:,3);
%H = theta0(:,4:5);
x0 = theta0(:,4);
iter = 0;
length_x=length(z);
R = [0.1^2 0;0 0.1^2];
while iter < 100
    xdot = zeros(2,length_x);
    xn = zeros(2,length_x);
    y = zeros(2,length_x);
    err = zeros(2,length_x);
    xn(:,1) = theta0(:,4); 
    Jsum = 0;

    for i = 1:length_x
        xdot(:,i) = state_dynamics(xn(:,i),u(i),theta0);
        xn(:,i+1) = xdot(:,i)*dt + xn(:,i);
        y(:,i) = compute_response(xn(:,i),u(i),theta0);
        err(:,i) = z(:,i) - y(:,i);
        Jsum = Jsum + transpose(err(:,i))*inv(R)*err(:,i);
    end
    cost = abs((1./2)*(Jsum)  + (1./2)*log(det(R)));
    dtheta = 10^(-4);
    
    xdotp = zeros(2,length_x);
    xnp = zeros(2,length_x);
    yp = zeros(2,length_x);
    dy_dtheta = zeros(2,length_x);
    dJ = 0.0;
    d2J = 0.0;
    if cost > 1
        thetap = theta0 + dtheta;
        xnp(:,1) = thetap(:,4);
        for i = 1:length_x
            xdotp(:,i) = state_dynamics(xnp(:,i),u(i),thetap);
            xnp(:,i+1) = xdotp(:,i)*dt + xnp(:,i);
            yp(:,i) = compute_response(xnp(:,i),u(i),thetap);
            dy_dtheta(:,i) = (yp(:,i)-y(:,i))/dtheta;
            dJ = dJ + transpose(dy_dtheta(:,i))*inv(R)*err(:,i);
            d2J = d2J + transpose(dy_dtheta(:,i))*inv(R)*dy_dtheta(:,i);
        end
    end
    theta0 = theta0 + d2J\dJ;
    iter = iter+ 1;
    %else 
    %    break
    end
thetaf = theta0;
end
