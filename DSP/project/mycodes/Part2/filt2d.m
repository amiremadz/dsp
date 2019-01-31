function y = filt2d(b,a,d,x)

M = size(x,1);
N = size(x,2);

z = [];
y = [];

for ii = 1:N
    
    z(:,ii) = noncausalfilter(b,a,d,x(:,ii));

end


for jj = 1:M
    
    y(jj,:) = noncausalfilter(b,a,d,z(jj,:));
    
end



end