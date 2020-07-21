clear all;

lags = [0.6 0.6];
tspan = [0 5];
sol = dde23(@ddefun, lags, @history, tspan);

plot(sol.x, sol.y, '-o')
xlabel('Time t');
ylabel('Solution y');
legend('S', 'V', 'I', 'R', 'Location', 'NorthWest');

% y = [S, V, I, R]
function dydt = ddefun(t, y, Z) % equation being solved
    ylag1 = Z(:, 1);
    ylag2 = Z(:, 2);

    a = 0.1;
    f = 0.2;
    b = 0.3;
    h = 0.15;
    m = 0.25;

    dydt = [(a - f) * y(1) - b * y(1) * y(4);
            h * b * ylag1(1) * ylag2(2) - b * y(1) * y(4) - m * y(4);
            b * y(1) * y(4) - b * ylag1(1) * ylag2(2);
            a * y(2) + f * y(1)
           ];
endfunction    

function s = history(t) % history function for t <= 0
  s = ones(4, 1);
endfunction

