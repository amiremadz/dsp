function init()


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

QHAT_NORM_TOL = 1e-12;
ACC_TOL = 1e-12;

mex = 1; %.9697
mey = 0; %.2443

m_lambda = 1;
m_QLTime = 3.0;
m_Kp = 5.0;      %2.20;
m_Ti = 1.50;   %2.65;
m_KpQuick = 10.0;
m_TiQuick = 1.25;

dt = .02;

bhat = [0.0,0.0,0.0]';%[0.0,0.5,1.0]';
b_rhs = [0.0,0.0,0.0]';

qhat = [1.0, 0.0, 0.0, 0.0]';
q_rhs = [0.0, 0.0, 0.0, 0.0]';


QUICK_LEARN = 0;
mot_det_thresh_cnt = 0;
mot_det_window_cnt  = 0;


end