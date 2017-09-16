clc
clear
close all

Fs = 20;

filename = 'accel.csv';
filepath = '../data';

data = xlsread(fullfile(filepath,filename));

ORANGE = [1 .5 .2];
GREEN = [.5 .8 .5];


%%

N = size(data,1);

time = (0:N-1)/Fs;
freqs = (0:N/2-1)/N*Fs;

%%

[U,S,V] = svd(data,0);

%%

ax = data(:,1);
ay = data(:,2);
% ay = ay - mean(ay);
az = data(:,3);

Ax = fft(ax);
Ax = Ax(1:N/2);

Ay = fft(ay);
Ay = Ay(1:N/2);

Az = fft(az);
Az = Az(1:N/2);

%%

figure
subplot(311)
plot(time,ax)
ylabel('a_x')
xlabel('Time (sec)')

subplot(312)
plot(time,ay)
ylabel('a_y')
xlabel('Time (sec)')

subplot(313)
plot(time,az)
ylabel('a_z')
xlabel('Time (sec)')



figure
subplot(311)
plot(freqs,abs(Ax))
ylabel('A_x')
xlabel('Frequency (Hz)')

subplot(312)
plot(freqs,abs(Ay))
ylabel('A_y')
xlabel('Frequency (Hz)')

subplot(313)
plot(freqs,abs(Az))
ylabel('A_z')
xlabel('Frequency (Hz)')


%%

avg = (ax+ay+az)/3;

figure
plot(time,avg)
ylabel('Average a')
xlabel('Time (sec)')




%%


% fp = 4;
% fs = 6;
% 
% wp = 2*pi*fp/Fs;
% ws = 2*pi*fs/Fs;
% 
% Ap = 0.1;
% As = 50;
% 
% deltap = (10^(Ap/20) - 1)/(10^(Ap/20) + 1);
% deltas = (1 + deltap)/(10^(As/20));
% 
% [M,fo,ao,W] = firpmord([wp,ws]/pi,[1 0],[deltap,deltas]);
% 
% M
% 
% [h,delta] = firpm(M,fo,ao,W);

%%

h = (.25)*[1 2 1];



figure
freqz(h,1,1024,Fs);



%%

axf = filter(h,1,ax);
ayf = filter(h,1,ay);
azf = filter(h,1,az);

%%

% alpha = 0.95;
% 
% b = 1 - alpha;
% a = [1 -alpha];
% 
% axf = filter(b,a,ax);
% ayf = filter(b,a,ay);
% azf = filter(b,a,az);

%%

figure
subplot(311)
plot(time,axf)
ylabel('a_x filtered')
xlabel('Time (sec)')

subplot(312)
plot(time,ayf)
ylabel('a_y filtered')
xlabel('Time (sec)')

subplot(313)
plot(time,azf)
ylabel('a_z filtered')
xlabel('Time (sec)')



%%

avg_af = (axf+ayf+azf)/3;

figure
plot(time,avg_af)
ylabel('Average a')
xlabel('Time (sec)')

%%

agx = axf(20)*axf;
agy = ayf(20)*ayf;
agz = azf(20)*azf;


figure
subplot(311)
plot(time,agx)
ylabel('a_gx filtered')
xlabel('Time (sec)')

subplot(312)
plot(time,agy)
ylabel('a_gy filtered')
xlabel('Time (sec)')

subplot(313)
plot(time,agz)
ylabel('a_gz filtered')
xlabel('Time (sec)')

%%

avg_ag = (agx+agy+agz)/3;

figure
plot(time,avg_ag)
ylabel('Average a_g filtered')
xlabel('Time (sec)')

%%

a = sqrt(ax.^2 + ay.^2 + az.^2);
af = sqrt(axf.^2 + ayf.^2 + azf.^2);
 

%%



af_1 = filter(h,1,a);

figure
hold on
plot(time,af_1)
plot(time,af,'k')
ylabel('Average a')
xlabel('Time (sec)')

%%


% alpha = 0.1;
% a_mv = filter(alpha,[1 -(1-alpha)],a);

% [xout,yout] = intersections(time,a,time,a_mv,1);


figure
hold on
plot(time,a-mean(a),'linewidth',2)
% plot(time,a_mv,'r','linewidth',2)


%%

ind_p = [];

L = 50;

JMP_THR = 0;
AMP_THR = 1.2;

for i = 1:N/L
    
