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
#          (size(data) = data_dimensionality x number_of_data_samples)
#  number_of_clusters:	
#  k:	   number of clusters (must be smaller than the number of data samples)
#  iterations: the number of iterations to run (if 0, this criterion is not checked)
#  movement_threshold: terminate if the maximum movement of a cluster during
#          one iteration is smaller than this value (if 0, this criterion is not checked)
#
#optional input
#  initial_centroids(optional): matrix containing the initial positions
#          of the cluster centroids. If this is not provided, the 
#          initial centroids will be placed on randomly drawn data vectors.
#          to avoid identical initial centroids, the drawing is performed
#          without replacement


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

debug_on_error(1);
%debug_on_warning(1);
%page_output_immediately(1);

  % initialization *****************************************
  % get sizes
  number_of_samples = size(data,2);
  dim = size(data,1);

  assert(dim>1,'data dimension must be greater than 1(or plotting will crash)!')

  % some parameters
  plot_output = 1;
  verbose = 1;
  iterations = 100;
  movement_threshold = 1e-3;
  random_init = 0;
  distributed_init = 1;

  % allocate storage
  labels = zeros(1,number_of_samples);
  assert(number_of_clusters<number_of_samples,['the number of clusters must be smaller'... 
    'than the number of data samples!']);
  compactness=[];
   
  % init kmeans
  if random_init
    centroids = random_initialization(dim,number_of_samples,number_of_clusters,data);
  end
  
  if distributed_init
    centroids = distributed_initialization(dim,number_of_samples,number_of_clusters,data);
  end


  if plot_output
    figure
  end

  % main loop **********************************************
  isTerminated=0;
  iteration_count=0;
  % loop until termination
  while !isTerminated
    % assign labels (E-step)
    % create a row vector which holds the distance to centroid k at index k
    distances = zeros(1,number_of_clusters);
    labels = zeros(1,number_of_samples);
    c = 0;
    % loop through data samples
    for n = 1:number_of_samples
      % calculate the distances
      for k = 1:number_of_clusters
        distances(k)=norm(data(:,n)-centroids(:,k));
      end
      % find the nearest centroid
      [d, di] =  min(distances);
      labels(n) = di;
      c = c + d^2;
    end
    compactness = [compactness c];

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
  
    % calculate new parameters (M-step)
    centroids_latched = centroids; % latch centroids	
    empty_clusters = 0;
    centroids = zeros(dim, number_of_clusters);
    for n = 1:number_of_samples
      centroids(:,labels(n))=centroids(:,labels(n))+data(:,n);
    end
    sizes = getClusterSizes(labels);
    for i = 1:number_of_clusters
      if sizes(i)==0
        % reinitialize empty cluster
        data_distances = zeros(1,number_of_samples);
        for n = 1:number_of_samples % get distances between data points and centroids
          data_distances(n) = norm(data(:,n)-centroids(:,labels(n)));
        end
        [d_max, i_max] = max(data_distances)
        labels(i_max)=i;
        centroids(:,i)=data(:,i_max);
        empty_clusters = empty_clusters+1;
        sizes(i)=1;
      end
    centroids(:,i)=centroids(:,i)/sizes(i);
    end

    % check termination criteria
    % TODO: zero value (deactivated)
    iteration_count = iteration_count + 1;
    if (iteration_count >= iterations) && iterations % maximum number of iterations?
      disp('maximum number of iterations reached!')
      isTerminated = 1;
    end
    if movement_threshold
      movements = sum((centroids-centroids_latched),1);
      max_movement = max(abs(movements));
      % maximum movement of clusters below threshold?
      if max_movement<movement_threshold 
        disp('movement threshold reached!')
        isTerminated = 1;
      end
    end

    % verbose output
    if verbose
      % verbose output
      if iteration_count > 1
        printf('iteration %d: compactness = %f, max. cluster movement = %f, empty clusters = %d\n',...
          iteration_count, c, max_movement, empty_clusters);
      else
        printf('iteration %d: compactness = %f\n', iteration_count, c);
      end
    end

    %input('press key for next iteration!')
    end % main loop

end

function sizes = getClusterSizes(labels)
  sizes=zeros(1,max(labels));
  for i = 1:length(labels)
    sizes(labels(i))=sizes(labels(i))+1;
  end
end


function centroids = random_initialization(dim,number_of_samples,number_of_clusters,data)
  % create initial centroids by sampling from the data
  centroids = zeros(dim, number_of_clusters); 
  indices = 1:number_of_samples;
  for k = 1:number_of_clusters
    % draw index from the interval [1,length(indices)]
    index = round((rand*(length(indices)-1))+1);
    % assign data sample to centroid
    assert(index<=number_of_samples)
    centroids(:,k)=data(:,indices(index));
    % delete the index from the possible indices to avoid sampling the same value again
    if index==1
      indices=indices(2:end);
    elseif index==length(indices)
      indices=indices(1:end-1);
    else
      indices=indices([1:index-1 index+1:length(indices)]);
    end
    %disp('indices'),disp(indices)
  end
end

function centroids = distributed_initialization(dim,number_of_samples,number_of_clusters,data)
  % distribute initial centroids over the data
  centroids = zeros(dim, number_of_clusters);
  % draw first centroid from data
  indices = 1:number_of_samples;
  index = round((rand*(number_of_samples-1))+1);
  % assign data sample to centroid
  assert(index<=number_of_samples)
  centroids(:,1)=data(:,indices(index));
  for k = 2:number_of_clusters
    % get the distances to the neares centroids
    distances = zeros(1,k-1);
    cluster_dist = zeros(1,number_of_samples);
    for n = 1:number_of_samples
      % calculate the distances
      for l = 1:k-1
        distances(l)=norm(data(:,n)-centroids(:,l));
      end
      % find the nearest centroid
      [d, di] = min(distances);
      cluster_dist(n) = d;
    end
    % look for the worst data point
    [d, di] = max(cluster_dist);
    centroids(:,k)=data(:,di);
  end
end
