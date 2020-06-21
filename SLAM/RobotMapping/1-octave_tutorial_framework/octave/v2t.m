function [M] = v2t(v)
R = [cos(v(3)), -sin(v(3)); sin(v(3)), cos(v(3))];
M = zeros(3, 3);
M(1:2, 1:2) = R;
M(1:2, 3) = v(1:2);
M(3, 3) = 1;
endfunction