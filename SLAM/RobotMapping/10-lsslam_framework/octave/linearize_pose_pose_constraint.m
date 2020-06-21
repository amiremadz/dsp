% Compute the error of a pose-pose constraint
% x1 3x1 vector (x,y,theta) of the first robot pose
% x2 3x1 vector (x,y,theta) of the second robot pose
% z 3x1 vector (x,y,theta) of the measurement
%
% You may use the functions v2t() and t2v() to compute
% a Homogeneous matrix out of a (x, y, theta) vector
% for computing the error.
%
% Output
% e 3x1 error of the constraint
% A 3x3 Jacobian wrt x1
% B 3x3 Jacobian wrt x2
function [e, A, B] = linearize_pose_pose_constraint(x1, x2, z)

  % TODO compute the error and the Jacobians of the error
  X1 = v2t(x1);
  X2 = v2t(x2);
  Z = v2t(z);
  e = t2v(Z \ (X1 \ X2));

  Rz = Z(1:2, 1:2);
  R1 = X1(1:2, 1:2); 
  
  Rz1 = Rz' * R1';
  R1dot = [-sin(x1(3)), -cos(x1(3)); cos(x1(3)), -sin(x1(3))];
  Rz1dot = Rz' * R1dot';
  
  A = [-Rz1, Rz1dot * (x2(1:2) - x1(1:2)); zeros(1, 2), -1];
  B = [Rz1, zeros(2, 1); zeros(1, 2), 1];
    
end;