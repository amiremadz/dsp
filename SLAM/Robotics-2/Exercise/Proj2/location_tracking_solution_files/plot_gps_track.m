#plots a gps track in 2D
#input
#  track:  struct containing the gps track
#          (track is required to have the fields 'x','y' and 'date')

#optional input
#  map:    struct containing the street map data
#          (map is required to have the fields 'x','y','id' and 'n');
#          - x,y,id are vectors containing node coords and ids
#          - n is a cell array containing a vector with neighbour
#            node ids for each node
#  R1, R2: trackpoints defining a rectangle (the region to plot)
#  start, stop: start and stop indices for temporal filtering of the track
#  plot_format: format string to use for the track plot

# output
# track, map: the filtered datasets

function [track, map] = plot_gps_track(track, map, R1, R2, start, stop, plot_format)
  if nargin>=6
    track.x = track.x(start:stop);
    track.y = track.y(start:stop);
    track.date = track.date(start:stop);
  end
  if nargin==1
    plot(track.x,track.y,plot_format);
    return;
  end
  if nargin <= 6
    plot_format = 'rd';
  end
  if nargin >= 4
  track = filter_track(track,R1,R2);
  map = filter_map(map,R1,R2);
  end
  end
  THRESH = 100;
  tracksize = size([track.x],2);
  % filter outliers
  del = ones(1,tracksize);
  for i = 1:tracksize
    if i==1
      if (abs(track.x(1)-track.x(2)) > THRESH) || (abs(track.y(1)-track.y(2)) > THRESH)
        del(1) = 0;
      end
    else
      if (abs(track.x(i-1)-track.x(i)) > THRESH) || (abs(track.y(i-1)-track.y(i)) > THRESH)
        del(i-1) = 0;
      end
    end
  end
  track.x = track.x(logical(del));
  track.y = track.y(logical(del));
  printf('filtered out %d outliers\n',(tracksize-sum(del)))
  plot(track.x,track.y,plot_format)
  if nargin==1
    return;
  end
  plot_street_map(map,1);
end
