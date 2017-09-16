# -*- coding: utf-8 -*-
"""
Created on Tue Apr 19 18:05:10 2016

@author: aemadzadeh
"""




from utils import *
import os


#%%


if __name__ == "__main__":
    
    os.system('cls')
    
    #%%    
    
    cfg.mex = 1
    cfg.mey = 0
    
    acc = np.array([0,0,0]).reshape(3,1)
    mag = np.array([1,0,0]).reshape(3,1)
    
    q_y = updateQy(acc,mag)
    print "Result:      ", q_y.T[0]
    print "Expectation: ", np.array([1.0,0.0,0.0,0.0])
    print "-----------------------"
    
    acc = np.array([0.0,0.0,5.0]).reshape(3,1)
    mag = np.array([3.0,0.0,0.0]).reshape(3,1)
    
    #%%
    
    cfg.mex = 1
    cfg.mey = 0
    
    q_y = updateQy(acc,mag)
    print "Result:      ", q_y.T[0]
    print "Expectation: ", np.array([1.0,0.0,0.0,0.0])
    print "-----------------------"
    

    acc = np.array([-0.2, 0.4, 1.0]).reshape(3,1)
    mag = np.array([-1.2, 0.6, -0.7]).reshape(3,1)
    
    q_y = updateQy(acc,mag)
    print "Result:      ", q_y.T[0]
    print "Expectation: ", np.array([-0.261154630414682, -0.139805215990429, 0.154980763303808, 0.942461523671184])
    print "-----------------------"

    #%%

    cfg.mex = 0.5
    cfg.mey = 1.3
    
    acc = np.array([1.97, -4.93, -2.18]).reshape(3,1)
    mag = np.array([0.65, -2.37, 1.14]).reshape(3,1)
    
    q_y = updateQy(acc,mag)
    print "Result:      ", q_y.T[0]
    print "Expectation: ", np.array([0.5031410611323102, -0.8289865209174649, 0.051999163938332, -0.2385927653754926])
    print "-----------------------"


    #%%

    cfg.bhat = np.array([0.0,0.5,1.0]).reshape(3,1)
    cfg.b_rhs = np.array([0.0,0.0,0.0]).reshape(3,1)
    
    cfg.qhat = np.array([1.0,0.0,0.0,0.0]).reshape(4,1)
    cfg.q_rhs = np.array([0.0,0.0,0.0,0.0]).reshape(4,1)

    cfg.mex = 1
    cfg.mey = 0

    gyro = np.array([6.403921931759489e-01,  9.360723675810693e-01, 7.894952671157460e-01]).reshape(3,1)
    acc = np.array([-4.102821582419913e-01,  7.575655021799962e-01, 6.712045437704806e+00]).reshape(3,1)
    mag = np.array([-1.151522662792782e+00, -1.118054993770523e+00, 5.233922602069686e-01]).reshape(3,1)

    
    for itt in range(500):

        update(cfg.dt,gyro,acc,mag)
        
        if(itt == 99):
            print "itt = 99"
            print "qhat Result:      ", cfg.qhat.T[0]
            print "qhat Expectation: ", np.array([3.4292612121324739e-01,-1.9209071503758710e-02,8.8186908413074208e-02,9.3501644699232156e-01])
            print "bhat Result:      ", cfg.bhat.T[0]
            print "bhat Expectation: ", np.array([5.0366756023736658e-01,7.2184655689754496e-01,3.4812977832258141e-01])
            print "-----------------------"


        if(itt == 199):
            print "itt = 199"
            print "qhat Result:      ", cfg.qhat.T[0]
            print "qhat Expectation: ", np.array([3.8226606451658535e-01,-8.6435175083959797e-03,6.8603975753226451e-02,9.2146157816532670e-01])
            print "bhat Result:      ", cfg.bhat.T[0]
            print "bhat Expectation: ", np.array([6.1223321502854988e-01,8.9189462536685826e-01,6.9850786079300486e-01])
            print "-----------------------"

        if(itt == 299):
            print "itt = 299"
            print "qhat Result:      ", cfg.qhat.T[0]
            print "qhat Expectation: ", np.array([3.9026384986863527e-01,-6.4499730438504254e-03,6.4564403996416844e-02,9.1841382996448406e-01])
            print "bhat Result:      ", cfg.bhat.T[0]
            print "bhat Expectation: ", np.array([6.3458476919266138e-01,9.2696127681439977e-01,7.7073028932131382e-01])
            print "-----------------------"

        if(itt == 399):
            print "itt = 399"
            print "qhat Result:      ", cfg.qhat.T[0]
            print "qhat Expectation: ", np.array([3.9190829854563736e-01,-5.9976183670213913e-03,6.3730744907061473e-02,9.1777464895178817e-01])
            print "bhat Result:      ", cfg.bhat.T[0]
            print "bhat Expectation: ", np.array([6.3919442338859822e-01,9.3419322300964502e-01,7.8562502731071371e-01])
            print "-----------------------"

        if(itt == 499):
            print "itt = 499"
            print "qhat Result:      ", cfg.qhat.T[0]
            print "qhat Expectation: ", np.array([3.9224726363482920e-01,-5.9043191047627097e-03,6.3558774382524219e-02,9.1764236246257147e-01])
            print "bhat Result:      ", cfg.bhat.T[0]
            print "bhat Expectation: ", np.array([6.4014515495033797e-01,9.3568479682624373e-01,7.8869703594960638e-01])
            print "-----------------------"







    #%%























