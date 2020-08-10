clear all;

% Part 1) Solve DDEs with dde23 and initial condition guesses for h and
% lagsk,and set values for f, b, m, and a
lagsk = [0.4314]; % First guess for constant lag K in equations for S and V # [s]
tspan = [0 20]; %Timespan over which solve DDEs # [hours]
sol = dde23(@ddefun, lagsk, @hist, tspan); %Solves system of ddes by calling ddefun2

figure(1)
plot(sol.x, log10(sol.y), '-.') %Plots solutions
xlabel('Time (H)');
ylabel('Solutions [log C(P)FU/mL]');
legend('S', 'V', 'I', 'R', 'Location', 'NorthWest');
title('DDE Solutions')
ylim([0 10])

% Name the S and R Solutions (Eqn 1 and 4)
S = log10(sol.y(1, :));
R = log10(sol.y(4, :));

% Graph S and R in the same window to see their intersection
figure(2)
plot(sol.x, S, 'b')
hold on
plot(sol.x, R, 'r')
grid on
title('Finding Intersections of Functions')
xlabel('Input Values (x)')
ylabel('Ouput Values (f)')

%Part 2) Create and Plot combinedSR (Line shown in paper representing any CFUs w/o regard to Resistance)
indx = intersect(S, R);
combined = [S(1 : indx), R(indx + 1 : end)];

S_first = S(1:indx);
m = max(S_first);
idx_m = find(S_first == m);

%Matlab:
%v = [1, 2, 3, 4]
%v(1:3)->1,2,3

%Python:
%v[0:3]


figure(3)
plot(sol.x, combined, '-.')
title('ALL CFUS (RESISTANT AND NON)')
xlabel('Time (H)')
ylabel('log10CFU/mL')

%Part 3) Curve-Fitting
%Ignore lines 36-44 :)
%xdata = [2 4 6 8 10 12 13 14 16 18 20];
%ydata = [5 5.5 6.1 6.9 7.7 8.2 7.5 5 5.5 6.6 7.8];
%x = lsqcurvefit(fun,x0,xdata,ydata)
%B0 = [a lagsk];
%[a_output lagk_output] = lsqcurvefit(@combinedSR,B0,xdata,ydata);
%combinedSRout = f(S, R, sol);
%cftool
%xfitting is the input x data, and combinedSRout is the input y data
%xfitting = sol.x;
% FITTING ISSUES HERE, getting line 42 error "Not enough input arguments."

ft = fittype( 'PiecewiseFunc( x, bb, gg, a, b, c, d)' )
result = fit(sol.x, combined, ft);

function y = PiecewiseFunc(x, bb, gg, a, b, c, d)
    global indx;
    y = zeros(length(x));
    for i = 1:length(x)
        if x(i) > indx
            y(i) = base + growth * x(i);
        else 
            y(i) = d + a * exp(-b * exp(-c * x(i)));
        end
    end
endfunction

function dy = ddefun(t, y, Z)
    ylag = Z(:,1);
    dy = zeros(4,1); %create v, 4 x 1 matrix equation
    a = 0.8608;      %Various constants defined here
    f = 10 ^ -4.940;
    b = 10 ^ -5.931;
    h = 1.624;
    m = 0.00095;
    dy = [ (a - f) * y(1) - b * y(1) * y(2);                         % S
            h * b * ylag(1) * ylag(2) - b * y(1) * y(2) - m * y(2);  % V
            b * y(1) * y(2) - b * ylag(1) * ylag(2);                 % I
            a * y(4) + f * y(1)                                      % R
         ];
endfunction

function y = hist(t)                    %history function for times t<0
    y = [10 ^ 4.906; 10 ^ 4.627; 0; 0]; %Initial conditions from document
endfunction

function indx = intersect(S, R)
    % Find the x-coordinates of intersecting points in order to make combinedSR
    diff = abs(S - R);
    indx = find(diff < 0.05);
endfunction

