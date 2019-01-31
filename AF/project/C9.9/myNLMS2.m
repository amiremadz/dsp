function [Y,W,E] = myNLMS2(x,d,M,beta)

eps = 1e-4;

Nx = length(x);

w = zeros(M+1,1);
W = zeros(Nx,M+1);
E = zeros(Nx,1);
Y = zeros(Nx,1);

for ii = M+1:Nx
    
    Xbar = x(ii:-1:ii-M,1);
    y = w'*Xbar;
    e = d(ii) - y;
    w = w + 2*beta*e*Xbar/( eps + norm(Xbar) );
    W(ii,:) = w';
    E(ii,1) = e;
    Y(ii,1) = y;
    
end



end