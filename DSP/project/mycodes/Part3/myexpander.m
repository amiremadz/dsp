function xe = myexpander(x,L)


xe = zeros(L*length(x),1);
xe(1:L:length(xe)) = x;





end