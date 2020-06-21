%plots a filtered hmm

function [track, map] = plot_hmm(hmm, map)
  % get max values
  R1 = [min([hmm.x](1,:)) min([hmm.x](2,:))];
  R2 = [max([hmm.x](1,:)) max([hmm.x](2,:))];
  z = zeros(2,size(hmm,2));
  for i = 1:size(hmm,2)    
    z(:,i) = hmm(i).obs.z;
  end
  data_track.x = z(1,:);
  data_track.y = z(2,:);
  data_track.date = [hmm.date];
  filter_track.x = [hmm.x](1,:);
  filter_track.y = [hmm.x](2,:);
  filter_track.date = [hmm.date];
  hold on;
  plot(data_track.x,data_track.y,'rd');
  plot(filter_track.x,filter_track.y,'gd');
  plot_street_map(filter_map(map,R1,R2),1);
end
