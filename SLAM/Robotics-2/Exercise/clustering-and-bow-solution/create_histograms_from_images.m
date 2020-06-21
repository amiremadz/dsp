function [histograms matches classification_matrix] = create_histograms_from_images(codebook)
%filenames = {'0.JPG', '2.JPG','5.JPG','7.JPG','42.JPG','43.JPG','61.JPG','68.JPG','70.JPG','74.JPG','76.JPG','79.JPG','80.JPG'}
%filenames = {'1.JPG', '4.JPG','6.JPG','41.JPG','44.JPG','45.JPG','59.JPG','69.JPG','75.JPG','77.JPG','78.JPG','81.JPG','82.JPG'};
%filenames = {'41.JPG','42.JPG','43.JPG','44.JPG','45.JPG','61.JPG'};
filenames_reference_objects = {'0.JPG','1.JPG','4.JPG','7.JPG','41.JPG','42.JPG','43.JPG','59.JPG','69.JPG','70.JPG','75.JPG','77.JPG','78.JPG','79.JPG','80.JPG'};
filenames_test_objects = {'2.JPG','5.JPG','6.JPG','44.JPG','45.JPG','61.JPG','68.JPG','74.JPG','76.JPG','81.JPG','82.JPG'}; % 1 x rabbit, 2 x plane as test
filenames = [filenames_reference_objects filenames_test_objects];
number_ref = length(filenames_reference_objects);
number_test = length(filenames_test_objects);
do_pca = 0;
pca_dim = 3;
for i = 1:length(filenames)
  data = load([filenames{i} '.features']);
  class_id=data(1,1);
  data = data(:,2:end)';
  if do_pca  
    data = pca(data,pca_dim);
  end
  assert(size(data,1)==size(codebook,1));
  number_of_samples=size(data,2);
  number_of_clusters=size(codebook,2);
  % assign labels (E-step)
  % create a row vector which holds the distance to word k at index k
  distances = zeros(1,size(codebook,2));
  labels = zeros(1,number_of_samples);
  % loop through data samples
  for n = 1:number_of_samples
    % calculate the distances
    for k = 1:number_of_clusters
      distances(k)=norm(data(:,n)-codebook(:,k));
    end
    % find the nearest centroid
    [d, di] =  min(distances);
    labels(n) = di;
  end
  [nn,xx]=hist(labels,1:number_of_clusters);
  if i <= number_ref
    is_test = 0;
    is_ref = 1;
  else  
    is_test = 1;
    is_ref = 0;
  end
  histograms(i)=struct('filename',filenames{i},'class_id',class_id,'bins',xx,'counts',nn,'is_ref',is_ref,'is_test',is_test);
end

matches = zeros(number_test+1,number_ref+1);
% match each test histogram against each reference histogram
for i = 1:number_test
  for j= 1:number_ref
    assert(histograms(i).bins==histograms(j).bins,'bins of histograms must be identical!')
    matches(i+1,j+1)=norm(histograms(i+number_ref).counts-histograms(j).counts);
    matches(1,j+1) = histograms(j).class_id;
  end
  matches(i+1,1) = histograms(i+number_ref).class_id;
end

% now, create a classification matrix which contains
% for each test object the probabilities of
% belonging to each class

% look for classes
max_class_id=max(matches(1,2:end));
[classes xx] = hist(matches(1,2:end),1:max_class_id);
% count number of classes
number_of_classes = sum(classes!=0);
classification_matrix = zeros(number_test+1,number_of_classes+1);
classification_matrix(1,:)=[0 (1:max_class_id)(logical(classes))];
classification_matrix(2:end,1)=matches(2:end,1);
for i = 1:number_test
  for j= 1:number_ref
    ref_class_id = matches(1,j+1);
    classification_matrix(i+1,classification_matrix(1,:)==ref_class_id)+=matches(i+1,j+1);
  end
  % normalize by class frequencies
  for j = 1:number_of_classes
    class_id = classification_matrix(1,j+1);
    classification_matrix(i+1,j+1)=classification_matrix(i+1,j+1)/classes(class_id);
  end
end

end


