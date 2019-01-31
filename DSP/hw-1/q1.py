import numpy as np
from matplotlib import pyplot as plt

def conv_m(x, nx, h, nh):
	y = np.convolve(x, h)
	
	ny_beg = nx[0] + nh[0]	  
	ny_end = nx[-1] + nh[-1]
	ny = np.arange(ny_beg, ny_end+1)
	return y, ny



if __name__ == '__main__':
   x = np.array([1, 2, 3, 2, 1])
   nx = np.arange(-2, 3)

   h = np.array([1, 2, 3, 4])	   	
   nh = np.arange(-1, 3)
   
   y, ny = conv_m(x, nx, h, nh)
   
   plt.figure()
   plt.suptitle('Convolution')
   plt.subplot(3, 1, 1)
   plt.plot(nx, x, '-o')
   plt.ylabel('x')
   plt.margins(.2, .2)
   plt.subplot(3, 1, 2)
   plt.plot(nh, h, '-o')
   plt.ylabel('h')
   plt.margins(.2, .2)
   plt.subplot(3, 1, 3)
   plt.plot(ny, y, '-o')
   plt.ylabel('y')
   plt.xlabel('n')
   plt.margins(.2, .2)
   plt.show()