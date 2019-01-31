function sigIndx = findRightSignal(phonesignal)

phonesignal = phonesignal(:);

L = length(phonesignal);

Nmin = 100;

eps = 1e-8;

sig01 = abs(phonesignal)>eps;

sig01diff = diff(sig01);


start_indx = find(sig01diff == -1) + 1;

end_indx = find(sig01diff == 1);



if end_indx(1)==1
   
   start_indx = [1;start_indx];
   
end

if start_indx(end)>end_indx(end)
   
    end_indx = [end_indx;L];
    
end
    

duration = end_indx - start_indx + 1;

start_indx = start_indx(duration >= Nmin);
end_indx = end_indx(duration >= Nmin);


sig_start_indx = end_indx + 1;

sig_end_indx = start_indx - 1;


if sig_end_indx(1)==0
    
    sig_end_indx = sig_end_indx(2:end);
    
end

if sig_start_indx(1)>sig_end_indx(1)
    
    sig_start_indx = [1;sig_start_indx];
    
end


if sig_start_indx(end)>L
    
    sig_start_indx = sig_start_indx(1:end-1);
    
end

if sig_start_indx(end)> sig_end_indx(end)
    
    sig_end_indx = [sig_end_indx;L];
    
end
    
sigIndx = [ sig_start_indx, sig_end_indx];





















end