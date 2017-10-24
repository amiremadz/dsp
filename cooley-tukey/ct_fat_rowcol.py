#!/usr/bin/python
import numpy as np

# fat matrix implementation (e.x 2x16)
# first, row ffts
# then, column ffts

size = 64
num_rows = 4

# input is a vector of 1xsize
A = np.zeros((1, size))
A[0, 0] = 0
A[0, 1] = 1
A[0, 2] = 2
A[0, 3] = 3
A[0, 4] = 4

# ground-truth
Afft_gt = np.fft.fft(A)

# step 1: reshape input to 2x(size/2)
# 1st row is even indexes
# 2nd row is odd indexes
M = A.reshape((int(size/num_rows), num_rows))
M = np.transpose(M)

# step 2: calculate fft of rows
Mfftrow = np.fft.fft(M, axis = 1)

# step 3: multiply rows by twiddle factors
W = np.exp(-1j * 2 * np.pi/size)
twiddle = np.zeros(M.shape)

for idx in range(1, num_rows):
    twiddle[idx, :] = idx * np.arange(int(size/num_rows))

twiddle = W ** twiddle
H = np.multiply(Mfftrow , twiddle)

# step 4: calculate fft of cols
Hfft = np.fft.fft(H, axis = 0)

# step 5: transpose the matrix
#Hfft_t = np.transpose(Hfft)

# step 6: flatten the matrix contigously (along the rows)
Afft = np.reshape(Hfft, (1, size))

# print the result
Afft_gt_r   = Afft_gt.real.reshape((size, 1))
Afft_gt_im  = Afft_gt.imag.reshape((size, 1))
print("GT:")
print(np.hstack( (Afft_gt_r, Afft_gt_im) ))

Afft_r  = Afft.real.reshape((size, 1))
Afft_im = Afft.imag.reshape((size, 1))
print("\nCT:")
print(np.hstack( (Afft_r, Afft_im) ))

np.testing.assert_allclose(Afft, Afft_gt)
