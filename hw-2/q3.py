import numpy as np
from matplotlib import pyplot as plt


def down_sample(x, M, L_fft):
	y = x[::M]
	Y = np.fft.fft(y, L_fft)

	plt.figure()
	plt.suptitle('M = {}'.format(M))
	plt.subplot(2,2,1)
	plt.plot(n, x, '-o')
	plt.ylabel('x')
	plt.subplot(2,2,3)
	plt.plot(n[:y.shape[0]], y, '-o')
	plt.ylabel('y')
	plt.xlabel('n')
	plt.subplot(2,2,2)
	plt.stem(fn, np.abs(X), '-ko')
	plt.ylabel('|X|')
	plt.subplot(2,2,4)
	plt.stem(fn, np.abs(Y), '-ko')
	plt.ylabel('|Y|')
	plt.xlabel('Normalized freq (cycles per sample)')


if __name__ == '__main__':

	L = 128
	L_fft = L
	n = np.arange(0, L)
	f0 = 1.0/20
	x = np.cos(2*np.pi*f0*n)
	X = np.fft.fft(x, L_fft)
	fn = np.linspace(0, 1-1.0/L_fft, L_fft)

	M_list = [4, 8, 10, 20]

	for M in M_list:
		down_sample(x, M, L_fft) 

	plt.show()


