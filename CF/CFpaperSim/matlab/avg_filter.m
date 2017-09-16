function y = avg_filter(x)

%second order low pass filter cutoff 2Hz

persistent prev_x
persistent prev_y
persistent prev_prev_x
persistent prev_prev_y

if isempty(prev_x)
   prev_x = 0; 
   prev_y = 0;
end

if isempty(prev_prev_x)
    prev_prev_x = 0;
    prev_prev_y = 0;
end

b0 = 9.4408411E-04;
b1 = 1.8881682E-03;
b2 = 9.4408411E-04;

a1 = -1.9112262E+00;
a2 = 9.1500257E-01;

y = b0*x;
y = y + b1*prev_x;
y = y + b2*prev_prev_x;
y = y - a1*prev_y;
y = y - a2*prev_prev_y;

prev_prev_x = prev_x;
prev_x = x;
prev_prev_y = prev_y;
prev_y = y;



end