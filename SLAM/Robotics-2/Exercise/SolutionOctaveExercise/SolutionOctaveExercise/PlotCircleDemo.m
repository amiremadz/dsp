% Exercise 4

% 3.
figure;
hold on;
for i = 1:100,
  
  x = rand*10-5;
  y = rand*10-5;
  r = rand*5;
  col = rand(3,1);
  plotcircle(x,y,r,col)

end;
