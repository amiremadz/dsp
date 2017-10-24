#!/usr/bin/python

import numpy as np

size  = 32
A = np.zeros((size, size))
A[0,0] = 1
A[-1,0] = 1
print(A)
#A = np.random.randn(size, size)

Afft_gt = np.fft.fft2(A)

Afft_col = np.fft.fft(A, axis = 0)
Afft_1 = np.fft.fft(Afft_col, axis = 1)

Afft_row = np.fft.fft(A, axis = 1)
Afft_2 = np.fft.fft(Afft_row, axis = 0)

np.testing.assert_allclose(Afft_1, Afft_gt)
np.testing.assert_allclose(Afft_2, Afft_gt)

print(Afft_gt.real)
print(Afft_gt.imag)