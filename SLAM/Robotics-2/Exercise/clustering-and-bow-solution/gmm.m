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

debug_on_error(1);
%debug_on_warning(1);
%page_output_immediately(1);

  % initialization *****************************************
  assert(size(data,1)>1,'data dimension must be greater than 1(or plotting will crash)!')

  % some parameters
  plot_output = 1;
  verbose = 1;
  iterations = 50;
  movement_threshold = 1e-3;
  random_init = 0;
  distributed_init = 1;
  
  % get sizes
  number_of_samples = size(data,2);
  dim = size(data,1);  

  % allocate storage
  labels = zeros(number_of_samples,number_of_clusters);
  assert(number_of_clusters<number_of_samples,['the number of clusters must be smaller'... 
    'than the number of data samples!']);
   
  % init gmm
  mix = ones(1,number_of_clusters)/number_of_clusters; % all weights equal
  covar = repmat(eye(dim),1,number_of_clusters); % unity covariances
  tic
  % create initial centroids
  if random_init
    centroids = random_initialization(dim,number_of_samples,number_of_clusters,data);
  end
  
  if distributed_init
    centroids = distributed_initialization(dim,number_of_samples,number_of_clusters,data);
  end
  printf('Init time: %.02f ms',toc*1000)

  %[centroids, covar, mix]=initGmm(data,number_of_clusters); %init model
  %disp('data'), disp(data)
  %disp('centroids'), disp(centroids)
  if plot_output
    figure
  end

  % main loop **********************************************
  isTerminated=0;
  iteration_count=0;
  % loop until termination
  while !isTerminated
    % assign labels (E-step)
    %labels = assignLabels(data,centroids, covar, mix);
    for n = 1:number_of_samples
      for k = 1:number_of_clusters
        labels(n,k)=mix(k)*gaussian(data(:,n),centroids(:,k),covar(:,dim*(k-1)+1:dim*k));
        %disp('[n k]'), disp([n k])
        %disp('[x centroids(:,k)]'), disp([x centroids(:,k)])
        %disp('gaussian(x,centroids(:,k),sigma)'), disp(gaussian(x,centroids(:,k),sigma))
        %disp('N'), disp(N)
        %disp('labels(n,k)'), disp(labels(n,k))
      end
    end
    % normalize the rows of the labels matrix
    labels=labels./repmat(sum(labels,2),1,number_of_clusters);
    %disp('labels'), disp(labels)
    if plot_output % this shows only the first two data components!
      %plotData(data,labels,centroids, covar);
      colors = {"r", "g", "b", "m", "c"};
      clf;
      hold on;
      % calculate max of soft labels
      [m, hlabels] = max(labels');
      for k = 1:number_of_clusters
        plot(data(1,hlabels==k),data(2,hlabels==k),'+','color',colors{mod(k,length(colors))+1}); % plot data, cycle through colors
        plot(centroids(1,k),centroids(2,k),'r+','MarkerSize',20,'LineWidth',10,'color','black');
        sigma = covar(1:2,dim*(k-1)+1:dim*(k-1)+2);
        [v,e]=eig(sigma);
        % calculate the angle of the first half axis
        phi = atan2(v(2,1),v(1,1));
        drawellipse([centroids(1:2,k);phi],sqrt(e(1,1)),sqrt(e(2,2)),colors{mod(k,length(colors))+1});
      end
      axis square
      sleep(0.1)
    end    
  
    % calculate new parameters (M-step)
    centroids_latched = centroids; % latch centroids
    %[centroids, covar, mix] = optimizeModel(data,labels);
    %centroids = zeros(dim, number_of_clusters); % erase old centroids
    covar = zeros(dim,dim*number_of_clusters); % erase old covar
    N = sum(labels,1);
    mix = N/number_of_samples;
    for k = 1:number_of_clusters
      centroids(:,k)=data*labels(:,k)/N(k);
    end

    for k = 1:number_of_clusters
      for n = 1:number_of_samples
        covar(:,dim*(k-1)+1:dim*k)=covar(:,dim*(k-1)+1:dim*k)+labels(n,k)*(data(:,n)-centroids(:,k))*(data(:,n)-centroids(:,k))'/N(k);
        %disp('[n k]'), disp([n k])
        %disp('[x centroids(:,k)]'), disp([x centroids(:,k)])
        %disp('N(k)'), disp(N(k))
        %disp('labels(n,k)'), disp(labels(n,k))
        %disp('sigma'), disp(sigma)
      end
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

    % verbose and graphical output
    if verbose
      % verbose output
      if iteration_count > 1
        printf('iteration %d: max. cluster movement = %f\n',...
          iteration_count, max_movement);
      else
        printf('iteration %d\n',iteration_count);
      end
    end
  %input('press key for next iteration!')
  end % main loop
  
end

% takes column vectors
function N = gaussian(x,mu,sigma)
  assert(size(x)==size(mu))
  assert(size(sigma,1)==size(x,1))
  N = exp(-(x-mu)'*inv(sigma)*(x-mu));
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
