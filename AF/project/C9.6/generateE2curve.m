function E2mean = generateE2curve(Nx,a,param,L,M,af)

EAll = [];


for kk = 1:L
    
    v = 1*randn(Nx,1);
    x = filter(1,a,v);
    
    switch af
        
        case 'RLS'
            [~,myE] = myRLSpredictor(x,M,param);
        case 'LMS'
            [~,myE] = myLMSpredictor(x,M,param);
            
    end
    
    EAll = [EAll;myE'];
    
end


E2mean = mean(EAll.^2);

E2mean = E2mean(:);



end