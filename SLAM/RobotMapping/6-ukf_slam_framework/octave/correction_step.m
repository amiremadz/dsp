function [mu, sigma, map] = correction_step(mu, sigma, z, map);
% Updates the belief, i.e., mu and sigma after observing landmarks,
% and augments the map with newly observed landmarks.
% The employed sensor model measures the range and bearing of a landmark
% mu: state vector containing robot pose and poses of landmarks obeserved so far.
% Current robot pose = mu(1:3)
% Note that the landmark poses in mu are stacked in the order by which they were observed
% sigma: the covariance matrix of the system.
% z: struct array containing the landmark observations.
% Each observation z(i) has an id z(i).id, a range z(i).range, and a bearing z(i).bearing
% The vector 'map' contains the ids of all landmarks observed so far by the robot in the order
% by which they were observed, NOT in ascending id order.

% For computing sigma
global scale;

% Number of measurements in this time step
m = size(z, 2);

% Measurement noise
Q = 0.01 * eye(2);

for i = 1:m

	% If the landmark is observed for the first time:
	if (isempty(find(map == z(i).id)))
	    % Add new landmark to the map
      [mu, sigma, map] = add_landmark_to_map(mu, sigma, z(i), map, Q);
	    % The measurement has been incorporated so we quit the correction step
	    continue;
	endif

	% Compute sigma points from the predicted mean and covariance
  % This corresponds to line 6 on slide 32
	sigma_points = compute_sigma_points(mu, sigma);
  % Normalize!
	sigma_points(3, :) = normalize_angle(sigma_points(3, :));

	% Compute lambda
	n = length(mu);
	num_sig = size(sigma_points, 2);
	lambda = scale - n;

  % extract the current location of the landmark for each sigma point
  % Use this for computing an expected measurement, i.e., applying the h function
	landmarkIndex = find(map == (z(i).id));
	landmarkXs = sigma_points(2 * landmarkIndex + 2, :);
	landmarkYs = sigma_points(2 * landmarkIndex + 3, :);  
  
	% TODO: Compute z_points (2x2n+1), which consists of predicted measurements from all sigma points
  % This corresponds to line 7 on slide 32
  z_points = zeros(2, 2 * n + 1);
  delta = sigma_points(2 * landmarkIndex + 2:2 * landmarkIndex + 3, :) - sigma_points(1:2, :);
  z_points(1, :) = sqrt(delta(1, :) .^ 2 + delta(2, :) .^ 2);
  z_points(2, :) = normalize_angle(atan2(delta(2, :), delta(1, :)) - sigma_points(3, :));
  
  % setup the weight vector for mean and covariance
  wm = [lambda / scale, repmat(1 / (2 * scale), 1, 2 * n)];
  wc = wm;

	% TODO: Compute zm, line 8 on slide 32
	% zm is the recovered expected measurement mean from z_points.
	% It will be a 2x1 vector [expected_range; expected_bearing].
        % For computing the expected_bearing compute a weighted average by
        % summing the sines/cosines of the angle
  z_expected = zeros(2, 1);
  z_expected(1) = z_points(1, :) * wm';
  xbar = cos(z_points(2, :)) * wm';
  ybar = sin(z_points(2, :)) * wm';
  z_expected(2) = atan2(ybar, xbar);
  z_expected(2) = normalize_angle(z_expected(2));
  
	% TODO: Compute the innovation covariance matrix S (2x2), line 9 on slide 32
        % Remember to normalize the bearing after computing the difference
  diff_z = zeros(2, 2 * n + 1);      
  diff_z = z_points - repmat(z_expected, 1, 2 * n + 1);
  diff_z(2, :) = normalize_angle(diff_z(2, :));
  S = (repmat(wc, 2, 1) .* diff_z) * diff_z' + Q;
        
	% TODO: Compute Sigma_x_z, line 10 on slide 32
        % (which is equivalent to sigma times the Jacobian H transposed in EKF).
	% sigma_x_z is an nx2 matrix, where n is the current dimensionality of mu
        % Remember to normalize the bearing after computing the difference
  diff_x = zeros(n, 2 * n + 1);
  diff_x = sigma_points - repmat(mu, 1, 2 * n + 1);
  diff_x(3, :) = normalize_angle(diff_x(3, :));
  sigma_x_z = (repmat(wc, n, 1) .* diff_x) * diff_z';

	% TODO: Compute the Kalman gain, line 11 on slide 32
  K = sigma_x_z / S;

	% Get the actual measurement as a vector (for computing the difference to the observation)
	z_actual = [z(i).range; z(i).bearing];

	% TODO: Update mu and sigma, line 12 + 13 on slide 32
        % normalize the relative bearing
  z_diff = (z_actual - z_expected);
  z_diff(2) = normalize_angle(z_diff(2));
  mu = mu + K * z_diff;
  sigma = sigma - K * S * K';
        
	% TODO: Normalize the robot heading mu(3)
  mu(3) = normalize_angle(mu(3));

endfor

end