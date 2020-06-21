% Exercise 3

% 1.
x = linspace(-4,4,100);
figure(1); clf;
plot(x,sin(x),x,cos(x),x,atan(x),x,x+0.3*x.^2-0.05*x.^3)

% 2.
title('function plots')
xlabel('x')
ylabel('y')
legend('sin','cos','atan','polynomial')
