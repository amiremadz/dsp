% Robotics II Class WS11/12
% Exercise 'People Detection and Tracking', Part II
% v.1.0, Jan 2012, Kai Arras, SRL Freiburg

clear all; clc;

C0 = diag([0.01 0.01 0.1 0.1]);
Q = diag([0.001 0.001 0.1 0.1]);
H = [1 0 0 0; 0 1 0 0];
ALPHA = 0.99;


%% --------------------------------------------------------------------- %
% Exercise 11: Getting Started, Read From Data Set
% ---------------------------------------------------------------------- %

% Read in log file
if exist('dataobs3.mat','file'),
  load('dataobs3');
else
  disp('Error: data set file not found!');
  break;
end;

% Plot all tracks
figure(1); clf; hold on; box on; axis equal;
for i = 1:length(obsdata),
  x = obsdata(i).z(1,obsdata(i).zvalid);
  y = obsdata(i).z(2,obsdata(i).zvalid);
  plot(x,y,'<-','MarkerSize',12,'Color',obsdata(i).color);
end;
    

%% --------------------------------------------------------------------- %
% Exercise 12: Main loop
% ---------------------------------------------------------------------- %

tracks = struct([]);
ntracks = 0;
for istep = 1:length(obsdata(1).z),
 
  % Get valid observations at current step
  obs = struct([]);
  nobs = 0;
  for i = 1:length(obsdata),
    if obsdata(i).zvalid(istep),
      nobs = nobs + 1;
      obs(nobs).id = obsdata(i).id;
      obs(nobs).z  = obsdata(i).z(:,istep);
      obs(nobs).R  = obsdata(i).R;
      obs(nobs).status = 'non-matched';
    end;
  end;
  
  % Predict all states and measurements
  for i = 1:ntracks,
    [xp Cp] = predictstate(tracks(i).x,tracks(i).C,dt,Q);
    tracks(i).xp = xp;
    tracks(i).Cp = Cp;
    tracks(i).zp = H*xp;
    tracks(i).H  = H;
    tracks(i).status = 'non-matched';
  end;
  
  % Associate observations with tracks
  if (ntracks > 0) && (nobs > 0),
    [tracks,obs] = matchnnsf(tracks,obs,ALPHA);
  end;

  % Update tracks 
  for i = 1:ntracks,
    if strcmp(tracks(i).status,'matched'),
      xp = tracks(i).xp;
      Cp = tracks(i).Cp;
      z  = tracks(i).z;
      zp = tracks(i).zp;
      R  = tracks(i).R;
      [x C] = updatestate(xp,Cp,z,zp,R,H);
      tracks(i).x = x;
      tracks(i).C = C;
    else
      tracks(i).x = tracks(i).xp;
      tracks(i).C = tracks(i).Cp;
    end;
  end;

  % Initialize new tracks with non-matched observations
  for i = 1:nobs,
    if strcmp(obs(i).status,'non-matched'),
      ntracks = ntracks + 1;
      tracks(ntracks).id = ntracks;
      tracks(ntracks).x = [obs(i).z; 0; 0];
      tracks(ntracks).C = C0;
      tracks(ntracks).xhist  = [];
      tracks(ntracks).Chist  = [];
      tracks(ntracks).xphist = [];
      tracks(ntracks).Cphist = [];
      tracks(ntracks).iobs = i;
      tracks(ntracks).status = 'created';
    end;
  end;
  
  % Update track histories
  for i = 1:ntracks,
    tracks(i).xhist = cat(2,tracks(i).xhist,tracks(i).x);
    tracks(i).Chist = cat(3,tracks(i).Chist,tracks(i).C);
    if ~strcmp(tracks(i).status,'created'),
      tracks(i).xphist = cat(2,tracks(i).xphist,tracks(i).xp);
      tracks(i).Cphist = cat(3,tracks(i).Cphist,tracks(i).Cp);
    end;
  end;
  
end;



%% Plot histories

for i = 1:ntracks,
  % Generate a track color
  color = [.5 i/ntracks 0];
  % Plot state histories
  plot(tracks(i).xhist(1,:),tracks(i).xhist(2,:),'.-','MarkerSize',16,'Color',color);
  plot(tracks(i).xphist(1,:),tracks(i).xphist(2,:),'+','Color',[.7 .7 .7]);  
  % Plot state covariances
  drawprobellipse(tracks(i).xhist(1:2,1),tracks(i).Chist(1:2,1:2,1),0.95,color);
  for j = 1:size(tracks(i).xphist,2),
    %drawprobellipse(tracks(i).xhist(1:2,j),tracks(i).Chist(1:2,1:2,j),0.95,color);
    %drawprobellipse(tracks(i).xphist(1:2,j),tracks(i).Cphist(1:2,1:2,j),0.95,[.7 .7 .7]);
    % Plot line to visualize state prediction 
    x1 = tracks(i).xhist(1:2,j);
    x2 = tracks(i).xphist(1:2,j);
    plot([x1(1) x2(1)],[x1(2) x2(2)],'-','Color',[.7 .7 .7]);
  end;
end;

