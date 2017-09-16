# -*- coding: utf-8 -*-
"""
Created on Wed Apr 20 10:36:52 2016

@author: aemadzadeh
"""

import numpy as np

QHAT_NORM_TOL = 1e-12 
ACC_TOL = 1e-12

mex = 1 #.5 #.9697
mey = 0 #1.3 #.2443

m_lambda = 1
m_QLTime = 3.0
m_Kp = 5.0  #2.20 
m_Ti = 1.50 #2.65 
m_KpQuick = 10.0
m_TiQuick = 1.25

dt = .02


bhat = np.array([0.0, 0.0, 0.0]).reshape(3,1)
b_rhs = np.array([0.0, 0.0, 0.0]).reshape(3,1)
    
qhat = np.array([1.0, 0.0, 0.0, 0.0]).reshape(4,1)
q_rhs = np.array([0.0, 0.0, 0.0, 0.0]).reshape(4,1)


def init():
    global bhat, qhat
    global b_rhs, q_rhs
    
    bhat = np.array([0.0,0.0,0.0]).reshape(3,1)
    b_rhs = np.array([0.0,0.0,0.0]).reshape(3,1)
    
    qhat = np.array([1.0,0.0,0.0,0.0]).reshape(4,1)
    q_rhs = np.array([0.0,0.0,0.0,0.0]).reshape(4,1)

