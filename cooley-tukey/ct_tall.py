#!/usr/bin/python
import numpy as np

# tall implememtation (16x2)

size = 32

# input is a vector of 1xsize
A = np.zeros((1, size))
A[0, 0] = 1
A[0, 1] = 1
A[0, 9] = 5

# ground-truth
Afft_gt = np.fft.fft(A)

# step 1: resahep input to (size/2)x2
M = A.reshape((int(size/2), 2))

# step 2: calculate fft of columns
Mfftcol = np.fft.fft(M, axis = 0)

# step 3: multilpy by twiddle factors
W = np.exp(-1j * 2 * np.pi/size)
twiddle = np.zeros(M.shape)
twiddle[:, 1] = np.arange(size/2)
twiddle = W ** twiddle
H = np.multiply(Mfftcol, twiddle)

# step 4: calculate fft of rows
Hfft = np.fft.fft(H, axis = 1)

# step 5: transpose the matrix
Hfft_t = np.transpose(Hfft)

# Note: order of fft and transpose can be changed
#Ht = np.transpose(H)
#Htfft = np.fft.fft(Ht, axis = 0)

# step 6: flatten the matrix contiguously(along the rows)
Afft = np.reshape(Hfft_t, (1, size))

# print the result
Afft_gt_r   = Afft_gt.real.reshape((size, 1))
Afft_gt_im = Afft_gt.imag.reshape((size, 1))
print("GT:")
print(np.hstack( (Afft_gt_r, Afft_gt_im) ))

Afft_r  = Afft.real.reshape((size, 1))
Afft_im = Afft.imag.reshape((size, 1))
print("\nCT:")
print(np.hstack( (Afft_r, Afft_im) ))

np.testing.assert_allclose(Afft, Afft_gt)
