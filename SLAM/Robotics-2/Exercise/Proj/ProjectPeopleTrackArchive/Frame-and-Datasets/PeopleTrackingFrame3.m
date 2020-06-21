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
if exist('dataobs4.mat','file'),
  load('dataobs4');
else
  disp('Error: data set file not found!');
  break;
end;

% Plot all tracks
% Your code...




%% --------------------------------------------------------------------- %
% Exercise 12: Main loop
% ---------------------------------------------------------------------- %


% Your code...
%for istep = ...
 
  % Get all valid observations at current step
  % Your code...
  
  % Predict all states and measurements
  % Your code...
  
  % Match observations with tracks using the NNSF
  %if (ntracks > 0) && (nobs > 0),
  %  [tracks,obs] = matchnnsf(tracks,obs,ALPHA);
  %end;

  % Update tracks 
  % Your code...

  % Initialize new tracks with non-matched observations
  % Your code...
  
  % Update track histories
  % Your code...
  
%end;



%% Plot histories

% Your code...

