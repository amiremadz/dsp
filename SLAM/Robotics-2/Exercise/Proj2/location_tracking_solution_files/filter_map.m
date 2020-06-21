% filter out all nodes that are not within the
% rectangle defined by the 2d vectors R1 (lower
% left corner) and R2 (upper right corner).


function map = filter_map(map,R1,R2)
  mapsize = size(map.x,2);
  printf('mapsize is %d.\n', mapsize)
  del = ones(1,mapsize);
  del(find(map.x<R1(1)))=0;
  del(find(map.y<R1(2)))=0;
  del(find(map.x>R2(1)))=0;
  del(find(map.y>R2(2)))=0;
  map.id = map.id(logical(del));
  map.x = map.x(logical(del));
  map.y = map.y(logical(del));
  map.n = map.n(logical(del));
  printf('New mapsize is %d.\n', size(map.x,2));
end
