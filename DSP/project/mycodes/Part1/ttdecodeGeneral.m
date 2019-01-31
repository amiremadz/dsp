function phonenumber = ttdecodeGeneral(phonesignal)

phonesignal = phonesignal(:);

Nfft = 2048;


omega_table = [0.7217 1.0247;0.5346 0.9273;0.5346 1.0247;0.5346 1.1328;0.5906 0.9273;0.5906 1.0247;...
    0.5906 1.1328; 0.6535 0.9273; 0.6535 1.0247; 0.6535 1.1328];

omegas_unique = unique(omega_table);

binNumPredict =  round( omegas_unique*Nfft/(2*pi) ) + 1;

phonenumber = [];

sigIndx = findRightSignal(phonesignal);

for ii = 1:7
    
    sigNow = phonesignal( sigIndx(ii,1):sigIndx(ii,2) );
    
    N = length(sigNow);
    
    dft_data = abs( goertzel([sigNow;zeros(Nfft-N,1)],binNumPredict) ).^2;
    
    [~,indFreqs] = sort( dft_data,'descend' );
    
    omegasINsigNow = omegas_unique(indFreqs(1:2));
    
    [~,indDigit] = ismember( sort(omegasINsigNow'),omega_table,'rows' );
    
    phonenumber = [phonenumber,indDigit-1];
    
    
end









end