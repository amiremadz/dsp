import numpy as np
from matplotlib import pyplot as plt 
from scipy.stats import norm

# center of all classes
m = np.array([5, 5])

# each class covariance matrix
cov1 = np.array([[5, -3], [-3, 3]])
cov2 = np.array([[4, 0], [0, 4]])
cov3 = np.array([[3.5, 2], [2, 2.5]])

b1 = np.array([-3, 7])
b2 = np.array([-2.5, -3.5])
b3 = np.array([7, 5])

# mean of each class
m1 = np.expand_dims(m + b1, axis=1)
m2 = np.expand_dims(m + b2, axis=1)
m3 = np.expand_dims(m + b3, axis=1)

# generating independent normal feature vectors using Box-Muller approach 
# generate 2 independet r.v. following uniform(0, 1) 
u1 = np.random.uniform(0, 1, 500)
u2 = np.random.uniform(0, 1, 500)

# generate feature vectors
x1norm = np.sqrt(-2 * np.log(u1)) * np.cos(2 * np.pi * u2)
x2norm = np.sqrt(-2 * np.log(u1)) * np.sin(2 * np.pi * u2)

x1norm = np.expand_dims(x1norm, 0)
x2norm = np.expand_dims(x2norm, 0)

X = np.row_stack((x1norm, x2norm))

# decompose covariance matrix
eval1, evec1 = np.linalg.eig(cov1) 
eval2, evec2 = np.linalg.eig(cov2) 
eval3, evec3 = np.linalg.eig(cov3) 

# generate normal data with given mean and covariance
D1 = np.diag(np.sqrt(eval1))
X1 = evec1.dot(D1).dot(X) + m1

D2 = np.diag(np.sqrt(eval2))
X2 = evec2.dot(D2).dot(X) + m2

D3 = np.diag(np.sqrt(eval3))
X3 = evec3.dot(D3).dot(X) + m3

## LDA

# class means
mu1 = np.mean(X1, axis=1, keepdims=True)
mu2 = np.mean(X2, axis=1, keepdims=True)
mu3 = np.mean(X3, axis=1, keepdims=True)

# overal mean
N1 = X1.shape[1]
N2 = X2.shape[1]
N3 = X3.shape[1]

N = N1 + N2 + N3

mu = (1 / N) * (N1 * mu1 + N2 * mu2 + N3 * mu3)

# class covariance matrices
S1 = np.cov(X1)
S2 = np.cov(X2)
S3 = np.cov(X3)

# within-class scatter matrix
Sw = S1 + S2 + S3

# between-class scatter matrix
Sb1 = N1 * (mu1 - mu).dot((mu1 - mu).T)
Sb2 = N2 * (mu2 - mu).dot((mu2 - mu).T)
Sb3 = N3 * (mu3 - mu).dot((mu3 - mu).T)

Sb = Sb1 + Sb2 + Sb3

# LDA projection
lda_matrix = np.linalg.inv(Sw).dot(Sb)

# eigen decompostion
eigval, eigvec = np.linalg.eig(lda_matrix)

print(eigval)

W0 = np.expand_dims(eigvec[:, 0], axis=1)
W1 = np.expand_dims(eigvec[:, 1], axis=1)

# project data samples 
X1ProjOnW0 = W0.T.dot(X1).T
X2ProjOnW0 = W0.T.dot(X2).T
X3ProjOnW0 = W0.T.dot(X3).T

X1ProjOnW1 = W1.T.dot(X1).T
X2ProjOnW1 = W1.T.dot(X2).T
X3ProjOnW1 = W1.T.dot(X3).T

# compute normal fit for visualization
# project onto w0
mu10, std10 = norm.fit(X1ProjOnW0)
mu20, std20 = norm.fit(X2ProjOnW0)
mu30, std30 = norm.fit(X3ProjOnW0)

x10min = np.min(X1ProjOnW0)
x20min = np.min(X2ProjOnW0)
x30min = np.min(X3ProjOnW0)

