clc
clear 
close all


%%

addpath('C:\Users\aemadzad\Documents\DSP_marouf_253\project\buck');


%% Basic: Part (a)

n = 0:124;

x1 = ( sinc(.4*(n - 62)) ).^2;
x1 = x1(:);
x2 = ( sinc(.2*(n - 62)) ).^2;
x2 = x2(:);

figure
subplot(211)
stem(n,x1)
xlabel('n')
ylabel('x_1')
subplot(212)
stem(n,x2)
xlabel('n')
ylabel('x_2')

%% Basic: Part (b)

Nfft = 2048;
k = [0:Nfft/2-1 -Nfft/2:-1]/(Nfft/2);


%{
a = .1;
x = sinc( a*(n - 62) );
xx = x.^2; 
X = fft(x,Nfft);
XX = fft(xx,Nfft);


figure
subplot(311)
stem(n,x)
xlabel('n')
ylabel('x')
subplot(312)
plot(fftshift(k),fftshift(abs(X)),'linewidth',2)
ylabel('|X|')
xlabel('Normalized frequency (x \pi)')
xlim(2*[-1 1])
subplot(313)
plot(fftshift(k),fftshift(abs(XX)),'linewidth',2)
ylabel('|X*X|')
xlabel('Normalized frequency (x \pi)')
xlim(2*[-1 1])

%}


X1 = fft(x1,Nfft);
X2 = fft(x2,Nfft);


figure
subplot(211)
plot(fftshift(k),fftshift(abs(X1)),'linewidth',2)
ylabel('|X_1|')
xlabel('Normalized frequency (x \pi)')
xlim(1*[-1 1])
subplot(212)
plot(fftshift(k),fftshift(abs(X2)),'linewidth',2)
ylabel('|X_2|')
xlabel('Normalized frequency (x \pi)')
xlim(1*[-1 1])


%% Basic: Part (c)

L = 3;

xe1 = myexpander(x1,L);
xe2 = myexpander(x2,L);

Xe1 = fft(xe1,Nfft);
Xe2 = fft(xe2,Nfft);

figure
subplot(211)
plot(fftshift(k),fftshift(abs(Xe1)),'linewidth',2)
ylabel('|Xe_1|')
xlabel('Normalized frequency (x \pi)')
xlim(1*[-1 1])
title(sprintf('L = %d',L));
subplot(212)
plot(fftshift(k),fftshift(abs(Xe2)),'linewidth',2)
ylabel('|Xe_2|')
xlabel('Normalized frequency (x \pi)')
xlim(1*[-1 1])


%% Intermidiate: Part (d)

M = 2;

xd1 = mydownsampler(x1,M); % There will be aliasing since M > 1.25
xd2 = mydownsampler(x2,M); % There will be no aliasing since M < 2.5


Xd1 = fft(xd1,Nfft);
Xd2 = fft(xd2,Nfft);


figure
subplot(211)
plot(fftshift(k),fftshift(abs(Xd1)),'linewidth',2)
ylabel('|Xd1od|')
xlabel('Normalized frequency (x \pi)')
xlim(1*[-1 1])
title(sprintf('D = %d',M));
subplot(212)
plot(fftshift(k),fftshift(abs(Xd2)),'linewidth',2)
ylabel('|Xd2od|')
xlabel('Normalized frequency (x \pi)')
xlim(1*[-1 1])


%% Intermidiate: Part (f)

wc = pi/M ;

