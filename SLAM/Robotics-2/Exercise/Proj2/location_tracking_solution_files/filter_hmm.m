% performs kalman filtering on the hmm. See the function
% build_hmm.m for the structure of the input variable hmm

function hmm = filter_hmm(hmm,map)
  %pre-filter map to make get_nearest_edge faster
  z = zeros(2,size(hmm,2));
  for i = 1:size(hmm,2)    
    z(:,i) = hmm(i).obs.z;
  end
  % get max values
  R1 = [min(z(1,:)) min(z(2,:))];
  R2 = [max(z(1,:)) max(z(2,:))];
  map = filter_map(map,R1,R2);
  
  % set some parameters  
  C0 = diag([500 500 500 500]); % initial covariance
  Q = diag([10 10 1 1]); % process noise
  R = [500 0;0 500]; % measurement noise
  H = [1 0 0 0; 0 1 0 0]; % measurement matrix

  hmm_size = size(hmm,2);
  % initialize root node from first observation
  hmm(1).x(1:2) = hmm(1).obs.z;
  hmm(1).x(3:4) = [0;0];
  hmm(1).x = hmm(1).x';
  hmm(1).C = C0;

  % loop through the rest of the hmm
  for i = 2:hmm_size
    % timestep to next node
    dt = hmm(i).date-hmm(i-1).date;
    % predict next hidden node
    [hmm(i).xp hmm(i).Cp] = predictstate(hmm(i-1).x,hmm(i-1).C,dt,Q);
    hmm(i).obs.zp = H*hmm(i).xp;
   
    % gating
    v = hmm(i).obs.z - hmm(i).obs.zp;
    S = H*hmm(i).Cp*H' + R;
    d = v'*inv(S)*v;
    
    if d < chi2invtable(0.99,2)
      % measurement correction
      [hmm(i).x hmm(i).C] = updatestate(hmm(i).xp,hmm(i).Cp,hmm(i).obs.z,hmm(i).obs.zp,R,H);
      [N e] = get_nearest_edge(map,hmm(i).x(1:2));
      hmm(i).x(1:2) = N;
      hmm(i).edge = e;
    else
      % set state to predicted state
      hmm(i).x = hmm(i).xp;
      hmm(i).C = hmm(i).Cp;
      printf('gating failed at node %d, v: (%f,%f), d: %f\n', i,v(1:2),d);
    end
  end
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


