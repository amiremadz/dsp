function [W,E] = myLMSpredictor(x,M,mu)


Nx = length(x);

w = zeros(M,1);
W = zeros(Nx,M);
E = [];

for ii = M+1:Nx
    
    Xbar = x(ii-1:-1:ii-M,1);
    y = w'*Xbar;

    d = x(ii);
    e = d - y;
    
    w = w + 2*mu*e*Xbar;
    
    W(ii,:) = w'; 
    E = [E;e];
    
end
    


end
