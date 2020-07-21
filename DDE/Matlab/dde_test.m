clear all;

% delays for [y1, y2, y3]
lags = [1 0.2 0]; % row array: [1, 2, 3]

t0 = 0;
tf = 5;
tspan = [t0 tf];
sol = dde23(@ddefun, lags, @history, tspan);


%sol {.x = [...], .y = [...]}

% sol.x: 0:0.01:5 -> 0, .01, .02, .03,...,5 (100 X 1)
% sol.y: (100 x 3)

plot(sol.x, sol.y, '-o')
xlabel('Time t');
ylabel('Solution y');
legend('y_1', 'y_2', 'y_3', 'Location', 'NorthWest');

% y = [y1, y2, y3]
% y1 = y(1)
% y2 = y(2)
function dydt = ddefun(t, y, Z) % equation being solved
  ylag1 = Z(:, 1);
  ylag2 = Z(:, 2);

  dydt = [ylag1(1); 
          ylag1(1) + ylag2(2); 
          y(2)];
end

function s = history(t)
  dim = 3; % state dimension
  s = ones(dim,1); % column array
end


