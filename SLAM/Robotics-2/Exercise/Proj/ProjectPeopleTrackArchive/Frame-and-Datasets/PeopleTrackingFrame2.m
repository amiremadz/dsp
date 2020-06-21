% Robotics II Class WS11/12
% Exercise 'People Detection and Tracking', Part II
% v.1.0, Jan 2012, Kai Arras, SRL Freiburg

clear all; clc;

C0 = diag([0.1 0.1 0.1 0.1]);
Q = diag([0.01 0.01 0.1 0.1]);


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

% Assign variables
% Z = ...;
% zvalid = ...;
% R = ...;

% Plot observation sequences
figure(1); clf; box on; hold on; axis equal;

% Your code...









%% Main loop

% Your code...



% Your code...
% for i = 1:....
 
  % Exercise 6: State Representation and Initialization
  % Your code...

  % Exercise 7: Motion Model
  % Your code...

  % Make observation
  % Your code...

  % Exercise 8: Measurement Model
  % Your code...

  % Exercise 10: Gating
  % Your code...

  % Exercise 9: Kalman filter
  % Your code...
  
  % Store state histories
  % Your code...
 
% end;



%% Plot histories
% Your code...


% Plot state components against time
figure(2); clf;

% Your code...


