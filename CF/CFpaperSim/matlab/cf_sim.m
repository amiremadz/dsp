clc
clear
close all

addpath('C:\Users\aemadzadeh\Documents\Projects\SensorFusion\UoB\matlab_octave_rotations_lib-master\RotationsLib');

%%

global QHAT_NORM_TOL
global ACC_TOL

global mex
global mey

global m_lambda
global m_QLTime
global m_Kp
global m_Ti
global m_KpQuick
global m_TiQuick

global dt

global bhat
global b_rhs

global qhat
global q_rhs


global QUICK_LEARN
global mot_det_thresh_cnt
global mot_det_window_cnt

init();

LOG = 0;
ANDROID_INPUT = 1;
ANDROID_OUTPUT = 1;


%%

mypath = 'C:\Users\aemadzadeh\Documents\Projects\SensorFusion\CFpaperSim\data';
myfile = 'all_data_QL_vikas.txt';
result_path = 'C:\Users\aemadzadeh\Documents\Projects\SensorFusion\CFpaperSim\results';

data_all = csvread(fullfile(mypath,myfile),1);


%% Convert data from Andriod coordinate system to ENU 

if ANDROID_INPUT
    data_new = data_all;
    data_new(:,1) = data_all(:,2);
    data_new(:,2) = -data_all(:,1);
    data_new(:,4) = data_all(:,5);
    data_new(:,5) = -data_all(:,4);
    data_new(:,7) = data_all(:,8);
    data_new(:,8) = -data_all(:,7);
    data_all = data_new;
end

%%

if 0

    figure(1)
    plot(data_all(:,1:3),'linewidth',2)
    xlabel('Time index')
    ylabel('acc')
    legend('x','y','z')
    
    figure(2)
    plot(data_all(:,4:6),'linewidth',2)
    xlabel('Time index')
    ylabel('mag')
    legend('x','y','z')
    
    figure(3)
    plot(data_all(:,7:9),'linewidth',2)
    xlabel('Time index')
    ylabel('gyro')
    legend('x','y','z')
    
    
    figure(4)
    plot(data_all(:,11:14),'linewidth',2)
    xlabel('Time index')
    ylabel('Rv')
    legend('w','x','y','z')

end

%%


sz = size(data_all);
itt = sz(1);

qhat_all = [];

for ii = 1:itt
   
    mydata = data_all(ii,:);
    acc = mydata(1:3)';
    mag = mydata(4:6)';
    gyro = mydata(7:9)';
    
    update(dt, gyro, acc, mag);
    
    qhat_all = [qhat_all;qhat'];
    
end

if LOG
    fileID = fopen(fullfile(result_path,strcat('matlab_result_',myfile)),'w');
    fprintf(fileID,'%f %f %f %f\n',qhat_all');
    fclose(fileID);
end
    
%% Convert back quaternion from ENU to Android coordinate system

if ANDROID_OUTPUT
    qhat_android = qhat_all;
    
    qhat_android(:,2) = -qhat_all(:,3);
    qhat_android(:,3) = qhat_all(:,2);
    
    qhat_all = qhat_android;
end
    
%%

figure(5);
clf
hold on
plot(data_all(:,11),'k','linewidth',2)
plot(qhat_all(:,1),'r','linewidth',2)
xlabel('Time index')
ylabel('w')
legend('Reference','Simulation','Location','southeast')
box on
grid on

figure(6);
clf
hold on
plot(data_all(:,12),'k','linewidth',2)
plot(qhat_all(:,2),'r','linewidth',2)
xlabel('Time index')
ylabel('x')
legend('Reference','Simulation')
box on
grid on

figure(7);
clf
hold on
plot(data_all(:,13),'k','linewidth',2)
plot(qhat_all(:,3),'r','linewidth',2)
xlabel('Time index')
ylabel('y')
legend('Reference','Simulation','Location','southeast')
box on
grid on

figure(8);
clf
hold on
plot(data_all(:,14),'k','linewidth',2)
plot(qhat_all(:,4),'r','linewidth',2)
xlabel('Time index')
ylabel('z')
legend('Reference','Simulation')
box on
grid on



%%
























