% Computes the total error of the graph
function Fx = compute_global_error(g)

Fx = 0;

% Loop over all edges
for eid = 1:length(g.edges)
  edge = g.edges(eid);

  % pose-pose constraint
  if (strcmp(edge.type, 'P') != 0)

    x1 = v2t(g.x(edge.fromIdx:edge.fromIdx + 2));  % the first robot pose
    x2 = v2t(g.x(edge.toIdx:edge.toIdx + 2));      % the second robot pose

    %TODO compute the error of the constraint and add it to Fx.
    % Use edge.measurement and edge.information to access the
    % measurement and the information matrix respectively.
    %    del = [x2(1) - x1(1); x2(2) - x1(2)];
    %    q = del' * del;
    %    zCap = [sqrt(q); normalize_angle(atan2(del(2), del(1)) - x1(3))];
    %    err_tmp = edge.measurement - zCap;
    Z = v2t(edge.measurement);
    e = t2v(Z \ (x1 \ x2));
    Fx += e' * edge.information * e;
    
  % pose-landmark constraint
  elseif (strcmp(edge.type, 'L') != 0)
    x = g.x(edge.fromIdx:edge.fromIdx + 2);  % the robot pose
    l = g.x(edge.toIdx:edge.toIdx +1 );      % the landmark

    %TODO compute the error of the constraint and add it to Fx.
    % Use edge.measurement and edge.information to access the
    % measurement and the information matrix respectively.
    % z: edge.measurement 2x1 vector (x,y) of the measurement, the position of the landmark in
    % the coordinate frame of the robot given by the vector x
    X = v2t(x);
    R = X(1:2, 1:2);
    t = X(1:2, 3);
    z = edge.measurement;
    e = R' * (l - t) - z;
    Fx += e' * edge.information * e;
    
    %{
    L = v2t([l; 0]);
    Z = v2t(edge.measurement);
    e = t2v(Z \ (x \ L));
    e = e(1:2);
    Fx += e' * edge.information * e;
    %}
    
  end

end
