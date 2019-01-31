function y = noncausalfilter(b,a,d,x)

x = x(:);

y = filter(b,a,[x;zeros(d,1)]);

y = y(end-length(x)+1:end);


y = y(:);

end
