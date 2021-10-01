function [y] = compute_response(x,u,theta)
% computes response y based on:
% x = current state
% u = current input
% theta = parameter vector A, B, H and x0

A = theta(:,1:2);
B = theta(:,3);
H = [1 0;0 1];%theta(:,4:5);
x0 = theta(:,4);

y = H*x;
end


