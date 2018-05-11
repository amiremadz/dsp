import numpy as np
from scipy import signal
from matplotlib import pyplot as plt

nx = 50
D = 2

x1 = np.random.randn(nx)
x2 = np.roll(x1, D)
x3 = np.roll(x1, -D)

crr12 = signal.correlate(x1, x2)
crr13 = signal.correlate(x1, x3)

lags = np.arange(-nx + 1, nx)
delay12 = lags[np.argmax(crr12)]
delay13 = lags[np.argmax(crr13)]

fig = plt.figure()
plt.plot(x1, 'b', label='$x_1$')
plt.plot(x2, 'g', label='$x_2$: delayed')
plt.plot(x3, 'r', label='$x_3$: advanced')
plt.grid()
plt.legend()

fig = plt.figure(figsize=(10, 4))
axes = fig.add_subplot(1, 2, 1)
axes.plot(lags, crr12)
axes.set_xlabel("lag (samples)")
axes.set_ylabel("xcorr (x1, x2)")
axes.grid()
axes.set_title("delay: {:d} samples".format(delay12))
axes = fig.add_subplot(1, 2, 2)
axes.plot(lags, crr13)
axes.set_xlabel("lag (samples)")
axes.set_ylabel("xcorr (x1, x3)")
axes.grid()
axes.set_title("delay: {:d} samples".format(delay13))

plt.show()
