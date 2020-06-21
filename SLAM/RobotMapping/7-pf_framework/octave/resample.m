% resample the set of particles.
% A particle has a probability proportional to its weight to get
% selected. A good option for such a resampling method is the so-called low
% variance sampling, Probabilistic Robotics pg. 109
function newParticles = resample(particles)

numParticles = length(particles);

w = [particles.weight];

% normalize the weight
w = w / sum(w);

% consider number of effective particles, to decide whether to resample or not
useNeff = false;
%useNeff = true;
if useNeff
  neff = 1. / sum(w .^ 2);
  neff
  if neff > 0.5 * numParticles
    newParticles = particles;
    for i = 1:numParticles
      newParticles(i).weight = w(i);
    end
    return;
  end
end

newParticles = struct;

% TODO: implement the low variance re-sampling
%{
r = unifrnd(0, 1 / numParticles);
c = w(1);
i = 1;
for (j = 1:numParticles)
  U = r + (j - 1) / numParticles;
  while (U > c)
    i += 1;
    c += w(i);
  endwhile
  disp(i);
  newParticles(j) = particles(i);
end
%}
% the cumulative sum

% initialize the step and the current position on the roulette wheel
index = floor(unifrnd(0, numParticles));
beta = 0;
mw = max(w);

% walk along the wheel to select the particles
for (j = 1:numParticles)
  beta += rand() * 2 * mw;
  while (beta > w(index))
    beta -= w(index);
    index = 1 + mod(index + 1, numParticles);
  endwhile
  disp(index);
  newParticles(j) = particles(index);
endfor

end
