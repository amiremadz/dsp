clear all;

lags = [0.4314];
tspan = [0 25];
sol = dde23(@ddefun, lags, @history, tspan);

figure
plot(sol.x, log10(sol.y), '-')
xlabel('Time t');
ylabel('Solution y');
legend('S', 'V', 'I', 'R', 'Location', 'SouthEast');

% y = [S, v, I, R]
function dydt = ddefun(t, y, Z) % equation being solved
    ylag = Z(:, 1); 

    a = 0.8608;
    f = 10 ^ -4.940;
    b = 10 ^ -5.931;
    h = 1.624;
    m = 0.00095;

    dydt = [(a - f) * y(1) - b * y(1) * y(2);                         % S
            h * b * ylag(1) * ylag(2) - b * y(1) * y(2) - m * y(2);   % V
            b * y(1) * y(2) - b * ylag(1) * ylag(2);                  % I
            a * y(4) + f * y(1)                                       % R
           ];
endfunction    

function s = history(t) % history function for t <= 0
  s = [10 ^ 4.906; 10 ^ 4.627; 0; 0];
endfunction

