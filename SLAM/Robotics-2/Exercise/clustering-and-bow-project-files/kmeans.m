#   This source code was developed for the lectures of robotics2 
#   at the University of Freiburg.
#  
#   Copyright (c) 2011 Jonas Rist
#   
#   It is licenced under the Common Creative License,
#   Attribution-NonCommercial-ShareAlike 3.0
#  
#   You are free:
#     - to Share - to copy, distribute and transmit the work
#     - to Remix - to adapt the work
#  
#   Under the following conditions:
#  
#     - Attribution. You must attribute the work in the manner specified
#       by the author or licensor (but not in any way that suggests that
#       they endorse you or your use of the work).
#    
#     - Noncommercial. You may not use this work for commercial purposes.
#    
#     - Share Alike. If you alter, transform, or build upon this work,
#       you may distribute the resulting work only under the same or
#       similar license to this one.
#  
#   Any of the above conditions can be waived if you get permission
#   from the copyright holder.  Nothing in this license impairs or
#   restricts the author's moral rights.
#  
#   This software is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied 
#   warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
#   PURPOSE.  


#performs k-means clustering

#input
#  data:   matrix containing the input data samples as column vectors 
#          (size(data) = dim x number_of_samples)
#  number_of_clusters:	
#  k:	   number of clusters (must be smaller than the number of data samples)
#  iterations: the number of iterations to run (if 0, this criterion is not checked)
#  movement_threshold: terminate if the maximum movement of a cluster during
#          one iteration is smaller than this value (if 0, this criterion is not checked)

#output
#  centroids: the centroids after termination of the algorithm. The
#          vector centroids(:,k) corresponds to the cluster #k
#  labels: a row vector containing the cluster indices for the 
#          input data vectors. labels(n) gives the cluster index for 
#          the data vector data(:,n)
#  compactness: row vector containing the compactness (squared sum of differences
#          between data samples and clusters) for all iterations providing a simple 
#          illustration of the clustering process

function [centroids, labels, compactness] = kmeans(data, number_of_clusters)

  % initialization *****************************************
  % get sizes
  number_of_samples = size(data,2);
  dim = size(data,1);

  assert(dim>1,'data dimension must be greater than 1(or plotting will crash)!')

  % some parameters
  plot_output = 1;
  verbose = 1;
  
   
  % init kmeans TODO: initialize centroids

  if plot_output
    figure
  end

  isTerminated=0;
  iteration_count=0;

  % main loop **********************************************
  % loop until termination
  while !isTerminated
    % assign labels (E-step) TODO: assign data points to centroids
    % compute compactness

    if plot_output % this shows only the first two data components!
      colors = {"r", "g", "b", "m", "c"};
      number_of_clusters = number_of_clusters;
      clf;
      hold on;
      for i = 1:number_of_clusters
        plot(data(1,labels==i),data(2,labels==i),'+','color',colors{mod(i,length(colors))+1}); % plot data, cycle through colors
        plot(centroids(1,i),centroids(2,i),'r+','MarkerSize',20,'LineWidth',10,'color','black');
      end
      axis square
      %input('press key for next iteration!')
      sleep(0.1);
    end    
  
    % calculate new parameters (M-step) TODO calculate new centroids
    

    % check termination criteria TODO: check if the algorithm should be terminated

    % verbose output
    if verbose
      % TODO: add useful information
      printf('iteration %d: compactness = %f\n', iteration_count, compactness(iteration_count));
    end

  end % main loop
end

