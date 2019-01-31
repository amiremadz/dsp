function [W,E] = myNLMS(x,d,M,beta)

Nx = length(x);

w = zeros(M+1,1);
W = zeros(Nx,M+1);
E = [];

for ii = M+1:Nx
    
    Xbar = x(ii:-1:ii-M,1);
    y = w'*Xbar;
    e = d(ii) - y;
    w = w + 2*beta*e*Xbar/norm(Xbar);
    W(ii,:) = w';
    E = [E;e];
    
end



end