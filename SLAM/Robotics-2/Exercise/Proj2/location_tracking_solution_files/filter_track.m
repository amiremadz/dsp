% filters a track either spatially (if R1 and R2 are 2D vectors
% defining a rectangle) or temporally (if R1 and R2
% are scalars that define start and stop indices)

function track = filter_track(track,R1,R2)
  tracksize = size(track.x,2);
  printf('filtering waypoints...\n')
  printf('Tracksize is %d.\n', tracksize)  
  if size(R1,1) == 2 || size(R1,2) == 2
    % filter spatially
    del = ones(1,tracksize);
    del(find(track.x<R1(1)))=0;
    del(find(track.y<R1(2)))=0;
    del(find(track.x>R2(1)))=0;
    del(find(track.y>R2(2)))=0;
    track.x = track.x(logical(del));
    track.y = track.y(logical(del));
    track.date = track.date(logical(del));
  else
    % filter temporally
    track.x = track.x(R1:R2);
    track.y = track.y(R1:R2);
    track.date = track.date(R1:R2);
  end
  printf('New tracksize is %d.\n', size(track.x,2))
  printf('done...\n')
end
