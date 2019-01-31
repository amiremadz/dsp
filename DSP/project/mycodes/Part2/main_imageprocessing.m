clc
clear 
close all


datapath = 'C:\Users\aemadzad\Documents\DSP_marouf_253\project\buck';

load(fullfile(datapath,'plus.mat'))

%%

figure
image(64*x),colormap gray

%% Basic: Part (a)

wc = 0.4;
n1 = 10; n2 = 4; n3 = 12;

[b1,a1] = butter(n1,wc);

a2 = 1;b2 = remez(n2,[0 wc-0.04 wc+0.04 1 ],[1 1 0 0]);
a3 = 1;b3 = remez(n3,[0 wc-0.04 wc+0.04 1],[1 1 0 0]);

%% Basic: Part (b)

figure
freqz(b1,a1,512)

figure
freqz(b2,a2,512)

figure
freqz(b3,a3,512)


% fvtool(b1,a1,b2,a2,b3,a3)

%% Basic: Part (c)

n = (0:200)';

stp1 = filter(b1,a1,ones(length(n),1));
stp2 = filter(b2,a2,ones(length(n),1));
stp3 = filter(b3,a3,ones(length(n),1));

figure
subplot(311)
stairs(n,stp1)
xlabel('n')
ylabel('s_1(n)')
grid on;
subplot(312)
stairs(n,stp2)
xlabel('n')
ylabel('s_2(n)')
grid on;
subplot(313)
stairs(n,stp3)
xlabel('n')
ylabel('s_3(t)')
grid on;

%% Intermidiate: Parts (d), (e)

x16 = x(:,16);

d1 = find_dval(b1,a1);
d2 = find_dval(b2,a2);
d3 = find_dval(b3,a3);

y16_1C = filter(b1,a1,x16);
y16_1 = noncausalfilter(b1,a1,d1,x16);
y16_2 = noncausalfilter(b2,a2,d2,x16);
y16_3 = noncausalfilter(b3,a3,d3,x16);


figure
subplot(311)
hold on
stairs(x16)
stairs(y16_1,'r')
stairs(y16_1C,'k')
legend('x16','y16 (NC)','y16 (C)')
box on
title('Filter 1')

subplot(312)
hold on
stairs(x16)
stairs(y16_2,'r')
legend('x16','y16')
box on
title('Filter 2')

subplot(313)
hold on
stairs(x16)
stairs(y16_3,'r')
legend('x16','y16')
box on
title('Filter 3')



%% Intermidiate: Part (f), (g), (h) Advanced: Part (i), (j)

y1 = filt2d(b1,a1,d1,x);
y2 = filt2d(b2,a2,d2,x);
y3 = filt2d(b3,a3,d3,x);

figure
subplot(221)
image(64*x), colormap gray
title('Original')
subplot(222)
image(64*y1), colormap gray
title('Filter 1')
subplot(223)
image(64*y2), colormap gray
title('Filter 2')
subplot(224)
image(64*y3), colormap gray
title('Filter 3')


%% Advanced: Part (k)

figure
image(64*xn), colormap gray


%%


yn1 = filt2d(b1,a1,d1,xn);
yn2 = filt2d(b2,a2,d2,xn);
yn3 = filt2d(b3,a3,d3,xn);


figure
subplot(221)
image(64*xn), colormap gray
title('Original')
subplot(222)
image(64*yn1), colormap gray
title('Filter 1')
subplot(223)
image(64*yn2), colormap gray
title('Filter 2')
subplot(224)
image(64*yn3), colormap gray
title('Filter 3')



%%























