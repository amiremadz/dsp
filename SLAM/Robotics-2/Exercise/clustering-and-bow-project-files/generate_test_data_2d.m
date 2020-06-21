#generate gaussian clusters

#input
#  num_clusters: number of clusters to generate
#  cluster_size: size of the clusters. If it is a vector, it 
#                must have a length of num_clusters. If is is a scalar, it
#                will be applied to all clusters
#optional input
#  mu: a matrix containing the means of the clusters as columns. If not provided, it will be 
#      created randomly in a fixed range (see code). 
#  sigma: a matrix containing the diagonal elements of the covariances of the 
#         clusters (non-zero off-diagonal is not supported). If this is not provided, 
#         it will be created randomly in a fixed range (see code)

#output
#  data: matrix containing the sampled data vector as columns

function data = generate_test_data_2d(num_clusters, cluster_size, mu, sigma)
  % some parameters
  range_mu_min = -10;
  range_mu_max = 10;
  range_sigma_min = 0;
  range_sigma_max = 1;  

  % if cluster_size is a scalar and num_clusters > 1,
  % augment cluster_size
  if length(cluster_size)!=num_clusters 
    if length(cluster_size)!=1
      error('cluster_size must be scalar or match the number of clusters!')
    else
      cluster_size = ones(1,num_clusters)*cluster_size;
    end
  end
  
  % allocate storage
  data = zeros(2,sum(cluster_size));
  if nargin==2
    % generate means and covariances randomly
    mu = rand(2,num_clusters)*10;
    sigma = rand(2,num_clusters);
  elseif nargin == 3
    % generate covariances randomly
    sigma = rand(2,num_clusters);
    assert(size(mu)==[2 num_clusters])
  else
    % mu and sigma are given
    assert(nargin==4)
    assert(size(mu)==[2 num_clusters])
    assert(size(sigma)==[2 num_clusters])
  end
  for i = 1:num_clusters
      data_index=1+cumsum(cluster_size)(i)-cluster_size(i);
      assert(data_index+cluster_size(i)-1<=size(data,2));
      data(:,data_index:data_index+cluster_size(i)-1) = generate_gaussian_cluster(mu(:,i),sigma(:,i),cluster_size(i));
  end
end



function data = generate_gaussian_cluster(mu,sigma,N)
  dim = size(mu,1);
  data = stdnormal_rnd(dim,N);
  data = repmat(sigma,1,N).*data+repmat(mu,1,N);
end
