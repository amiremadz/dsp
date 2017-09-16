clc
close all


fileID_c = fopen('C:\Users\aemadzadeh\Documents\Projects\SensorFusion\CFpaperSim\results\c_result_all_data_QL_vikas.txt','r');
fileID_matlab = fopen('C:\Users\aemadzadeh\Documents\Projects\SensorFusion\CFpaperSim\results\matlab_result_all_data_QL_vikas.txt','r');


%%

q_c = fscanf(fileID_c,'%f %f %f %f',[4 inf]);
q_c = q_c';

q_matlab = fscanf(fileID_matlab,'%f %f %f %f',[4 inf]);
q_matlab = q_matlab';

fclose(fileID_c);
fclose(fileID_matlab);


%%

figure
hold on
plot(q_c(:,1),'k','linewidth',2)
plot(q_matlab(:,1),':r','linewidth',2)
xlabel('Time index')
ylabel('w')
legend('C','Matlab')
grid on

figure
hold on
plot(q_c(:,2),'k','linewidth',2)
plot(q_matlab(:,2),':r','linewidth',2)
xlabel('Time index')
ylabel('x')
legend('C','Matlab')
grid on

figure
hold on
plot(q_c(:,3),'k','linewidth',2)
plot(q_matlab(:,3),':r','linewidth',2)
xlabel('Time index')
ylabel('y')
legend('C','Matlab')
grid on


figure
hold on
plot(q_c(:,4),'k','linewidth',2)
plot(q_matlab(:,4),':r','linewidth',2)
xlabel('Time index')
ylabel('z')
legend('C','Matlab')
grid on



%%




