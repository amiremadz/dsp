function [W,E] = myRLSpredictor(x,M,rho)


Nx = length(x);
w = zeros(M,1);
W = zeros(Nx,M);


E = [];

Rinv = 1e6*eye(M);

for ii = M+1:Nx
    
    Xbar = x(ii-1:-1:ii-M,1);
    y = w'*Xbar;
    d = x(ii);
    e = d - y;
    
    Zbar = Rinv*Xbar;
    q = Xbar'*Zbar;
    v = 1/(rho+q);
    
    Zbart = v*Zbar;
    
    w = w + e*Zbart;
    
    Rinv = ( Rinv - Zbart*Zbar' )/rho;
    
    E = [E;e];
    W(ii,:) = w';
    
end


























end