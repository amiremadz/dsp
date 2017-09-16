function q = rotmatrix2quat(rotmat)
   
    tr = trace(rotmat);
    
    if(tr >= 0 )
    
        r = sqrt(1 + tr);
        s = .5/r;
        q = [.5*r,s*(rotmat(3,2) - rotmat(2,3)), s*(rotmat(1,3) - rotmat(3,1)), s*(rotmat(2,1) - rotmat(1,2))]';
    
    elseif( (rotmat(3,3) >= rotmat(2,2)) && (rotmat(3,3) >= rotmat(1,1)) )
    
        r = sqrt(1 - rotmat(1,1) - rotmat(2,2) + rotmat(3,3));
        s = .5/r;
        q = [s*(rotmat(2,1) - rotmat(1,2)), s*(rotmat(1,3) + rotmat(3,1)), s*(rotmat(3,2) + rotmat(2,3)), .5*r]';
    
    elseif( rotmat(2,2) >= rotmat(1,1) )
        
        r = sqrt(1 - rotmat(1,1) + rotmat(2,2) - rotmat(3,3));
        s = .5/r;
        q = [s*(rotmat(1,3) - rotmat(3,1)), s*(rotmat(2,1) + rotmat(1,2)), .5*r, s*(rotmat(3,2) + rotmat(2,3))]';
    
    else
        
        r = sqrt(1 + rotmat(1,1) - rotmat(2,2) - rotmat(3,3));
        s = .5/r;
        q = [s*(rotmat(3,2) - rotmat(2,3)), .5*r, s*(rotmat(2,1) + rotmat(1,2)), s*(rotmat(1,3) + rotmat(3,1))]';
    
    end
    
    if (q(1) < 0)
        q = -q;
    end
    
end    