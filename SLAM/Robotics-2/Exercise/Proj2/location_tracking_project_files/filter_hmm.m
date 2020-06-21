% performs kalman filtering on the hmm. See the function
% build_hmm.m for the structure of the input variable hmm

function hmm_filtered = filter_hmm(hmm)
  
  % set some parameters  
  C0 = diag([50 50 50 50]); % initial covariance
  Q = diag([0.001 0.001 0.1 0.1]); % process noise
  R = [100 0;0 100]; % measurement noise
  H = [1 0 0 0; 0 1 0 0]; % measurement matrix

  hmm_size = size(hmm,2);
  % TODO: initialize root node from first observation
  % hmm(1).x(1:2) = hmm(1).obs.z; etc...
  
  % loop through the rest of the hmm
  for i = 2:hmm_size
    % TODO: timestep to next node
    dt = hmm(i).date-hmm(i-1).date;
    % TODO: predict next hidden node
    [hmm(i).xp hmm(i).Cp] = predictstate(hmm(i-1).x,hmm(i-1).C,dt,Q);
    hmm(i).obs.zp = H*hmm(i).xp;
   
    % TODO: gating 
    
    % TODO: measurement correction (if gating successful)
  end
hmm_filtered = hmm;
end

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

end

function [x C] = updatestate(xp,Cp,z,zp,R,H)

% Compute innovation and innovation covariance
v = z - zp;
S = H*Cp*H' + R;

% Compute Kalman gain
K = Cp*H'*inv(S);

% Update state and state covariance
x = xp + K*v;
C = Cp - K*H*Cp;
end


