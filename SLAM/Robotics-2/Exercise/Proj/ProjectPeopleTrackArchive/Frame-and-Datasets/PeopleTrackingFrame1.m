% Robotics II Class WS11/12
% Exercise 'People Detection and Tracking'
% v.1.0, Dec 2011, Kai Arras, SRL Freiburg

clear all; close all; clc;

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

% Your code...









%% --------------------------------------------------------------------- %
% Exercise 2: Segmentation
% ---------------------------------------------------------------------- %

% Your code...













% Plot
figure(2); clf; box on; hold on;
axis equal; axis(AXVEC);
title('Segmented scan');

% Your code...





%% --------------------------------------------------------------------- %
% Exercise 3: Detection by Classification
% ---------------------------------------------------------------------- %

% Your code...











% Plot
figure(3); clf; box on; hold on;
axis equal; axis(AXVEC);
title('Classified segments');

% Your code...












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
