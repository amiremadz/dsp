% detect the nearest point on any edge in the map 
% for a given point p


% hint for implementation:
% one possible algorithm for the distance calculation between
% a point and one edge:
% 
% let p = (x,y) be the point of interest
% - let p1,p2 be the coordinates of the nodes which define the edge,
%   so that p1 is nearer to p than p2
%   (if p1 and p2 are in equal distance from p, it doesn't matter)
% - define v1 = p2-p1, v2 = p1-p, normalize them
% - calculate the angle phi between v1 and v2
% - if phi is smaller than or equal to 90 deg, set d = |p1-p|
% - if phi is greater than 90 deg, set d = sin(pi-phi)*|p1-p|
%
% what remains now to do is to calculate the acutal coordinates
% of the nearest point...

%input
%  map:  struct containing the street map data (see exercise sheet for description)
%  p:    2D point

% output
% N: the coordinates of the nearest point on any edge
% ids: The node ids that define the nearest edge


function [N, ids] = get_nearest_edge(map,p)
  DISTANCE_THRESHOLD = 200;
  PLOT = 1;
  m = [];
  assert(size(p)==[2 1])
  % loop through all nodes
  d_min = 1e10;
  for i = 1:size(map.id,2)
    node1 = [map.x(i) map.y(i)]';
    % TODO: if the node is too far away, skip the test
     
    n = map.n{i}; % get neighbour ids
    % loop through neighbors
    for j = 1:size(n,1)
      n_index = find(map.id==n(j)); % get neighbour index
      if isempty(n_index) % check if the neighbour node is in the map
        continue
      end
      node2 = [map.x(n_index) map.y(n_index)]'; % get neighbour coords
      % TODO: get nearest point on edge
      
      if(PLOT)
        hold on;
        line([p(1) N(1)],[p(2) N(2)],'color','g');
      end
    end
  end
end