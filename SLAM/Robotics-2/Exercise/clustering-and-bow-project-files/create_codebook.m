function [codebook labels] = create_codebook(number_of_clusters)
  %filenames = {'0.JPG', '2.JPG','5.JPG','7.JPG','42.JPG','43.JPG','61.JPG','68.JPG','70.JPG','74.JPG','76.JPG','79.JPG','80.JPG'}
  %filenames = {'1.JPG', '4.JPG','6.JPG','41.JPG','44.JPG','45.JPG','59.JPG','69.JPG','75.JPG','77.JPG','78.JPG','81.JPG','82.JPG'};
  filenames = {'0.JPG','1.JPG','4.JPG','7.JPG'}; % classes rabbit and plane
  %filenames = {'0.JPG','1.JPG','4.JPG','7.JPG','41.JPG','42.JPG','43.JPG'}; % classes rabbit,plane,red fire truck
  %filenames = {'0.JPG','1.JPG','4.JPG','7.JPG','41.JPG','42.JPG','43.JPG','59.JPG','69.JPG','70.JPG','75.JPG','77.JPG','78.JPG','79.JPG','80.JPG'}; % all classes
  codebook_data = [];
  for i = 1:length(filenames)
    data = load([filenames{i} '.features']);
    data = data(:,2:end)';
    assert(size(data,1)==64);
    codebook_data = [codebook_data data];
  end
  [codebook labels c] = kmeans(codebook_data,number_of_clusters);
end
