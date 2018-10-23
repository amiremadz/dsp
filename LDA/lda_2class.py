import numpy as np
from matplotlib import pyplot as plt

# samples of each class (same length)
X1 = np.array([[4, 2], [2, 4], [2, 3], [3, 6], [4, 4]]).T
X2 = np.array([[9, 10], [6, 8], [9, 5], [8, 7], [10, 8]]).T

# class means
mu1 = np.mean(X1, axis=1, keepdims=True)
mu2 = np.mean(X2, axis=1, keepdims=True)

# covariance matrix of each class
S1 = np.cov(X1)
S2 = np.cov(X2)

# within-class scatter
Sw = S1 + S2

# between-class scatter
Sb = (mu1 - mu2).dot((mu1 - mu2).T)

# computing LDA projection
invSw = np.linalg.inv(Sw)
invSwxSb = invSw.dot(Sb)

# Finding eigen values/vectors
eigvals, eigvecs = np.linalg.eig(invSwxSb)

print("\neigen values: ",  eigvals)
print("\neigen vectors: ", eigvecs)

# optimal projection is one that give maximum eigenvalue
w0 = np.expand_dims(eigvecs[:, 0], axis=1)
w1 = np.expand_dims(eigvecs[:, 1], axis=1)

# or, directly
w = invSw.dot(mu1 - mu2)
print("\nscaled version of w0:", w/w0)

prj_X1_to_w0 = w0.dot(w0.T.dot(X1))
prj_X2_to_w0 = w0.dot(w0.T.dot(X2))

prj_X1_to_w1 = w1.dot(w1.T.dot(X1))
prj_X2_to_w1 = w1.dot(w1.T.dot(X2))

pts0 = np.column_stack((w0 * 0, w0 * 15)) 
pts1 = np.column_stack((w1 * 0, w1 * 15)) 

plt.figure()

plt.scatter(X1[:, 0], X1[:, 1], c='r', marker='o')
plt.scatter(X2[:, 0], X2[:, 1], c='b', marker='s')

plt.plot(pts0[0, :], pts0[1, :], c='g', label='$w_0$')
plt.plot(pts1[0, :], pts1[1, :], c='m', label='$w_1$')

plt.plot(prj_X1_to_w0[0, :], prj_X1_to_w0[1, :], c = 'r', marker='o', alpha=0.5)
plt.plot(prj_X2_to_w0[0, :], prj_X2_to_w0[1, :], c = 'b', marker='s', alpha=0.5)

plt.plot(prj_X1_to_w1[0, :], prj_X1_to_w1[1, :], c = 'r', marker='o', alpha=0.5)
plt.plot(prj_X2_to_w1[0, :], prj_X2_to_w1[1, :], c = 'b', marker='s', alpha=0.5)

plt.grid()
plt.xlim([-10, 15])
plt.ylim([0, 15])
plt.legend()
plt.show()