h = (wc/pi)*sinc( wc/pi*( -32:32 )' ).*hamming(65);

x1f = filter(h,1,x1);

X1f = fft(x1f,Nfft);

x1fd = mydownsampler(x1f,M);
X1fd = fft(x1fd,Nfft);

figure
subplot(211)
plot(fftshift(k),fftshift(abs(X1f)),'linewidth',2)
ylabel('|X_1f|')
xlabel('Normalized frequency (x \pi)')
xlim(1*[-1 1])
subplot(212)
plot(fftshift(k),fftshift(abs(X1fd)),'linewidth',2)
ylabel('|X_1f|')
xlabel('Normalized frequency (x \pi)')
xlim(1*[-1 1])


%% Advanced: part (g)


xd1ev = myDownsamplerEven(x1,M); % There will be aliasing since M > 1.25
xd2ev = myDownsamplerEven(x2,M); % There will be no aliasing since M < 2.5


Xd1ev = fft(xd1ev,Nfft);
Xd2ev = fft(xd2ev,Nfft);


figure
subplot(211)
plot(fftshift(k),fftshift(abs(Xd1ev)),'linewidth',2)
ylabel('|Xd1ev|')
xlabel('Normalized frequency (x \pi)')
xlim(1*[-1 1])
title(sprintf('D = %d',M));
subplot(212)
plot(fftshift(k),fftshift(abs(Xd2ev)),'linewidth',2)
ylabel('|Xd2ev|')
xlabel('Normalized frequency (x \pi)')
xlim(1*[-1 1])

break

%% Advanced: Part (h)

load('orig10k');
load('orig');

g = gcd(10240,8192);

Us = 8192/g;
Ds = 10240/g;

Ap = 1;
As = 60;

deltap = ( 10^(Ap/20) - 1 )/( 10^(Ap/20)+1 );
deltas = ( 1 + deltap )/( 10^(As/20) );

ws = 1/max(Us,Ds)*pi;
wp = 0.9*ws;

[M1,Wn,beta,ftype] = kaiserord([wp ws]/pi,[1 0],[deltap deltas]);

fprintf('Order of regular FIR (using Window design): %d\n\n',M1);


h1 = fir1(M1,Wn,ftype,kaiser(M1+1,beta));

x10kUs1filtDs = myUpDownSampler(x10k,Us*h1,Us,Ds);

x10kUs1filtDs2 = upfirdn(x10k,Us*h1,Us,Ds);

sound(x)
pause(1);
sound(x10k,10240)
pause(1);
sound(x10kUs1filtDs)
pause(1);
sound(x10kUs1filtDs2)


[H1,w] = freqz(h1,1);






%% Advanced: Part (i): PM Regular FIR


[M2,fo,ao,W] = firpmord([wp ws]/pi,[1 0],[deltap deltas]);

fprintf('Order of regular FIR (using PM design): %d\n\n',M2);

[h2,delta] = firpm(M2,fo,ao,W);

[H2,w] = freqz(h2,1);


figure
subplot(211)
plot(w/pi,20*log10(abs(H1)))
xlabel('Normalized Frequency (\times \pi)')
grid on
legend('Window method')
subplot(212)
plot(w/pi,20*log10(abs(H2)))
xlabel('Normalized Frequency (\times \pi)')
grid on
legend('PM method')


x10kUs2filtDs = myUpDownSampler(x10k,Us*h2,Us,Ds);

sound(x10kUs2filtDs)
pause(1);


%% Advanced: Part (i): PM IFIR

L4ifir = 3;

[M4F,fo4F,ao4F,W4F] = firpmord(L4ifir*[wp ws]/pi,[1 0],[deltap/2 deltas]);

fprintf('Order of IFIR F(z) filter: %d\n\n',M4F);

[hF,delta] = firpm(M4F,fo4F,ao4F,W4F);

HF = freqz(hF,1);


[M4G,fo4G,ao4G,W4G] = firpmord([wp (2*pi/L4ifir)-ws]/pi,[1 0],[deltap/2 deltas]);

fprintf('Order of IFIR G(z) filter: %d\n\n',M4G);

[hG,delta] = firpm(M4G,fo4G,ao4G,W4G);

HG = freqz(hG,1);

figure
subplot(221)
plot(w/pi,20*log10(abs(H1)))
xlabel('Normalized Frequency (\times \pi)')
grid on
title('H(z)')


subplot(222)
plot(w/pi,20*log10(abs(HG)))
xlabel('Normalized Frequency (\times \pi)')
grid on
title('G(z)')


subplot(223)
plot(w/pi,20*log10(abs(HF)))
xlabel('Normalized Frequency (\times \pi)')
grid on
title('F(z)')

hFup = myexpander(hF,L4ifir);

hIFIR = conv(hFup,hG);

Hifir = freqz(hIFIR,1);

subplot(224)
plot(w/pi,20*log10(abs(Hifir)))
xlabel('Normalized Frequency (\times \pi)')
grid on
title('IFIR(z)')

x10kUs2IfirDs = myUpDownSampler(x10k,Us*hIFIR,Us,Ds);

sound(x10kUs2IfirDs)
pause(1);

%%








