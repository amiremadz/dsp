% calculates the track speed between each two adjacent waypoints
% and plots it over track index

function v = get_track_speed(track)
  v = [diff(track.x);diff(track.y)]./repmat(diff(track.date),2,1);
  v = sqrt(sum(v.^2));
  plot(v);
end
