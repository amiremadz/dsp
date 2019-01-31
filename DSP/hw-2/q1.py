import numpy as np
from matplotlib import pyplot as plt


f1 = 1.0/18
f2 = 5.0/128
fc = 50.0/128

n = np.arange(0, 256)
x = np.cos(2*np.pi*f1*n) + np.cos(2*np.pi*f2*n)
xc = np.cos(2*np.pi*fc*n)
xa = x*xc

plt.figure()
plt.subplot(3, 1, 1)
plt.plot(n, x)
plt.ylabel('x')
plt.margins(.1, .1)
plt.subplot(3, 1, 2)
plt.plot(n, xc)
plt.ylabel('x_c')
plt.margins(.1, .1)
plt.subplot(3, 1, 3)
plt.plot(n, xa)
plt.ylabel('x_a')
plt.xlabel('n')
plt.margins(.1, .1)


Xa1 = np.fft.fft(xa[:128], 128)
fa1 = np.linspace(0, 2*np.pi*(1 - 1.0/128), 128)
Xa2 = np.fft.fft(xa[:100], 128)
fa2 = np.linspace(0, 2*np.pi*(1 - 1.0/128), 128)
Xa3 = np.fft.fft(xa[:180], 256)
fa3 = np.linspace(0, 2*np.pi*(1 - 1.0/256), 256)

plt.figure()
plt.subplot(3, 1, 1)
plt.plot(fa1, Xa1)
plt.ylabel('|X_a1|')
plt.margins(.1, .1)
plt.subplot(3, 1, 2)
plt.plot(fa2, Xa2)
plt.ylabel('|X_a2|')
plt.margins(.1, .1)
plt.subplot(3, 1, 3)
plt.plot(fa3, Xa3)
plt.ylabel('|X_a3|')
plt.margins(.1, .1)
plt.xlabel('Frequency (rad)')


plt.show()
