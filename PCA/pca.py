import numpy as np
from matplotlib import pyplot as plt

# 2D data
x1 = np.array([2.5, 0.5, 2.2, 1.9, 3.1, 2.3, 2.0, 1.0, 1.5, 1.2])
x2 = np.array([2.4, 0.7, 2.9, 2.2, 3.0, 2.7, 1.6, 1.1, 1.6, 0.9])

x1b = np.mean(x1)
x2b = np.mean(x2)

print(x1b, x2b)

# remove mean
x1p = x1 - x1b
x2p = x2 - x2b

print(x1p)
print(x2p)

X = np.row_stack((x1p, x2p))

# covariance matrix
Sx = X.dot(X.T)
print(Sx)

D, V = np.linalg.eig(Sx)

print(D)
print(V)

v0 = np.expand_dims(V[:, 0], axis=1)
v1 = np.expand_dims(V[:, 1], axis=1)

pts0 = np.column_stack((3 * v0, -3 * V[:, 0]))
pts1 = np.column_stack((3 * v1, -3 * V[:, 1]))

plt.figure()
plt.plot(x1p, x2p, "+")
plt.plot(pts0[0, :], pts0[1, :], label="v0")
plt.plot(pts1[0, :], pts1[1, :], label="v1")
plt.ylim([-2, 2])
plt.xlim([-2, 2])
plt.title('mean-adjusted data with eigenvectors overlayed')
plt.axis('equal')
plt.grid()
plt.legend()

# project onto eigen vectors
Y = V.T.dot(X)
print(Y)

plt.figure()
plt.plot(Y[1, :], Y[0, :] , '+')
plt.ylim([-2, 2])
plt.xlim([-2, 2])
plt.title('data transformed with 2 eigenvectors')
plt.grid()

# Reduce dumention and rotate back
Y1 = v1.dot(v1.T.dot(X))
print(Y1)

# svd
u, s, vh = np.linalg.svd(X, full_matrices=True)
smat = np.zeros((2, 10))
smat[0, 0] = s[0]

# reduce dimesion using svd
Y2 = np.dot(u, np.dot(smat, vh))
print(Y2)

plt.figure()
plt.plot(Y1[0, :], Y1[1, :], "+", label='eig')
plt.plot(Y2[0, :], Y2[1, :], "x", label='svd')
plt.plot(pts1[0, :], pts1[1, :], label="v1")
plt.ylim([-2, 2])
plt.xlim([-2, 2])
plt.title('original data restored using only a single eigenvector')
plt.axis('equal')
plt.grid()
plt.legend()

plt.show()
