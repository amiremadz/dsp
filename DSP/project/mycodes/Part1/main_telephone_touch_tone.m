clc
clear 
close all


%% Basic: Part (a)

n = 0:999;

N = length(n);

Fs = 8192;

omega_table = [0.7217 1.0247;0.5346 0.9273;0.5346 1.0247;0.5346 1.1328;0.5906 0.9273;0.5906 1.0247;...
    0.5906 1.1328; 0.6535 0.9273; 0.6535 1.0247; 0.6535 1.1328];

[ndigits nomegas] = size(omega_table);

disp('                       Digit                 omega_row                 omega_col')
disp([(0:ndigits-1)',omega_table])

d = zeros(ndigits,N);

for ii = 1:ndigits
    
    d(ii,:) = sin( omega_table(ii,1)*n ) + sin( omega_table(ii,2)*n );
   
end

d0 = d(1,:)';
d1 = d(2,:)';
d2 = d(3,:)';
d3 = d(4,:)';
d4 = d(5,:)';
d5 = d(6,:)';
d6 = d(7,:)';
d7 = d(8,:)';
d8 = d(9,:)';
d9 = d(10,:)';

%{
for ii = 1:ndigits
    
    sound(d(ii,:),Fs);
    pause;
    
end
%}

%% Basic: Part (b)

Nfft = 2048;

omega = (2*pi*(0:Nfft-1)/Nfft)';

D = fft(d',Nfft);

D = transpose(D);

for ii = 1:ndigits
    
    figure
    plot(omega(1:N/2),10*log10( abs(D(ii,1:N/2)) ))
    grid on
    xlim([0.5 1.25])
    xlabel('\omega (rad)')
    ylabel('|D(j\omega)| (dB)')
    title( ['\omega_1 = ',num2str( omega_table(ii,1) ),...
        ', \omega_2 = ',num2str( omega_table(ii,2) ) ] )
    
end


%% Basic: Part (c)

Nzero = 100;
space = zeros(Nzero,1);

phoneNum = '8456016';

phoneNumSig = [];

for ii = 1:length(phoneNum)
    
    digitnow = str2double(phoneNum(ii));
    
    switch digitnow
        
        case 0 
            dNow = d0;
        case 1
            dNow = d1;
        case 2
            dNow = d2;
        case 3
            dNow = d3;
        case 4
            dNow = d4;
        case 5
            dNow = d5;
        case 6
            dNow = d6;
        case 7
            dNow = d7;
        case 8
            dNow = d8;
        case 9
            dNow = d9;
            
    end
    
    phoneNumSig = [phoneNumSig;dNow;space];
    
end

sound(phoneNumSig,Fs)


%% Intermidiate: Part(d)

datapath = 'C:\Users\aemadzad\Documents\DSP_marouf_253\project\buck';

load(fullfile(datapath,'touch.mat'));

omega_np = (2*pi*[-Nfft/2:-1 0:Nfft/2-1]/Nfft)';

for ii = 1:7
    
    sigNow1 = x1(1+(N+Nzero)*(ii-1):N+(N+Nzero)*(ii-1));
    
    sigNowfft1 = transpose ( fftshift( fft(sigNow1,Nfft) ) );
   
    sigNowfft1_all(ii,:) = sigNowfft1;
    
    figure;
    plot(omega_np,10*log10( abs(sigNowfft1) ))
    grid on
    xlabel('\omega (rad)')
    ylabel('|D(j\omega)| (dB)')
    title(['Digit #: ',num2str(ii)])
    xlim([0.5 1.25])
    
end


 %%%%% Number in x1: '4 9 1 5 8 7 7'

for ii = 1:7
    
    sigNow2 = x2(1+1100*(ii-1):1000+1100*(ii-1));
    
    sigNowfft2 = transpose ( fftshift( fft(sigNow2,Nfft) ) );
   
    sigNowfft2_all(ii,:) = sigNowfft2;
    
    
    figure;
    plot(omega_np,10*log10( abs(sigNowfft2) ))
    grid on
    xlabel('\omega (rad)')
    ylabel('|D(j\omega)| (dB)')
    title(['Digit #: ',num2str(ii)])
    xlim([0.5 1.25])
    
end


%%%%% Number in x2: '2 5 3 1 0 0 0'


%% Advanced: Part(f)

omegas_unique = unique(omega_table);

binNumPredict =  round( omegas_unique*Nfft/(2*pi) ) + 1;

freq_index = [];

binNumPredict = [binNumPredict,Nfft - binNumPredict + 2];


for ii = 1:length(omegas_unique)
    
    xx = sin( omegas_unique(ii)*n );

    XX(ii,:) = fft(xx,Nfft);
   
    [~,indXX] = max( abs(XX(ii,1:N/2)) );
    
    freq_index = [freq_index;indXX]; 
    
    figure
    plot(omega,20*log10( abs(XX(ii,:)) ));
    xlabel('\omega (rad)')
    ylabel('|X(j\omega)|')
    title(['\omega = ', num2str(omegas_unique(ii)), '  Bin # ',num2str(binNumPredict(ii))])
    grid on

    
end

binNumPredict
freq_index = [freq_index,Nfft - freq_index + 2]
omega(freq_index)


%% Advanced: Part (g)

D8 = fft(d8,Nfft);

absD8sq = abs(D8).^2;

[dummy,indD] = sort( absD8sq(freq_index(:,1)),'descend' );

omegasINd8 = omegas_unique( indD(1:2) ) %% Supposed to be: 0.6535  1.0247


%% Advanced: Part (h)

% myphone = ttdecodev1(phoneNumSig)

myphone = ttdecode(phoneNumSig)

phone1 = ttdecode(x1)

phone2 = ttdecode(x2)


%% Advanced: Part (i)


myphone = ttdecode(phoneNumSig)

phone1 = ttdecode(x1)

phone2 = ttdecode(x2)


myphone = ttdecodeGeneral(phoneNumSig)

phone1 = ttdecodeGeneral(x1)

phone2 = ttdecodeGeneral(x2)

phone11 = ttdecodeGeneral(hardx1)


phone22 = ttdecodeGeneral(hardx2)




%%






