clc
clear
close all

Fs = 20;                 %% Sampling frequency in Hz

filename = 'accel.csv';
filepath = '../data';

data = xlsread(fullfile(filepath,filename));

ORANGE = [1 .5 .2];
GREEN = [.5 .8 .5];


%% Time and Frequency vectors

N = size(data,1);        %% length of data on each axis

time = (0:N-1)/Fs;       
freqs = (0:N/2-1)/N*Fs;

%%  Checking dimensionality

[U,S,V] = svd(data,0); 
fprintf('Data singular values:\n\n')
disp(diag(S))

%% FFT of acceleration data

ax = data(:,1);          %% a_x
ay = data(:,2);          %% a_y
az = data(:,3);          %% a_z

Ax = fft(ax-mean(ax));
Ax = Ax(1:N/2);

Ay = fft(ay-mean(ay));
Ay = Ay(1:N/2);

Az = fft(az-mean(az));
Az = Az(1:N/2);

%% Time domain & Frequency domain plots of input acceleration data

figure
subplot(311)
plot(time,ax)
ylabel('a_x(t)')
xlabel('Time (sec)')

subplot(312)
plot(time,ay)
ylabel('a_y(t)')
xlabel('Time (sec)')

subplot(313)
plot(time,az)
ylabel('a_z(t)')
xlabel('Time (sec)')


figure
subplot(311)
plot(freqs,abs(Ax))
ylabel('A_x(f)')
xlabel('Frequency (Hz)')

subplot(312)
plot(freqs,abs(Ay))
ylabel('A_y(f)')
xlabel('Frequency (Hz)')

subplot(313)
plot(freqs,abs(Az))
ylabel('A_z(f)')
xlabel('Frequency (Hz)')

%% FIR lowpass filter

h = (.25)*[1 2 1];
M = length(h);

figure
freqz(h,1,1024,Fs);

%% Filter input accelarion data to reduce noise

axf = filter(h,1,ax);
ayf = filter(h,1,ay);
azf = filter(h,1,az);

%% Plot filtered data

figure
subplot(311)
plot(time,axf)
ylabel('a_x(t) filtered')
xlabel('Time (sec)')

subplot(312)
plot(time,ayf)
ylabel('a_y(t) filtered')
xlabel('Time (sec)')

subplot(313)
plot(time,azf)
ylabel('a_z(t) filtered')
xlabel('Time (sec)')

%% Find magnitude of filtered acceleration

af = sqrt(axf.^2 + ayf.^2 + azf.^2);


%% Algorithm for counting steps

ind_p = [];

L = 50;                         %% Number of data samples per chunk

AMP_THR = 1.2;                  %% Amplitude threshold

CLOSESTEPS_THR = 5;             %% If step detected, no steps will be detected in the next CLOSESTEPS_THR of samples

for i = 1:N/L

    indx = (i-1)*L+1:i*L;   
    samples = af(indx);         %% Get the i-th chunck of data consisting L samples

    if (i==1)
        min_af(indx) = min(samples(M:end));
        max_af(indx) = max(samples(M:end));
    else
        min_af(indx) = min(samples(1:end));
        max_af(indx) = max(samples(1:end));
    end
    
    avg_af(indx) = (min_af(indx) + max_af(indx))/2;        %% Dynamic baseline: Average of the Min and Max of i-th L samples
    
    for j = 1:L                                            %% Find local maxima on |a_f| which are bigger than AMP_THR times Dynamic baseline
        
        if (j==1)
            if (samples(j)> AMP_THR*avg_af(indx(1)) && samples(j)>samples(j+1))
                ind_p = [ind_p;indx(j)];
            end
            
        elseif (j==L)
            if (samples(j)> AMP_THR*avg_af(indx(1)) && samples(j)>samples(j-1))
                ind_p = [ind_p;indx(j)];
            end
        elseif (samples(j)> AMP_THR*avg_af(indx(1)) && samples(j)>samples(j-1) && samples(j)>samples(j+1))
            ind_p = [ind_p;indx(j)];
        end
        
    end
    
end

redun = ind_p(1+find(diff(ind_p)<CLOSESTEPS_THR));          %% Time index of redundant (too close to each other)

ind_steps = setdiff(ind_p,redun);                           %% Time index of detected steps

fprintf('Time instance (in sec) of detected steps:\n\n');
disp(time(ind_steps)');

num_steps = length(setdiff(ind_p,redun));                   %% Number of detected steps

fprintf('Number of steps detected: %d\n\n',num_steps);

%% Plot filtered |a|, decision threshold, and detected steps

figure
hold on
plot(time,af,'k','linewidth',1)
plot(time,avg_af,'r','linewidth',2)
plot(time(ind_steps),af(ind_steps),'o','markerfacecolor',ORANGE)
ylabel('|a(t)| filtered')
xlabel('Time (sec)')
box on;
legend('|a_f|','(Min+Max)/2','Steps')


%%



































