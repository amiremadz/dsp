# -*- coding: utf-8 -*-
"""
Created on Tue Apr 19 18:01:17 2016

@author: aemadzadeh
"""

import numpy as np
import config as cfg




def reset_all(quickLearn):
    #global qhat, bhat
    #global b_rhs, q_rhs
    #global m_lambda
    
    cfg.qhat = np.array([1,0,0,0]).reshape(4,1)
    cfg.bhat = np.array([0,0,0]).reshape(3,1)
    cfg.b_rhs = np.array([0,0,0]).reshape(3,1)
    cfg.q_rhs = np.array([0,0,0,0]).reshape(4,1)
    
    if(quickLearn):
        cfg.m_lambda = 0
    else:
        cfg.m_lambda = 1
            

def rotmatrix2quat(rotmat):
    
    '''q = (w,x,y,z)'''
    
    tr = rotmat[0,0] + rotmat[1,1] + rotmat[2,2]
    
    if(tr >= 0 ):
    
        r = np.sqrt(1 + tr)
        s = .5/r
        q = np.array([.5*r,s*(rotmat[2,1] - rotmat[1,2]), s*(rotmat[0,2] - rotmat[2,0]), s*(rotmat[1,0] - rotmat[0,1])])
    
    elif( (rotmat[2,2] >= rotmat[1,1]) and (rotmat[2,2] >= rotmat[0,0]) ):
    
        r = np.sqrt(1 - rotmat[0,0] - rotmat[1,1] + rotmat[2,2])
        s = .5/r
        q = np.array([s*(rotmat[1,0] - rotmat[0,1]), s*(rotmat[0,2] + rotmat[2,0]), s*(rotmat[2,1] + rotmat[1,2]), .5*r])
    
    elif( rotmat[1,1] >= rotmat[0,0] ):
        
        r = np.sqrt(1 - rotmat[0,0] + rotmat[1,1] - rotmat[2,2])
        s = .5/r
        q = np.array([s*(rotmat[0,2] - rotmat[2,0]), s*(rotmat[1,0] + rotmat[0,1]), .5*r, s*(rotmat[2,1] + rotmat[1,2])])
    
    else:
        
        r = np.sqrt(1 + rotmat[0,0] - rotmat[1,1] - rotmat[2,2])
        s = .5/r
        q = np.array([s*(rotmat[2,1] - rotmat[1,2]), .5*r, s*(rotmat[1,0] + rotmat[0,1]), s*(rotmat[0,2] + rotmat[2,0])])
    
    if q[0] < 0:
        q = -q
    
    return q.reshape(4,1)



def quatInv(qhat):
    #return np.append(quat[0],-quat[1:])
    return np.row_stack([ qhat[0],-qhat[1:] ])
    
def quatMultiply(q,r):
    n0 = r[0]*q[0] - r[1]*q[1] - r[2]*q[2] - r[3]*q[3]
    n1 = r[0]*q[1] + r[1]*q[0] - r[2]*q[3] + r[3]*q[2]
    n2 = r[0]*q[2] + r[1]*q[3] + r[2]*q[0] - r[3]*q[1]
    n3 = r[0]*q[3] - r[1]*q[2] + r[2]*q[1] + r[3]*q[0]
    
    return np.array([n0,n1,n2,n3]).reshape(4,1)
    
 
    
def updateQy(acc,mag):
    
    #global ACC_TOL
    #global mex, mey
    
    R_y = np.array([[0.0,0.0,0.0],[0.0,0.0,0.0],[0.0,0.0,0.0]],dtype=float)
    accmag = np.sqrt(acc[0]**2 + acc[1]**2 + acc[2]**2)
    
    if(accmag < cfg.ACC_TOL):
        print "ACC_TOL"
        return np.array([1.0,0.0,0.0,0.0]).reshape(4,1)
    
    R_y[:,2] = acc.T/accmag
    
    dot = np.inner(mag.flatten(),R_y[:,2].flatten())
    mhat = mag - dot*R_y[:,2].reshape(3,1)
    
    uhat = np.cross(mhat.flatten(),R_y[:,2]).reshape(3,1)
    
    xtilde = cfg.mex*mhat + cfg.mey*uhat
    ytilde = cfg.mey*mhat - cfg.mex*uhat
    
    BxG = (1.0/np.sqrt(xtilde[0]**2 + xtilde[1]**2 + xtilde[2]**2))*xtilde
    ByG = (1.0/np.sqrt(ytilde[0]**2 + ytilde[1]**2 + ytilde[2]**2))*ytilde
    
    R_y[:,0] = BxG.T
    R_y[:,1] = ByG.T
    
    return rotmatrix2quat(R_y.T)
    

    
def update(dt, gyro, acc, mag):
    
#    global QHAT_NORM_TOL
#    global m_lambda
#    global bhat, b_rhs
#    global qhat, q_rhs
#    global m_KpQuick, m_TiQuick, m_QLTime
#    global m_Kp, m_Ti

    if(cfg.m_lambda < 1.0):
        
        cfg.m_lambda += float(dt)/cfg.m_QLTime

        if(cfg.m_lambda < 0.0):
            cfg.m_lambda = 0.0
        if(cfg.m_lambda > 1.0):
            cfg.m_lambda = 1.0
    
    k_p = cfg.m_lambda*cfg.m_Kp + (1 - cfg.m_lambda)*cfg.m_KpQuick
    Ti =  cfg.m_lambda*cfg.m_Ti + (1 - cfg.m_lambda)*cfg.m_TiQuick
    k_i = k_p/Ti
    
    q_y = updateQy(acc,mag)
    
    
    qtilde = quatMultiply(quatInv(cfg.qhat),q_y)
    Omega_e = 2*qtilde[0]*qtilde[1:]
   
    b_rhs_old = cfg.b_rhs
    cfg.b_rhs = -k_i*Omega_e  
    cfg.bhat += 0.5*dt*(cfg.b_rhs + b_rhs_old)               

    Omega_y = gyro
    Omega = Omega_y - cfg.bhat + k_p*Omega_e

    q_rhs_old = cfg.q_rhs
    cfg.q_rhs = 0.5*quatMultiply(cfg.qhat,np.row_stack([0,Omega]))
    cfg.qhat += 0.5*dt*(cfg.q_rhs + q_rhs_old)
    
    qhatmag = np.sqrt(cfg.qhat[0]**2 + cfg.qhat[1]**2 + cfg.qhat[2]**2 + cfg.qhat[3]**2)

    if(qhatmag < cfg.QHAT_NORM_TOL):
        print "QHAT_NORM_TOL"
        reset_all(True)
        return

    cfg.qhat = (1.0/qhatmag)*cfg.qhat
    
#    if(cfg.qhat[0] < 0):    
#        cfg.qhat = -cfg.qhat
    
    
    