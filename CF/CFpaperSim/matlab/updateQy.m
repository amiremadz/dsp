function q_y = updateQy(acc,mag)
    
    global ACC_TOL
    global mex
    global mey

    R_y = zeros(3,3);
    accmag = norm(acc);
    
    if(accmag < ACC_TOL)
        disp('ACC_TOL');
        q_y = [1,0,0,0]';
    else
        R_y(:,3) = acc/accmag;
        
        dot = mag'*R_y(:,3);
        mhat = mag - dot*R_y(:,3);
        
        uhat = cross(mhat,R_y(:,3));
        
        xtilde = mex*mhat + mey*uhat;
        ytilde = mey*mhat - mex*uhat;
        
        BxG = xtilde/norm(xtilde);
        ByG = ytilde/norm(ytilde);
        
        R_y(:,1) = BxG;
        R_y(:,2) = ByG;
        
        R_y = R_y';    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Check me!
        
%         q_y = QuatFromRotmat(R_y);
        q_y = rotmatrix2quat(R_y);
        
    end
   
end    