#!/usr//bin/python
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
#params = {
#    'a': 0.9738,
#    'f': 10 ** -5.675,
#    'b': 10 ** -5.561,
#    'h': 2.080,
#    'm': 0.0067,
#    'K': 0.8563,
#    }

#params = {
#    'a': 0.8604,
#    'f': 10 ** -4.9875,
#    'b': 10 ** -7.2310,
#    'h': 1.5501,
#    'K': 0.0944,
#    'm': 0.0003,
#   }

params = {
    'a': 0.8608,
    'f': 10 ** -4.940,
    'b': 10 ** -5.931,
    'h': 1.624,
    'K': 0.4314,
    'm': 0.0009,
   }

# Initialise the solver
dde = dde23(eqns=eqns, params=params)

tf = 25

# set the simulation parameters
# (solve from t=0 to t=5 and limit the maximum step size to 1.0)
dde.set_sim_params(tfinal=tf, dtmax=1.0)

# set the history of to the constant function 0.5 (using a python lambda function)
#histfunc = {
#    'S': lambda t: 10 ** 5.0803,
#    'V': lambda t: 10 ** 6.4301,
#    'I': lambda t: 0,
#    'R': lambda t: 0,
#    }

#histfunc = {
#    'S': lambda t: 10 ** 4.5428,
#    'V': lambda t: 10 ** 6.5282,
#    'I': lambda t: 0,
#    'R': lambda t: 0,
#    }

histfunc = {
    'S': lambda t: 10 ** 4.906,
    'V': lambda t: 10 ** 4.627,
    'I': lambda t: 0,
    'R': lambda t: 0,
    }



dde.hist_from_funcs(histfunc, 51)

# run the simulator
dde.run()

# Sample the solution twice with a stepsize of dt=0.1:

# once in the interval [515, 1000]
sol = dde.sample(0, tf + .1, 0.1)
S = np.log10(sol['S'])
R = np.log10(sol['R'])
I = np.log10(sol['I'])
V = np.log10(sol['V'])

t = np.arange(0, tf + .1 , 0.1) 

plt.figure()
plt.plot(t, S, label='S')
plt.plot(t, R, 'r', label = 'R')
plt.plot(t, I, 'y', label = 'I')
plt.plot(t, V, 'g', label = 'V')
plt.legend()
plt.grid()
plt.xlim([0, tf])
plt.xlabel('Time (h)')
plt.ylabel('Solution')
plt.savefig('phage_infection.png')

plt.figure()
plt.plot(t, S, label='S')
plt.legend()
plt.grid()
plt.xlim([0, tf])
plt.xlabel('Time (sec)')
plt.ylabel('Solution')
plt.savefig('S.png')


plt.figure()
plt.plot(t, V, label='V')
plt.legend()
plt.grid()
plt.xlim([0, tf])
plt.xlabel('Time (sec)')
plt.ylabel('Solution')
plt.savefig('V.png')


plt.figure()
plt.plot(t, I, label='I')
plt.legend()
plt.grid()
plt.xlim([0, tf])
plt.xlabel('Time (sec)')
plt.ylabel('Solution')
plt.savefig('I.png')


plt.figure()
plt.plot(t, R, label='R')
plt.legend()
plt.grid()
plt.xlim([0, tf])
plt.xlabel('Time (sec)')
plt.ylabel('Solution')
plt.savefig('R.png')





plt.show()
