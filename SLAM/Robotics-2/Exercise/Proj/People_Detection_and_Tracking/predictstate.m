% Kalman state predition with constant direction and constant velocity
% State is assumed to be (x y vx vy)

function [xp Cp] = predictstate(x,C,dt,Q)

% Calculate prediction
F = eye(4);
F(1,3) = dt;
F(2,4) = dt;
xp = F*x;

% Propagate error
Cp = F*C*F' + Q;
