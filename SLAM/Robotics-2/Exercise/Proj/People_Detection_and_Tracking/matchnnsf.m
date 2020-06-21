function [tracks,obs] = matchnnsf(tracks,obs,ALPHA)

ntracks = length(tracks);
nobs = length(obs);

% Compute distance matrix
D = zeros(ntracks,nobs);
for i = 1:ntracks,
  for j = 1:nobs,
    v = obs(j).z - tracks(i).zp;
    S = tracks(i).H * tracks(i).Cp * tracks(i).H' + obs(j).R;
    D(i,j) = v'*inv(S)*v;
    tracks(i).iobs = -1;
  end;
end;

% Iteratively find minimum
nmatch = 0;
terminated = false;
while ~terminated,
  dmin = min(min(D));
  [i,j] = find(D == dmin);
  if (dmin < Inf) && (dmin <= chi2invtable(ALPHA,length(obs(j).z))),
    tracks(i).status = 'matched';
    obs(j).status = 'matched';
    tracks(i).zp = tracks(i).zp;
    tracks(i).z = obs(j).z;
    tracks(i).R = obs(j).R;
    tracks(i).iobs = obs(j).id;
    nmatch = nmatch + 1;
    % Remove virtually row and column
    D(i,:) = Inf;
    D(:,j) = Inf;
  else
    terminated = true;
  end;
end;