%     min_x((i-1)*L+1:i*L) = min(axf((i-1)*L+1:i*L));
%     min_y((i-1)*L+1:i*L) = min(ayf((i-1)*L+1:i*L));
%     min_z((i-1)*L+1:i*L) = min(azf((i-1)*L+1:i*L));


    
%     max_x((i-1)*L+1:i*L) = max(axf((i-1)*L+1:i*L));
%     max_y((i-1)*L+1:i*L) = max(ayf((i-1)*L+1:i*L));
%     max_z((i-1)*L+1:i*L) = max(azf((i-1)*L+1:i*L));
    

    indx = (i-1)*L+1:i*L;
    smpls = af(indx);

    if (i==1)
        min_af(indx) = min(smpls(3:end));
        max_af(indx) = max(smpls(3:end));
    else
        min_af(indx) = min(smpls(1:end));
        max_af(indx) = max(smpls(1:end));
    end
    avg_af(indx) = (min_af(indx) + max_af(indx))/2;
    
    for j = 1:L
        
        if (j==1)
            if (smpls(j)> AMP_THR*avg_af(indx(1)) && smpls(j)-smpls(j+1)>JMP_THR)
                ind_p = [ind_p;indx(j)];
            end
            
        elseif (j==L)
            if (smpls(j)> AMP_THR*avg_af(indx(1)) && smpls(j)-smpls(j-1)>JMP_THR)
                ind_p = [ind_p;indx(j)];
            end
        elseif (smpls(j)> AMP_THR*avg_af(indx(1)) && smpls(j)-smpls(j-1)>JMP_THR && smpls(j)-smpls(j+1)>JMP_THR)
            ind_p = [ind_p;indx(j)];
        end
        
    end
    

end


redun = ind_p(1+find(diff(ind_p)<5))

ind_steps = setdiff(ind_p,redun)

num_steps = length(setdiff(ind_p,redun))

% avg_x = (min_x + max_x)/2;
% avg_y = (min_y + max_y)/2;
% avg_z = (min_z + max_z)/2;

% avg_af = (min_af + max_af)/2;
% thr_af_up = .8*max_af;
% thr_af_dn = 1.2*min_af;



%%

% af_drv = [af(1);diff(af)];
% 
% axf_drv = [axf(1);diff(axf)];
% ayf_drv = [ayf(1);diff(ayf)];
% azf_drv = [azf(1);diff(azf)];
% 
% axf_int = cumtrapz(time,axf-mean(axf));
% ayf_int = cumtrapz(time,ayf-mean(ayf));
% azf_int = cumtrapz(time,azf-mean(azf));


%%

figure
hold on
plot(time,af,'k','linewidth',1)
plot(time,avg_af,'r','linewidth',2)
% plot(time,min_af,'--','color',ORANGE,'linewidth',2)
% plot(time,max_af,'--','color',GREEN,'linewidth',2)
% plot(time,thr_af_up,'--','color','m','linewidth',2)
% plot(time,thr_af_dn,'--','color','m','linewidth',2)
plot(time(ind_steps),af(ind_steps),'o','markerfacecolor',ORANGE)
ylabel('a filtered')
xlabel('Time (sec)')
box on;

%%










break











%%


figure
subplot(311)
hold on
plot(time,avg_x,'r','linewidth',2)
plot(time,min_x,'--','color',ORANGE,'linewidth',2)
plot(time,max_x,'--','color',GREEN,'linewidth',2)
plot(time,axf,'k')
% plot(time,axf_drv,'b','linewidth',2)
ylabel('a_x filtered')
xlabel('Time (sec)')

subplot(312)
hold on
plot(time,avg_y,'r','linewidth',2)
plot(time,min_y,'--','color',ORANGE,'linewidth',2)
plot(time,max_y,'--','color',GREEN,'linewidth',2)
plot(time,ayf,'k')
% plot(time,ayf_drv,'b','linewidth',2)
ylabel('a_y filtered')
xlabel('Time (sec)')

subplot(313)
hold on
plot(time,avg_z,'r','linewidth',2)
plot(time,min_z,'--','color',ORANGE,'linewidth',2)
plot(time,max_z,'--','color',GREEN,'linewidth',2)
plot(time,azf,'k')
% plot(time,azf_drv,'b','linewidth',2)
ylabel('a_z filtered')
xlabel('Time (sec)')

%%
figure
plot(time,af_drv,'b','linewidth',2)

figure
subplot(311)
plot(time,axf_drv,'b','linewidth',2)
subplot(312)
plot(time,ayf_drv,'b','linewidth',2)
subplot(313)
plot(time,azf_drv,'b','linewidth',2)


%%

figure
subplot(311)
plot(time,axf_int,'b','linewidth',2)
grid on
subplot(312)
plot(time,ayf_int,'b','linewidth',2)
grid on

subplot(313)
plot(time,azf_int,'b','linewidth',2)
grid on

%%

var_x = max_x - min_x;

var_thr = .8;

find(var_x>var_thr);














