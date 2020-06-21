% Robotics II Class WS11/12
% Exercise 'People Detection and Tracking', Part II
% v.1.0, Jan 2012, Kai Arras, SRL Freiburg

clear all; clc;

C0 = diag([0.1 0.1 0.1 0.1]);
Q = diag([0.001 0.001 0.1 0.1]);
ALPHA = 0.99;


%% --------------------------------------------------------------------- %
% Exercise 5: Getting Started, Read From Data Set
% ---------------------------------------------------------------------- %

% Read in log file
if exist('datatracks.mat','file'),
  load('datatracks');
else
  disp('Error: data set file not found!');
  break;
end;

% Assign observation sequence and observation cov matrix
Z = z2;
zvalid = zvalid2;
R = R2;

% Plot both tracks
figure(1); clf; hold on; box on; axis equal;
plot(Z(1,zvalid),Z(2,zvalid),'d','MarkerSize',10,'Color',[1 .5 0]);
for i = 1:size(Z,2),
  if zvalid(i),
    drawprobellipse(Z(:,i),R,0.95,[1 0 .5]);
  end;
end;


%% Main loop

initialized = false;
xhist  = []; Chist  = [];
xphist = []; Cphist = [];
size(Z,2)
for istep = 1:size(Z,2),
 
  % Exercise 6: State Representation and Initialization
  if ~initialized && zvalid(istep),
    x = [Z(:,istep); 0; 0];
    C = C0;
    initialized = true;
  end;

  if initialized,
    % Exercise 7: Motion Model
    [xp Cp] = predictstate(x,C,dt,Q);

    if zvalid(istep),
      % Make observation
      z = Z(:,istep);

      % Exercise 8: Measurement Model
      H = [1 0 0 0; 0 1 0 0];
      zp = H*xp;

      % Exercise 10: Gating
      v = z - zp;
      S = H*Cp*H' + R;
      d = v'*inv(S)*v;
      if d < chi2invtable(ALPHA,2),

        % Exercise 9: Kalman filter
        [x C] = updatestate(xp,Cp,z,zp,R,H);
      else
        % Observation incompatible, no match
        x = xp; C = Cp;
      end;
    else
      % No observation, no match
      x = xp; C = Cp;
    end;

    % Store state histories
    xhist = cat(2,xhist,x); Chist = cat(3,Chist,C);
    xphist = cat(2,xphist,xp); Cphist = cat(3,Cphist,Cp);
  end;
end;



%% Plot histories
plot(xhist(1,:),xhist(2,:),'.-','MarkerSize',16,'Color','b');
plot(xphist(1,:),xphist(2,:),'+','Color',[.7 .7 1]);
for i = 2:size(xhist,2),
  drawprobellipse(xhist(1:2,i),Chist(1:2,1:2,i),0.95,'b');
  drawprobellipse(xphist(1:2,i),Cphist(1:2,1:2,i),0.95,[.7 .7 1]);
  x1 = xhist(1:2,i-1);
  x2 = xphist(1:2,i);
  plot([x1(1) x2(1)],[x1(2) x2(2)],'-','Color',[.7 .7 .7]);
end;


% Plot histories against time
figure(2); clf;

% Plot x and y
subplot(3,1,1); cla; box on; grid on;
tvec = 1:size(xhist,2);
plot(tvec,xhist(1,:),'.-',tvec,xhist(2,:),'.-');
legend('x','y'); axis tight; 

% Plot vx and vy
subplot(3,1,2); cla; box on; grid on;
vvec = sqrt(sum(xhist(3:4,:).^2));
plot(tvec,xhist(3,:),tvec,xhist(4,:),tvec,vvec,'-');
legend('vx','vy','v'); axis tight;

% Plot variances in vx, vy
subplot(3,1,3); cla; box on; grid on;
sx = squeeze(Chist(1,1,:));
sy = squeeze(Chist(2,2,:));
svx = squeeze(Chist(3,3,:));
svy = squeeze(Chist(4,4,:));
plot(tvec,sx,'+-',tvec,sy,'d-',tvec,svx,'x-',tvec,svy,'^-');
legend('var x','var y','var vx','var vy'); axis tight;

