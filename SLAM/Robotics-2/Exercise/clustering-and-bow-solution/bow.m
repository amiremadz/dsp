% number of words for the codebook
number_of_clusters=25;
more off;
%create codebook from image features
%(.features files must be in the same folder or
%in a folder somewhere in the octave path)
[codebook labels] = create_codebook(number_of_clusters);
%create a histogram of the codebook
[nn,xx]=hist(labels,number_of_clusters);title('distribution of words');
printf('Created codebook with %d words\n',number_of_clusters);
printf('Ocurrence of words:\n')
disp(nn);
%create histograms from images and match them
[h m cl]=create_histograms_from_images(codebook);
printf('classification matrix \n');
cl
