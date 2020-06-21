% Exercise 4

% 4.
P = [0 2 5 7 9 3; 7 7 8 7 5 7]
A = [-2*P(1,:)' -2*P(2,:)' ones(size(P,2),1)]
b = -P(1,:)'.^2-P(2,:)'.^2

% Solve the system
x1 = inv(A'*A)*A'*b
x2 = pinv(A)*b
x3 = A\b

% 5.
figure; clf;
plot(P(1,:),P(2,:),'g.','MarkerSize',20);
hold on
xc = x1(1)
yc = x1(2)
rc = sqrt(-x1(3)+xc^2+yc^2)
hold on;
plotcircle(xc,yc,rc,[1 0 0])
