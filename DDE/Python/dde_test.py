# import pydelay and numpy and pylab
import numpy as np
from matplotlib import pyplot as plt
from pydelay import dde23

# define the equations
eqns = {
    'y1': 'y1(t - tau1)',
    'y2': 'y1(t - tau1) + y2(t - tau2)',
    'y3': 'y2',
  }

#define the parameters
params = {
    'tau1': 1,
    'tau2': .2
    }

# Initialise the solver
dde = dde23(eqns=eqns, params=params)

# set the simulation parameters
# (solve from t=0 to t=5 and limit the maximum step size to 1.0)
dde.set_sim_params(tfinal=5, dtmax=1.0)

# set the history of to the constant function 0.5 (using a python lambda function)
histfunc = {
    'y1': lambda t: 1,
    'y2': lambda t: 1,
    'y3': lambda t: 1
    }
dde.hist_from_funcs(histfunc, 51)

# run the simulator
dde.run()

# Make a plot of x(t) vs x(t-tau):
# Sample the solution twice with a stepsize of dt=0.1:

# once in the interval [515, 1000]
sol1 = dde.sample(0, 5.01, 0.01)
y1 = sol1['y1']
y2 = sol1['y2']
y3 = sol1['y3']

# and once between [500, 1000-15]
#sol2 = dde.sample(500, 1000-15, 0.1)
#x2 = sol2['x']

t = np.arange(0, 5.01 , 0.01) 

plt.plot(t, y1, label='y1')
plt.plot(t, y2, 'r', label = 'y2')
plt.plot(t, y3, 'y', label = 'y3')
plt.legend()
plt.grid()
plt.xlim([0, 5])
plt.xlabel('Time')
plt.ylabel('Solution y')
pl.show()
