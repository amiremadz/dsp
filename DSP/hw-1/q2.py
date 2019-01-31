import numpy as np
from matplotlib import pyplot as plt
import time

def dtft_1(x, nx, w):
	exp_w = lambda w0: np.exp(-1j*w0*nx)
	w = w[:, np.newaxis]
	W = np.apply_along_axis(exp_w, 1, w)
	x = x[:, np.newaxis]
	return W.dot(x)

def dtft_2(x, nx, w):
	exp_w = lambda w0: np.exp(-1j*w0*nx)
	w = w[:, np.newaxis]
	nx = nx[:, np.newaxis]
	W = w.dot(nx.T)
	W = np.exp(-1j*W)
	x = x[:, np.newaxis]
	return W.dot(x)


if __name__ == '__main__':
   nh = np.arange(-5, 7)
   h = (0.9)**nh
   L = 501
   w = np.linspace(0, np.pi, L)

   start = time.clock()
   H1 = dtft_1(h, nh, w)
   print time.clock() - start
   
   start = time.clock()
   H2 = dtft_2(h, nh, w)
   print time.clock() - start 

   np.testing.assert_allclose(H1, H2)

   H = H1

   plt.figure()
   plt.subplot(3, 1, 1)
   plt.plot(nh, h, '-o')
   plt.xlabel('n (sample)')
   plt.ylabel('h')
   plt.margins(.1, .1)
   plt.subplot(3, 1, 2)	
   plt.plot(w, np.absolute(H))
   plt.xlabel('w (rad)')
   plt.ylabel('|H|')
   plt.margins(.1, .1)
   plt.subplot(3, 1, 3)	
   plt.plot(w, np.angle(H))
   plt.xlabel('w (rad)')
   plt.ylabel('< H')
   plt.margins(.1, .1)
   plt.show()





