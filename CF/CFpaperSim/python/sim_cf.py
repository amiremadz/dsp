from __future__ import division

from utils import *
import pandas as pd
from matplotlib import pyplot as plt
import config as cfg
import os


if __name__ == "__main__":
    
    os.system("cls")
    plt.close("all")

    #%%

    data_path = "C:\\Users\\aemadzadeh\\Documents\\Projects\\SensorFusion\\CFpaperSim\\data\\"
    file_name = "IdealTestInputData.csv"
    #file_name = "all_data_QL_vikas.csv"

    data_all = pd.read_csv(data_path+file_name)


    data_all[["Ax","Ay"]] = data_all[["Ay","Ax"]]
    data_all["Ay"] = -data_all["Ay"]


    #data_all["Mx"] = (android_all["My"] + 30.0)
    #data_all["My"] = -(android_all["Mx"] + 53.0)
    #data_all["Mz"] = (android_all["Mz"] + 20.0)


    data_all[["Mx","My"]] = data_all[["My","Mx"]]
    data_all["My"] = -data_all["My"]

   
    data_all[["Gx","Gy"]] = data_all[["Gy","Gx"]]
    data_all["Gy"] = -data_all["Gy"]

   
    data_acc = data_all.iloc[:,0:3]
    data_mag = data_all.iloc[:,3:6]
    data_gyr = data_all.iloc[:,6:9]
    qhat_ref = data_all.iloc[:,10:15]

    num_smpls = data_all.shape[0]
    
    data_all.head()
    
    #%%
    
    cfg.init()
    
    
    sim_qhat = pd.DataFrame(columns = ["w","x","y","z"])
    
    for itt in range(num_smpls):
        acc = data_acc.iloc[itt,:].reshape(3,1)
        mag = data_mag.iloc[itt,:].reshape(3,1)
        gyro = data_gyr.iloc[itt,:].reshape(3,1)
        
        update(cfg.dt, gyro, acc, mag)
    
        sim_qhat.loc[itt] = cfg.qhat.flatten()
        
    print sim_qhat.head()   
    
    #%%
    
    fig_w,axes_w = plt.subplots(1,1)
    qhat_ref.ix[:,0].plot(ax = axes_w,color='k', linewidth=2.0)
    sim_qhat.ix[:,0].plot(ax = axes_w,color='r')
    axes_w.legend(["Reference","Simulaton"],loc = "lower right", fancybox=True, title='Amir!')
    axes_w.set_xlabel("Time index")
    axes_w.set_ylabel(r"$w=\cos(\zeta/2)$")
    axes_w.set_title("Rotation vector", color=(.5,.5,0))
    axes_w.grid("on")
    axes_w.get_legend().get_title().set_color((0,.5,.8))
    #savefig('R4Q3_xy.png', bbox_inches='tight')



        
    fig_x,axes_x = plt.subplots(1,1)
    qhat_ref.ix[:,1].plot(ax = axes_x,color='k', linewidth=2.0)
    sim_qhat.ix[:,1].plot(ax = axes_x,color='r')
    axes_x.legend(["Reference","Simulaton"], fancybox=True)
    axes_x.set_xlabel("Time index")
    axes_x.set_ylabel(r"$x=E_x\sin(\zeta/2)$")
    axes_x.set_title("Rotation vector")
    axes_x.grid("on")
    
    fig_y,axes_y = plt.subplots(1,1)
    qhat_ref.ix[:,2].plot(ax = axes_y,color='k', linewidth=2.0)
    sim_qhat.ix[:,2].plot(ax = axes_y,color='r')
    axes_y.legend(["Reference","Simulaton"],loc = "lower right", fancybox=True)
    axes_y.set_xlabel("Time index")
    axes_y.set_ylabel(r"$y=E_y\sin(\zeta/2)$")
    axes_y.set_title("Rotation vector")
    axes_y.grid("on")
    
    fig_z,axes_z = plt.subplots(1,1)
    qhat_ref.ix[:,3].plot(ax = axes_z,color='k', linewidth=2.0)
    sim_qhat.ix[:,3].plot(ax = axes_z,color='r')
    axes_z.legend(["Reference","Simulaton"], fancybox=True)
    axes_z.set_xlabel("Time index")
    axes_z.set_ylabel(r"$z=E_z\sin(\zeta/2)$")
    axes_z.set_title("Rotation vector")
    axes_z.grid("on")


    #%%

    fig_w,axes_w = plt.subplots(1,1)
    qhat_ref.ix[:,0].plot(ax = axes_w,color='k', linewidth=2.0, label = "Reference")
    sim_qhat.ix[:,0].plot(ax = axes_w,color='r', linewidth=2.0, label = "Simulaton")
    axes_w.legend(loc = "lower right", fancybox=True, title='Amir!',shadow=True)
    axes_w.set_xlabel("Time index")
    axes_w.set_ylabel("$w$")
    axes_w.set_title("Rotation vector", color=(.5,.5,0))
    axes_w.grid("on")
    axes_w.get_legend().get_title().set_color((0,.5,.8))
    
    #%%

















