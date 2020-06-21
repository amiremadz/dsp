#!/usr/bin/env python3

import numpy as np
from matplotlib import pyplot as plt
from scipy import signal
from mpl_toolkits import mplot3d
import sys

class DesignParams:
    def __init__(self):
        self.max_range = 200.0        # (m)
        self.range_resolution = 1.0 # (m)
        self.max_velocity = 100.0     # (m/s)
        self.fc = 77.0e9  # frequnecy of operation (carrier freq) in Hz
        self.c = 3.0e8                # (m/s) 
        self.lamda = self.c / self.fc

class LFM:
    def __init__(self, params):
        self.B = params.c / (2 * params.range_resolution)      # Bandwidth (Hz)
        self.PRI = 2.0 * params.max_range / params.c    # Width (m)
        self.PRF = 1.0 / self.PRI
        self.tau = 5.5 * self.PRI # 20 * 1.0 / self.B
        #self.tau = 2000 * 1.0 / self.B
        self.slope = self.B / self.tau  # Slope (Hz/s)

class Target:
    def __init__(self, num_of_samples, time):
        self.range_0 = 150.0          # initial range in (m)
        self.radial_velocity = 40.0  # radial velocity in (m/s)
        self.range = self.range_0 + self.radial_velocity * time

class Radar():
    def __init__(self, params, lfm, target, time):
        self.num_of_samples = time.shape[0]
        self.delay = (2.0 / params.c) * target.range # Time delay
        self.Tx = np.cos(2 * np.pi * (params.fc * time + 0.5 * lfm.slope * np.square(time)))  # Transmitted signal
        self.Rx = np.cos(2 * np.pi * (params.fc * (time - self.delay) + 0.5 * lfm.slope * np.square(time - self.delay)))  # Recived signal
        self.Mix = self.Tx * self.Rx  # Beat signal

