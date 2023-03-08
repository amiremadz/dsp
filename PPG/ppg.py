
import mpld3
import numpy as np
import pandas as pd

from matplotlib import pyplot as plt
from scipy import io
from scipy import signal

def mfreqz(b, a, fs):
    w, h = signal.freqz(b,a)
    h_dB = 20 * np.log10 (abs(h))
    
    plt.subplot(211)
    plt.plot((fs / 2) * w / max(w), h_dB)
    plt.ylim(-150, 5)
    plt.ylabel('Magnitude (db)')
    #plt.xlabel(r'Normalized Frequency (x$\pi$rad/sample)')
    plt.xlabel(r'Frequency (Hz)')    
    plt.title(r'Frequency response')

    plt.subplot(212)
    h_Phase = np.unwrap(np.arctan2(np.imag(h), np.real(h)))
    plt.plot((fs / 2) * w / max(w), h_Phase)
    plt.ylabel('Phase (radians)')
    plt.xlabel(r'Frequency (Hz)')    
    #plt.xlabel(r'Normalized Frequency (x$\pi$rad/sample)')
    plt.title(r'Phase response')
    plt.subplots_adjust(hspace=0.5)



def time_plot(sig, t, ylabel):
    plt.plot(t, sig)
    plt.xlabel('time (sec)')
    plt.ylabel(ylabel)
    plt.grid()

def spectrum(sig, fs, Nfft=2048):
    Nfft2 = int(Nfft / 2)
    
    sig = (sig - np.mean(sig)) / (max(sig) - min(sig))
    
    Psig = np.abs(np.fft.fft(sig , Nfft, axis=0))
    Psig = Psig[:Nfft2]
    Psig = Psig / max(Psig)

    freqs = fs * np.arange(Nfft2) / Nfft
    
    fig, ax = plt.subplots()
    plt.plot(freqs, Psig)
    plt.xlabel('freq (Hz)')
    plt.ylabel('|P(f)|')


def spectro(sig, fs):
    f, t, Sxx = signal.spectrogram(sig, fs)
    plt.pcolormesh(t, f, Sxx, shading='gouraud')
    plt.ylabel('Frequency [Hz]')
    plt.xlabel('Time [sec]')
    plt.show()


def normalize(sig):
    sig = (sig - np.mean(sig))/ (max(sig) - min(sig))
    return sig


def LMS(x, d, M, mu):
    x = np.expand_dims(x, axis=1)
    d = np.expand_dims(d, axis=1)

    Nx = x.shape[0]

    w = np.zeros((M + 1, 1))

    W = np.zeros((Nx - M, M + 1))
    E = np.zeros((Nx - M, 1))

    for k in np.arange(M, Nx): 
        if (k == M):
            Xbar = x[k::-1]
        else:
            Xbar = x[k:k - M - 1: -1]
            
        y = np.dot(np.transpose(w) , Xbar)
        e = d[k] - y
        w += 2 * mu * e * Xbar
        
        W[k - M, :] = np.transpose(w)
        E[k - M] = e

    return W, np.ndarray.flatten(E)




def read_from_excel():
    fs = 50 #Hz
    Ts = 1 / fs
    df = pd.read_excel('ppg_acc.xlsx', header=None, skiprows=[0,1])
    nrows = df.shape[0]
    t = np.arange(0, nrows * Ts, Ts)
    t = t[:-1]
    ppg = 1 / df[0]
    ppg = normalize(ppg)
    acc_x = df[1]  
    acc_y = df[2]
    acc_z = df[3] 
    acc = np.sqrt(np.square(acc_x) + np.square(acc_y) + np.square(acc_z))
    acc = normalize(acc)
    
    return ppg, acc, t, fs



ppg, acc, t, fs = read_from_excel()


time_plot(ppg, t, 'ppg')
spectrum(ppg, fs)
spectro(ppg, fs)

lo = 60 / 60  #Hz
hi = 180 / 60 #Hz

n = 251
a = 1
b = signal.firwin(n, cutoff = [lo, hi], window = "hanning", pass_zero=False, fs=fs)

mfreqz(b, a, fs)

ppg_bpf = signal.lfilter(b, a, ppg, axis=0)

skip = 0

time_plot(ppg_bpf[skip:], t[skip:], 'ppg')
spectrum(ppg_bpf[skip:], fs)
spectro(ppg_bpf[skip:], fs)

time_plot(acc, t, 'acc')
spectrum(acc, fs)
spectro(acc, fs)

acc_bpf = signal.lfilter(b, a, acc, axis=0)
time_plot(acc_bpf[skip:], t[skip:], 'acc')
spectrum(acc_bpf[skip:], fs)
spectro(acc_bpf, fs)

M = 30
W, E = LMS(ppg_bpf[skip:], acc_bpf[skip:], M, 0.15)

w_af = W[-1,:]
print(w_af)
mfreqz(w_af, 1, fs)

time_plot(E, t[skip + M:], 'ppg')

E = normalize(E)
spectrum(E, fs)
spectro(E, fs)



















