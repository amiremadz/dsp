% returns a struct array representing a hmm. The hmm 
% has one slice per waypoint in the track

function hmm = build_hmm(track)
  tracksize = size([track.x],2);
  hmm_slice.edge = [];
  hmm_slice.x = [];
  hmm_slice.xp = [];
  hmm_slice.Cp = [];
  hmm_slice.C = [];
  hmm_slice.obs.z = [];
  hmm_slice.date = [];
  hmm(tracksize)=hmm_slice;
  for i=1:tracksize
    hmm_slice.obs.z = [track.x(i) track.y(i)]';
    hmm_slice.date = track.date(i);
    hmm(i) = hmm_slice;
  end
end