if __name__ == "__main__":
    plt.close("all")
    print("Simulation: Radar target detection")
    
    params = DesignParams()
    lfm = LFM(params)    
   
    # The number of chirps in one sequence. Its ideal to have 2^ value for the ease of running the FFT
    # for Doppler Estimation.
    Nd = 128 
    # # of doppler cells OR #of sent periods % number of chirps
    Nr = 1024 
    num_of_samples = Nd * Nr
    time = np.linspace(0, Nd * lfm.tau, num_of_samples) 
    time = time[:, np.newaxis]
    
    target = Target(num_of_samples, time)
    radar = Radar(params, lfm, target, time)

    fs = 1.0 / (time[1] - time[0]) 
    f, t, STx = signal.spectrogram(np.squeeze(radar.Tx), fs)
    plt.figure()
    plt.title('Tx')
    plt.pcolormesh(t, f, STx)
    plt.xlabel('Time (sec)')
    plt.ylabel('Frequency (Hz)')

    f, t, SRx = signal.spectrogram(np.squeeze(radar.Rx), fs)
    plt.figure()
    plt.title('Rx')
    plt.pcolormesh(t, f, SRx)
    plt.xlabel('Time (sec)')
    plt.ylabel('Frequency (Hz)')

    f, t, SMx = signal.spectrogram(np.squeeze(radar.Mix), fs)
    plt.figure()
    plt.title('Mix')
    plt.pcolormesh(t, f, SMx)
    plt.xlabel('Time (sec)')
    plt.ylabel('Frequency (Hz)')

    ## RANGE MEASUREMENT
    # Reshape the vector into [Nr, Nd] array. 
    # Nr and Nd here would also define the size of Range and Doppler FFT respectively. 
    Mix = np.reshape(radar.Mix, (Nd, Nr))
    Mix = Mix.transpose()
   
    #MixFft = np.fft.fftn(Mix, axes = (0,))
    MixFft = np.fft.fft2(Mix)
    #MixFft = np.fft.fftn(MixFft, axes = (1,))
    
    MixFft = np.abs(MixFft) 
    MixFft = MixFft / MixFft.max(axis=0) 
    MixFft = MixFft[:Nr / 2, :]

    plt.figure()
    plt.plot(1e6 * time, target.range)
    plt.grid()
    plt.xlabel('Time (mu sec)')
    plt.ylabel('Range (m)')

    plt.figure()
    plt.plot(MixFft[:, -1])
    plt.grid()
    plt.xlabel('range (m)')
    plt.xlim((0, params.max_range))
    plt.ylim((0, 1))

    doppler_axis = np.linspace(-params.max_velocity, params.max_velocity, Nd)
    range_axis = np.linspace(0, params.max_range, Nr / 2) 

    D, R = np.meshgrid(doppler_axis, range_axis)
    plt.figure()
    ax = plt.axes(projection = '3d')
    surf = ax.plot_surface(R, D, MixFft, cmap = 'viridis', edgecolor = 'none')
    plt.xlabel('Range (m)')
    plt.ylabel('Doppler (m/s)')

    range_axis = np.linspace(0, params.max_range, Nr) 
    D, R = np.meshgrid(doppler_axis, range_axis)
    plt.figure()
    ax = plt.axes(projection = '3d')
    surf = ax.plot_surface(R, D, Mix, cmap = 'viridis', edgecolor = 'none')
    plt.ylabel('Range (m)')
    plt.xlabel('Doppler (m/s)')

    

    ## RANGE DOPPLER RESPONSE
    # The 2D FFT implementation is already provided here. This will run a 2DFFT
    # on the mixed signal (beat signal) output and generate a range doppler
    # map.You will implement CFAR on the generated RDM
    # frequnecy of operation (carrier freq) in Hz

    # Range Doppler Map Generation.
    # The output of the 2D FFT is an image that has reponse in the range and
    # doppler FFT bins. So, it is important to convert the axis from bin sizes
    # to range and doppler based on their Max values.
    RDM = np.fft.fft2(Mix)
    RDM = MixFft[:Nr / 2, :]
    RDM = np.fft.fftshift(RDM)
    RDM = np.abs(RDM)
    RDM = 10 * np.log10(RDM)

    doppler_axis = np.linspace(-params.max_velocity, params.max_velocity, Nd)
    #range_axis = np.linspace(-params.max_range / 2, params.max_range / 2, Nr / 2) * ((Nr / 2) / (2 * params.max_range))
    range_axis = np.linspace(0, params.max_range, Nr / 2)


    plt.figure()
    plt.pcolormesh(doppler_axis, range_axis, RDM)
    plt.ylabel('Range (m)')
    plt.xlabel('Doppler (m/s)')
 
    D, R = np.meshgrid(doppler_axis, range_axis)
    plt.figure()
    ax = plt.axes(projection = '3d')
    surf = ax.plot_surface(R, D, RDM, cmap = 'viridis', edgecolor = 'none')
    plt.xlabel('Range (m)')
    plt.ylabel('Doppler (m/s)')
    

    ## CFAR implementation
   
    # Slide Window through the complete Range Doppler Map

    # Select the number of Training Cells in both the dimensions.
    Tr = 10
    Td = 7

    # Select the number of Guard Cells in both dimensions around the Cell under test (CUT) for accurate estimation
    Gr = 4
    Gd = 4

    # Offset the threshold by SNR value in dB
    offset = 1.5

    # Create a vector to store noise_level for each iteration on training cells
    #noise_level = zeros();

    # Design a loop such that it slides the CUT across range doppler map by
    # giving margins at the edges for Training and Guard Cells.
    # For every iteration sum the signal level within all the training
    # cells. To sum convert the value from logarithmic to linear using db2pow
    # function. Average the summed values for all of the training
    # cells used. After averaging convert it back to logarithimic using pow2db    # Further add the offset to it to determine the threshold. Next, compare the signal under CUT with this threshold. If the CUT level > threshold assign it a value of 1, else equate it to 0.

    RDM = RDM/RDM.max()
    CFAR = np.zeros((Nr / 2, Nd))

    for row in xrange(Tr + Gr + 1, Nr / 2 - Tr - Gr + 1):
        for col in xrange(Nr / 2):
            noise_level = 0
            for r in xrange():
                for c in xrange()
                    if ():
                        noise_level += 10.0 ^ (RDM[r, c] / 10.0)

            threshold = 10 * np.log10(noise_level) + offset
            if (RDM[row, col] > threshold):
                CFAR[row, col] = 1

                        

    #plt.figure()
    #ax = plt.axes(projection = '3d')
    #surf = ax.plot_surface(R, D, CFAR, cmap = 'viridis', edgecolor = 'none')
    #plt.xlabel('Range (m)')
    #plt.ylabel('Doppler (m/s)')
 

    plt.show()





