function phonenumber = ttdecodev1(phonesignal)

phonesignal = phonesignal(:);

N = 1000;
Nfft = 2048;
Nspace = 100;

omega_table = [0.7217 1.0247;0.5346 0.9273;0.5346 1.0247;0.5346 1.1328;0.5906 0.9273;0.5906 1.0247;...
    0.5906 1.1328; 0.6535 0.9273; 0.6535 1.0247; 0.6535 1.1328];

omegas_unique = unique(omega_table);

binNumPredict =  round( omegas_unique*Nfft/(2*pi) + 1 );

phonenumber = [];


for ii = 1:7
    
    sigNow = phonesignal( 1+(N+Nspace)*(ii-1):N+(N+Nspace)*(ii-1) );

    sigNowfftabs2 = abs( fft(sigNow,Nfft) ).^2;

    
    [~,indFreqs] = sort( sigNowfftabs2(binNumPredict),'descend' );


    omegasINsigNow = omegas_unique(indFreqs(1:2));

    [~,indDigit] = ismember( sort(omegasINsigNow'),omega_table,'rows' );
    
    
    phonenumber = [phonenumber,indDigit-1];
    
    
end


 






end