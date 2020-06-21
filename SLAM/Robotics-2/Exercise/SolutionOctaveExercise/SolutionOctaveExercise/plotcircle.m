% Exercise 4
% 1.
  
function plotcircle(x,y,r,col)

  angle = linspace(0,2*pi,100);
  X = x + r*sin(angle);
  Y = y + r*cos(angle);
  plot(X,Y,'color',col);
  
end

