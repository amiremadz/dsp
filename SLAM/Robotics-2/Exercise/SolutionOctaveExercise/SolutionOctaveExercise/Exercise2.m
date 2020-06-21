% Exercise 2

%1.
a = [1 2 3 4 5]
a'
b = [0; 1; 2; 3; 4]
b'

%2.
r1 = 1:10
r2 = 1:0.2:10;
r3 = linspace(0,2*pi,100);

%3
%a*a
a.*a
a.^3
a*b
cross(a(1:3),b(1:3))
M = b*a

%4
whos

%5
M(2,:)
M(:,4)
M([1 3 5],3:end)

%6
rank(M) % the row space of M is spanned by linearly dependent vectors
det(M) % the determinant of a singular matrix is zero

%7
M(M>9)=-1

%8
size(a)
size(b)
size(r3)
size(M)
size(M,1)
size(M,2)
ones(size(M))
randn(size(M))

%9
A = [1 2 3;4 5 6;7 8 10]
b = ones(3,1)
x = A\b
r = b - A*x
