# import pydelay and numpy and pylab
import numpy as np
from matplotlib import pyplot as plt
from pydelay import dde23

# define the equations
eqns = {
    'S': '(a - f) * S - b * S * V',
    'R': 'a * R + f * S',
    'I': 'b * S * V - b * S(t - K) * V(t - K)',
    'V': 'h * b * S(t - K) * V(t - K) - b * S * V - m * V',
  }

#define the parameters
params = {
    'a': 0.1,
    'f': 0.2,
    'b': 0.3,
    'h': 0.15,
    'm': 0.25,
    'K': 0.6
    }

# Initialise the solver
dde = dde23(eqns=eqns, params=params)

# set the simulation parameters
# (solve from t=0 to t=5 and limit the maximum step size to 1.0)
dde.set_sim_params(tfinal=5, dtmax=1.0)

# set the history of to the constant function 0.5 (using a python lambda function)
histfunc = {
    'S': lambda t: 8,
    'V': lambda t: 800,
    'I': lambda t: 0,
    'R': lambda t: 1,
    }
dde.hist_from_funcs(histfunc, 51)

# run the simulator
dde.run()

# Make a plot of x(t) vs x(t-tau):
# Sample the solution twice with a stepsize of dt=0.1:

# once in the interval [515, 1000]
sol = dde.sample(0, 5.01, 0.01)
S = sol['S']
R = sol['R']
I = sol['I']
V = sol['V']

t = np.arange(0, 5.01 , 0.01) 

plt.plot(t, S, label='S')
plt.plot(t, R, 'r', label = 'R')
plt.plot(t, I, 'y', label = 'I')
plt.plot(t, V, 'g', label = 'V')
plt.legend()
plt.grid()
plt.xlim([0, 5])
plt.xlabel('Time (sec)')
plt.ylabel('Solution')
plt.savefig('phage_infection.png')
plt.show()
