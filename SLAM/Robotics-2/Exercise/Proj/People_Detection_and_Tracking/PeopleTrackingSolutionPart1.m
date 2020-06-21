% Robotics II Class WS11/12
% Exercise 'People Detection and Tracking'
% v.1.0, Dec 2011, Kai Arras, SRL Freiburg

clear all; close all; clc;

ANIMATE = 1;
AXVEC = [-25 20 -0.5 26];


%% --------------------------------------------------------------------- %
% Exercise 1: Getting Started, Read From Data Set
% ---------------------------------------------------------------------- %

% Read in log file
if exist('datalog.mat','file'),
  load('datalog','log');
  nsteps = length(log.step);
  nbeams = length(log.phi);
else
  disp('Error: data set not found!');
  break;
end;

% Plot or animate
figure(1); clf; box on; hold on;
axis equal; axis(AXVEC);
if 0,%ANIMATE,
  for i = 1:nsteps,
    [x y] = pol2cart(log.phi,log.step(i).rho);
    hplot = plot(x,y,'d','MarkerSize',8);
    title(['Freiburg main station data set, step = ',int2str(i)]);
    drawnow;
    delete(hplot);
  end;
else
  [x y] = pol2cart(log.phi,log.step(1).rho);
  plot(x,y,'d','MarkerSize',8);
  title('Freiburg main station data set');
end;


%% --------------------------------------------------------------------- %
% Exercise 2: Segmentation
% ---------------------------------------------------------------------- %
THRESH = 0.35;

phi = log.phi;
rho = log.step(1).rho;
[x y] = pol2cart(phi,rho);

% Find break points in scan
rhodiff = diff(rho);
ifdiff = (abs(rhodiff) > THRESH);
ibreaks = find(ifdiff);

% Determine segment start and end indices, pad with first and last index 
isegs = sort([1 ibreaks ibreaks+1 nbeams]);

j = 0;
for i = 1:2:length(isegs),
  j = j + 1;
  segments(j).id = i;
  segments(j).is = isegs(i);
  segments(j).ie = isegs(i+1);
  segments(j).col = rand(3,1);
  ivec = segments(j).is:segments(j).ie;
  segments(j).P = [x(ivec); y(ivec)];
  segments(j).xm = mean(segments(j).P,2);
end;
nsegs = j;

% Plot
figure(2); clf; box on; hold on;
axis equal; axis(AXVEC);
title('Segmented scan');
for i = 1:nsegs,
  plot(segments(i).P(1,:),segments(i).P(2,:),'d','MarkerSize',8,'Color',segments(i).col);
  plot(segments(i).xm(1),segments(i).xm(2),'kx','MarkerSize',8);
  text(segments(i).xm(1)+0.1,segments(i).xm(2)+0.1,int2str(segments(i).id));
end;


%% --------------------------------------------------------------------- %
% Exercise 3: Detection by Classification
% ---------------------------------------------------------------------- %

% Compute features for each segment
for i = 1:nsegs,
  P = segments(i).P;
  n = size(P,2);
  segments(i).npoints = n;
  segments(i).width = norm([P(1,1)-P(1,n); P(2,1)-P(2,n)]);
end;

% Classify each segment
for i = 1:nsegs,
  n = segments(i).npoints;
  w = segments(i).width;
  cond = (n > 3) && (w < 0.8) && (w > 0.1);
  if cond,
    segments(i).class = 1;
  else
    segments(i).class = 0;
    segments(i).col = [0 0 0];
  end;
end;

% Plot
figure(3); clf; box on; hold on;
axis equal; axis(AXVEC);
title('Classified segments');
for i = 1:nsegs,
  plot(segments(i).P(1,:),segments(i).P(2,:),'d','MarkerSize',8,'Color',segments(i).col);
  if segments(i).class,
    plot(segments(i).xm(1),segments(i).xm(2),'kx','MarkerSize',8);
    text(segments(i).xm(1)+0.1,segments(i).xm(2)+0.1,int2str(segments(i).id));
  end;
end;


% Animate Detection Results
% ---------------------------------------------------------------------- %
% We simply repeat the code from above

if ANIMATE,
  figure(4); clf; box on; hold on;
  axis equal; axis(AXVEC);
  for istep = 1:nsteps,
  
    phi = log.phi;
    rho = log.step(istep).rho;
    [x y] = pol2cart(phi,rho);
    
    % Find break points in scan
    rhodiff = diff(rho);
    ifdiff = (abs(rhodiff) > THRESH);
    ibreaks = find(ifdiff);
    
    % Determine segment start and end indices, pad with first and last index 
    isegs = sort([1 ibreaks ibreaks+1 nbeams]);
    
    j = 0;
    for i = 1:2:length(isegs),
      j = j + 1;
      segments(j).id = i;
      segments(j).is = isegs(i);
      segments(j).ie = isegs(i+1);
      segments(j).col = rand(3,1);
      ivec = segments(j).is:segments(j).ie;
      segments(j).P = [x(ivec); y(ivec)];
      segments(j).xm = mean(segments(j).P,2);
    end;
    nsegs = j;
    
    % Compute features for each segment
    for i = 1:nsegs,
      P = segments(i).P;
      n = size(P,2);
      segments(i).npoints = n;
      segments(i).width = norm([P(1,1)-P(1,n); P(2,1)-P(2,n)]);
    end;
    
    % Classify each segment
    for i = 1:nsegs,
      n = segments(i).npoints;
      w = segments(i).width;
      cond = (n > 3) && (w < 0.8) && (w > 0.1);
      if cond,
        segments(i).class = 1;
        segments(i).col = [1 3*rand/4 0];
      else
        segments(i).class = 0;
        segments(i).col = [0 0 0];
      end;
    end;
    
    % Plot
    for i = 1:nsegs,
      segments(i).h = plot(segments(i).P(1,:),segments(i).P(2,:),'d','MarkerSize',8,'Color',segments(i).col);
    end;
    title(['Freiburg main station data set, step = ',int2str(istep)]);
    drawnow;
    for i = 1:nsegs,
      delete(segments(i).h);
    end;
  end;
end;


%% --------------------------------------------------------------------- %
% Exercise 4 (Optional): Feature Analysis
% ---------------------------------------------------------------------- %

% Read in labels if existant
if exist('datalabels.mat','file'),
  load('datalabels','labels');
else
  disp('Info: no annotation file found.');
  labels = zeros(nsteps,nbeams);
end;

% Your code...
