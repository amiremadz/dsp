import numpy as np
from matplotlib import pyplot as plt

def conv_m(x, nx, h, nh):
	y = np.convolve(x, h)
	
	ny_beg = nx[0] + nh[0]	  
	ny_end = nx[-1] + nh[-1]
	ny = np.arange(ny_beg, ny_end+1)
	return y, ny

def conv_fft(x, h):
	N = x.shape[0] + h.shape[0] - 1
	X = np.fft.fft(x, N)
	H = np.fft.fft(h, N)
	return np.real(np.fft.ifft(X*H)) 

def conv_fft_m(x, nx, h, nh):
	y = conv_fft(x, h)
	ny_beg = nx[0] + nh[0]	  
	ny_end = nx[-1] + nh[-1]
	ny = np.arange(ny_beg, ny_end+1)
	return y, ny

def circ_conv(x, h):
	N = x.shape[0]
	X = np.fft.fft(x)
	H = np.fft.fft(h, N)
	return np.real(np.fft.ifft(X*H))

def overlap_add(x, h, Q):
	Lx = x.shape[0]
	Lh = h.shape[0]
	Nblocks = Lx/Q
	Ly = Lx + Lh - 1
	ny = Q + Lh - 1 
	y = np.zeros((Ly, 1))

	for i in xrange(Nblocks):
		yQ = conv_fft(x[Q*i:Q*(i+1)], h)
		y[Q*i:Q*i+ny, :] += yQ[:, np.newaxis]

	x_remain = x[Q*(i+1):]
	y_remain = conv_fft(x_remain, h)
	y[Q*(i+1):, :] += y_remain[:, np.newaxis]

	return np.ravel(y)

def overlap_add_m(x, nx, h, nh, Q):
	nb = nx[0] + nh[0]
	ne = nx[-1] + nh[-1]
	ny = np.arange(nb, ne+1)
	y = overlap_add(x, h, Q)
	return y, ny		

def overlap_save(x, h, Q):
	Lh = h.shape[0]
	overlap = Lh - 1
	Lx_orig = x.shape[0]
	x = np.append(np.zeros(overlap), x)
	Lx = x.shape[0]
	P = Q - overlap
	Nblocks =  1+(Lx - Q)/P
	Ly = Lx + Lh - 1
	y = np.zeros((Ly, 1))

	for i in xrange(Nblocks):
		yQ = circ_conv(x[i*P:i*P+Q], h)
		y[P*i:P*(i+1), :] = yQ[overlap:][:, np.newaxis]

	Ly_conv = Lx_orig + Lh - 1
	x_remain = x[(i+1)*P:]
	Lx_remain = x_remain.shape[0]
	Ly_remain = Ly - P*(i+1)

	x_remain_zpad = np.append(x_remain, np.zeros(overlap+Ly_remain-Lx_remain))
	y_remain = circ_conv(x_remain_zpad , h)

	y[P*(i+1):, :] = y_remain[overlap:][:, np.newaxis]
	
	return np.ravel(y[:Ly_conv])

def overlap_save_m(x, nx, h, nh, Q):
	nb = nx[0] + nh[0]
	ne = nx[-1] + nh[-1]
	ny = np.arange(nb, ne+1)
	y = overlap_save(x, h, Q)
	return y, ny

if __name__ == '__main__':

	nh = np.arange(0, 10)
	h = 1 - np.absolute((nh - 5.0)/5)

	nx = np.arange(-250, 251)
	x = 10*(1 - np.absolute(nx)/250.0)

	y1, ny1 = conv_m(x, nx, h, nh)
	y2, ny2 = conv_fft_m(x, nx, h, nh)

	Q = 64
	y3, ny3 = overlap_add_m(x, nx, h, nh, Q)
	y4, ny4 = overlap_save_m(x, nx, h, nh, Q)

	np.testing.assert_allclose(y1, y2, atol=1e-7)
	np.testing.assert_allclose(y1, y3, atol=1e-7)
	np.testing.assert_allclose(y1, y4, atol=1e-7)

	y = y1
	ny = ny1

	plt.figure()	
	plt.suptitle('Convolution: direct')
	plt.subplot(3, 1, 1)
	plt.plot(nx, x)
	plt.ylabel('x')
	plt.margins(.2, .2)
	plt.subplot(3, 1, 2)
	plt.plot(nh, h, '-o')
	plt.ylabel('h')
	plt.margins(.2, .2)
	plt.subplot(3, 1, 3)
	plt.plot(ny, y)
	plt.ylabel('y')
	plt.xlabel('n')
	plt.margins(.2, .2)
	plt.show()



