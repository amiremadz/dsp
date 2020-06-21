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


#performs gmm clustering

#input
#  data:   matrix containing the input data samples as column vectors 
#          (size(data) = dim x number_of_samples)
#  number_of_clusters:	
#          number of mixture components (must be smaller than the number of data samples)
#  iterations: the number of iterations to run (if 0, this criterion is not checked)
#  movement_threshold: terminate if the maximum movement of a cluster mean during
#          one iteration is smaller than this value (if 0, this criterion is not checked)


#output
#  centroids: the centroids after termination of the algorithm. The
#          vector centroids(:,k) corresponds to the mean of cluster #k
#  covar:  the estimated covariances of the clusters. The covariance
#          of the kth cluster is covar(:,dim*(k-1)+1:dim*k), where dim is the
#          data dimension.
#  labels: a matrix containing the soft labels for the input data vectors. 
#          The probability that data point n belongs to cluster k is given by labels(n,k);
#  mix:    a vector containing the mixture weights. mix(k) ist the weight for cluster #k

function [centroids, covar, labels] = gmm(data, number_of_clusters)

  % initialization *****************************************
  assert(size(data,1)>1,'data dimension must be greater than 1(or plotting will crash)!')

  % some parameters
  plot_output = 1;
  verbose = 1;

  % get sizes
  number_of_samples = size(data,2);
  dim = size(data,1);  
   
  % init gmm TODO: init centroids, covar, mix 
  

  if plot_output
    figure
  end

  isTerminated=0;
  iteration_count=0;

  % main loop **********************************************
  % loop until termination
  while !isTerminated
    % assign labels (E-step) TODO: calculate soft labels

    if plot_output % this shows only the first two data components!
      colors = {"r", "g", "b", "m", "c"};
      clf;
      hold on;
      % calculate max of the soft labels
      [m, hlabels] = max(labels');
      for k = 1:number_of_clusters
        plot(data(1,hlabels==k),data(2,hlabels==k),'+','color',colors{mod(k,length(colors))+1}); % plot data, cycle through colors
        plot(centroids(1,k),centroids(2,k),'r+','MarkerSize',20,'LineWidth',10,'color','black');
        sigma = covar(1:2,dim*(k-1)+1:dim*(k-1)+2);
        [v,e]=eig(sigma)
        % calculate the angle of the first half axis
        phi = atan2(v(2,1),v(1,1));
        drawellipse([centroids(1:2,k);phi],sqrt(e(1,1)),sqrt(e(2,2)),colors{mod(k,length(colors))+1});
      end
      axis square
      sleep(0.1)
    end    
  
    % calculate new parameters (M-step) TODO: calculate new values for centroids, covar, mix
      
    
    % check termination criteria TODO: check if the algorithm should be terminated

    % verbose output
    if verbose
      % TODO
    end

  end % main loop
end

