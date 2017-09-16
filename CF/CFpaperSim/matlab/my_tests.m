clc
clear
close all

%%

global QHAT_NORM_TOL
global ACC_TOL

QHAT_NORM_TOL = 1e-12; 
ACC_TOL = 1e-12;

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




%% test update_Qy 

clc;

mex = 1; %.9697
mey = 0; %.2443

m_lambda = 0;
m_QLTime = 3.0;
m_Kp = 5;      %2.20; 
m_Ti = 1.50;   %2.65; 
m_KpQuick = 10.0; 
m_TiQuick = 1.25;

dt = .02;

acc = [0,0,0]';
mag = [1,0,0]';

q_y = updateQy(acc,mag);
disp('Result:');
disp(q_y');
disp('Expectation:');
disp([1,0,0,0])
disp('-----------------------')

acc = [0.0,0.0,5.0]';
mag = [3.0,0.0,0.0]';

q_y = updateQy(acc,mag);
disp('Result:');
disp(q_y');
disp('Expectation:');
disp([1.0, 0.0, 0.0, 0.0])
disp('-----------------------')

acc = [-0.2, 0.4, 1.0]';
mag = [-1.2, 0.6, -0.7]';

q_y = updateQy(acc,mag);
disp('Result:');
disp(q_y');
disp('Expectation:');
disp([-0.261154630414682, -0.139805215990429, 0.154980763303808, 0.942461523671184])
disp('-----------------------')


mex = 0.5; %.9697
mey = 1.3; %.2443

acc = [1.97, -4.93, -2.18]';
mag = [0.65, -2.37, 1.14]';

q_y = updateQy(acc,mag);
disp('Result:');
disp(q_y');
disp('Expectation:');
disp([0.5031410611323102, -0.8289865209174649, 0.051999163938332, -0.2385927653754926])
disp('-----------------------')



%%  test update
clc

mex = 1; %.9697
mey = 0; %.2443

m_lambda = 1;
m_QLTime = 3.0;
m_Kp = 5.0;      %2.20; 
m_Ti = 1.50;   %2.65; 
m_KpQuick = 10.0; 
m_TiQuick = 1.25;

dt = .02;

bhat = [0.0,0.5,1.0]';
b_rhs = zeros(3,1);

qhat = [1,0,0,0]';
q_rhs = zeros(4,1);

gyro = [ 6.403921931759489e-01,  9.360723675810693e-01, 7.894952671157460e-01]';
acc  = [-4.102821582419913e-01,  7.575655021799962e-01, 6.712045437704806e+00]';
mag  = [-1.151522662792782e+00, -1.118054993770523e+00, 5.233922602069686e-01]';


update(dt,gyro,acc,mag);



format longEng

for itt = 1:500
   
    update(dt,gyro,acc,mag);
    
    if (itt==100) 
        disp('itt = 100');
        disp('qhat Result:')
        disp(qhat');
        disp('qhat Expectation:')
        disp([3.4292612121324739e-01,-1.9209071503758710e-02,8.8186908413074208e-02,9.3501644699232156e-01]);
        disp('bhat Result:')
        disp(bhat');
        disp('bhat Expectation:')
        disp([5.0366756023736658e-01,7.2184655689754496e-01,3.4812977832258141e-01]);
    
    elseif (itt == 200)
        disp('itt = 200');
        disp('qhat Result:')
        disp(qhat');
        disp('qhat Expectation:')
        disp([3.8226606451658535e-01,-8.6435175083959797e-03,6.8603975753226451e-02,9.2146157816532670e-01]);
        disp('bhat Result:')
        disp(bhat');
        disp('bhat Expectation:')
        disp([6.1223321502854988e-01,8.9189462536685826e-01,6.9850786079300486e-01]);
    
    elseif (itt == 300)
        disp('itt = 300');
        disp('qhat Result:')
        disp(qhat');
        disp('qhat Expectation:')
        disp([3.9026384986863527e-01,-6.4499730438504254e-03,6.4564403996416844e-02,9.1841382996448406e-01]);
        disp('bhat Result:')
        disp(bhat');
        disp('bhat Expectation:')
        disp([6.3458476919266138e-01,9.2696127681439977e-01,7.7073028932131382e-01]);
    
    elseif (itt == 400)
        disp('itt = 400');
        disp('qhat Result:')
        disp(qhat');
        disp('qhat Expectation:')
        disp([3.9190829854563736e-01,-5.9976183670213913e-03,6.3730744907061473e-02,9.1777464895178817e-01]);
        disp('bhat Result:')
        disp(bhat');
        disp('bhat Expectation:')
        disp([6.3919442338859822e-01,9.3419322300964502e-01,7.8562502731071371e-01]);
    
     elseif (itt == 500)
        disp('itt = 500');
        disp('qhat Result:')
        disp(qhat');
        disp('qhat Expectation:')
        disp([3.9224726363482920e-01,-5.9043191047627097e-03,6.3558774382524219e-02,9.1764236246257147e-01]);
        disp('bhat Result:')
        disp(bhat');
        disp('bhat Expectation:')
        disp([6.4014515495033797e-01,9.3568479682624373e-01,7.8869703594960638e-01]);
    
        
    end
    
    
end

format long g



%%


