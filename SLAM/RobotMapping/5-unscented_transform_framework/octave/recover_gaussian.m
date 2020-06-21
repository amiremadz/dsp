function [mu, sigma] = recover_gaussian(sigma_points, w_m, w_c)
% This function computes the recovered Gaussian distribution (mu and sigma)
% given the sigma points (size: nx2n+1) and their weights w_m and w_c:
% w_m = [w_m_0, ..., w_m_2n], w_c = [w_c_0, ..., w_c_2n].
% The weight vectors are each 1x2n+1 in size,
% where n is the dimensionality of the distribution.

% Try to vectorize your operations as much as possible

n = size(sigma_points, 1);

% TODO: compute mu
mu = sigma_points * w_m';

%{
mu = zeros(n,1);
for i = 1:2 * n + 1
    mu = mu + w_m(1,i) * sigma_points(:,i);
endfor
%}

% TODO: compute sigma
e = sigma_points - repmat(mu, 1, 2 * n + 1);
sigma = e * diag(w_c) * e';

%{
sigma = zeros(n, n);
for i = 1:2 * n + 1
  sigma = sigma + w_c(i) * e(:, i) * e(:, i)';
endfor
%}

end
