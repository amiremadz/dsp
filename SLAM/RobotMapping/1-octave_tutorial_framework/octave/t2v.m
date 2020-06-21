function [v] = t2v(M)
  v = zeros(3, 1);
  v(1:2) = M(1:2, 3);
  v(3) = atan2(M(2, 1), M(1, 1));
endfunction
