function update(dt, gyro, acc, mag)
    
    global QHAT_NORM_TOL
    global m_lambda
    global bhat
    global b_rhs
    global qhat
    global q_rhs
    global m_KpQuick
    global m_TiQuick
    global m_Kp
    global m_Ti
    global m_QLTime 
    global QUICK_LEARN
    
    global mot_det_thresh_cnt;
    global mot_det_window_cnt;
    
   
    
    if(QUICK_LEARN)
        
        ACC_ERR_THRESH_VAL   = 0.01;
        ACC_ERR_THRESH_COUNT = 3.0;
        ACC_ERR_WINDOW_COUNT = 5.0;
        QL_TIME_CONSTANT     = 6.0;
        QL_LAMBDA_LOW        = 0.2;
        
        naccsq  = acc(1)^2 + acc(2)^2 + acc(3)^2;
        acc_sqsum_flt = avg_filter(naccsq);      
        acc_error =  abs(naccsq - acc_sqsum_flt);
        
        
        if (m_lambda < 1.0)
    
            m_lambda = m_lambda + dt/m_QLTime;
            
            if (m_lambda > 1.0)
                m_lambda = 1.0;
            end
            
            if ( (m_lambda > 2*QL_LAMBDA_LOW) && (acc_error > ACC_ERR_THRESH_VAL*acc_sqsum_flt) )
                       m_lambda = m_lambda / 2;
            end
            
       elseif (acc_error > ACC_ERR_THRESH_VAL*acc_sqsum_flt)
           
            mot_det_thresh_cnt = mot_det_thresh_cnt + 1;
           
            if (mot_det_thresh_cnt >= ACC_ERR_THRESH_COUNT)
                m_lambda = QL_LAMBDA_LOW;
                m_QLTime = QL_TIME_CONSTANT;
                mot_det_thresh_cnt = 0;
            else 
                mot_det_window_cnt = 0;
            end
            
       elseif (mot_det_thresh_cnt > 0)
          
          mot_det_window_cnt = mot_det_window_cnt + 1;
        
          if (mot_det_window_cnt > ACC_ERR_WINDOW_COUNT)
                mot_det_thresh_cnt = 0;
          end
          
       end
            
    else
            
        if(m_lambda < 1.0)
            
            m_lambda = m_lambda + dt/m_QLTime;
            
            if(m_lambda < 0.0)
                m_lambda = 0.0;
            end
            
            if(m_lambda > 1.0)
                m_lambda = 1.0;
            end
            
        end
    
    end
    
    
    
    k_p = m_lambda*m_Kp + (1 - m_lambda)*m_KpQuick;
    Ti =  m_lambda*m_Ti + (1 - m_lambda)*m_TiQuick;
    k_i = k_p/Ti;
    
    q_y = updateQy(acc,mag);
    
    qtilde = quatMultiply(quatInv(qhat),q_y);
    Omega_e = 2*qtilde(1)*qtilde(2:end);

    b_rhs_old = b_rhs;
    b_rhs = -k_i*Omega_e;  
    bhat = bhat + 0.5*dt*(b_rhs + b_rhs_old);               

    Omega_y = gyro;
    Omega = Omega_y - bhat + k_p*Omega_e;
    
    q_rhs_old = q_rhs;
    q_rhs = 0.5*quatMultiply(qhat,[0;Omega]);
    qhat = qhat + 0.5*dt*(q_rhs + q_rhs_old);
    
    qhatmag = norm(qhat);

    if(qhatmag < QHAT_NORM_TOL)
        display('QHAT_NORM_TOL');
        reset_all(1);
    else
        qhat = (1.0/qhatmag)*qhat;
        
        if (qhat(1) < 0)
           qhat = -qhat;   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Check me!
        end
        
    end
    
end    













