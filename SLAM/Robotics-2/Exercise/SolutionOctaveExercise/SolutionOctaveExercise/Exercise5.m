% Exercise 5

% 1.
figure(2); clf; hold on;
rand('seed',2);

% 2.
x = 5*rand(3,10);
for i = 1:10
  drawreference([x(1,i);x(2,i);x(3,i)],'E',0.5,'k');
  drawprobellipse([x(1,i);x(2,i)],diag(0.02*rand(3,1)),0.95,'b');
end;

% 3.
drawtransform([1 5],[3 2.6],'\','',[0 0.5 0]);
drawrobot([2.95 2.4 -pi/2],'k');
axis equal; box on;

% 4.
print('-depsc','landmarkmap.eps');