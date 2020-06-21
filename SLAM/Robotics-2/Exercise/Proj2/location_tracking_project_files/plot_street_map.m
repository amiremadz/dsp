% plots either the nodes (if edges = 0 or undefined)
% or the nodes and the edges of a street map
function plot_street_map(map, edges)
  if nargin == 1
    edges = 0;
  end
  hold on
  % plot nodes  
  printf('Plotting %d nodes...\n',size(map.x,2))
  X = [map.x];Y = [map.y];plot(X,Y,'d')
  % plot edges
  ed = 0;
  %line_x = [];
  %line_y = [];
  if edges
    for i = 1:size(map.x,2)  
      n = map.n{i};
      for j = 1:size(n,1)
        ind = find(map.id==n(j));
        if ind
          ed = ed+1;
          end_x = map.x(ind);
          end_y = map.y(ind);
          %line_x = [line_x map.x(i) end_x]
          %line_y = [line_y map.y(i) end_y]
          line([map.x(i) end_x],[map.y(i) end_y])
        end
      end
    end
  end
  printf('Plotted %d edges...\n',ed);
  %line(line_x, line_y);
end