x10max = np.max(X1ProjOnW0)
x20max = np.max(X2ProjOnW0)
x30max = np.max(X3ProjOnW0)

x10 = np.linspace(x10min, x10max, N1)
x20 = np.linspace(x20min, x20max, N2)
x30 = np.linspace(x30min, x30max, N3)

pdf10 = norm.pdf(x10, mu10, std10)
pdf20 = norm.pdf(x20, mu20, std20)
pdf30 = norm.pdf(x30, mu30, std30)

# project onto w1
mu11, std11 = norm.fit(X1ProjOnW1)
mu21, std21 = norm.fit(X2ProjOnW1)
mu31, std31 = norm.fit(X3ProjOnW1)

x11min = np.min(X1ProjOnW1)
x21min = np.min(X2ProjOnW1)
x31min = np.min(X3ProjOnW1)

x11max = np.max(X1ProjOnW1)
x21max = np.max(X2ProjOnW1)
x31max = np.max(X3ProjOnW1)

x11 = np.linspace(x11min, x11max, N1)
x21 = np.linspace(x21min, x21max, N2)
x31 = np.linspace(x31min, x31max, N3)

pdf11 = norm.pdf(x11, mu11, std11)
pdf21 = norm.pdf(x21, mu21, std21)
pdf31 = norm.pdf(x31, mu31, std31)

# plot results

pts0 = np.column_stack((-5 * W0, 20 * W0))
pts1 = np.column_stack((-30 * W1, 5 * W1))

plt.figure()

plt.scatter(X1[0, :], X1[1, :], marker = 'o', facecolor='none', edgecolor='r', label='class 1')
plt.scatter(m1[0], m1[1], c='c', marker='o')

plt.scatter(X2[0, :], X2[1, :], marker = 'o', facecolor='none', edgecolor='g', label='class 2')
plt.scatter(m2[0], m2[1], c='m', marker='o')

plt.scatter(X3[0, :], X3[1, :], marker = 'o', facecolor='none', edgecolor='b', label='class 3')
plt.scatter(m3[0], m3[1], c='y', marker='o')

plt.plot(pts0[0, :], pts0[1, :], 'm', linewidth=2, label='$w_0$')
plt.plot(pts1[0, :], pts1[1, :], 'k', linewidth=2, label='$w_1$')

plt.scatter(mu[0], mu[1], c='maroon', marker='*', s=100)

plt.xlim([-15, 25])
plt.ylim([-15, 25])

plt.xlabel('$X_1$')
plt.ylabel('$X_2$')

plt.axis('equal')
plt.legend()
plt.grid()

plt.figure()

plt.plot(x10, pdf10, 'r', label='class 1')
plt.plot(x20, pdf20, 'g', label='class 2')
plt.plot(x30, pdf30, 'b', label='class 3')

plt.scatter(X1ProjOnW0, np.zeros(N1), c='r', marker='o')
plt.scatter(X2ProjOnW0, np.zeros(N2), c='g', marker='o')
plt.scatter(X3ProjOnW0, np.zeros(N3), c='b', marker='o')

plt.title('Projection onto $w_0$')

plt.xlabel('y')
plt.ylabel('$p(yi|w_0)$')

plt.legend()

plt.figure()

plt.plot(x11, pdf11, 'r', label='class 1')
plt.plot(x21, pdf21, 'g', label='class 2')
plt.plot(x31, pdf31, 'b', label='class 3')

plt.scatter(X1ProjOnW1, np.zeros(N1), c='r', marker='o')
plt.scatter(X2ProjOnW1, np.zeros(N2), c='g', marker='o')
plt.scatter(X3ProjOnW1, np.zeros(N3), c='b', marker='o')

plt.title('Projection onto $w_1$')

plt.xlabel('y')
plt.ylabel('$p(yi|w_11)$')

plt.legend()

plt.show()
