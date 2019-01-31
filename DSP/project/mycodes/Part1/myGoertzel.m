function dft_data = myGoertzel(sig,freq_indices)

sig = sig(:);

N = length(sig);

WN = exp(-2*pi*1i/N);

sig = [sig;0];
dft_data = [];

for jj = 1:length(freq_indices)
    
    k = freq_indices(jj) - 1;
    y = 0;
    
    for ii = 1:N+1
        
        y = WN^(-k)*y + sig(ii);
        
    end
    
    dft_data(jj) = y;

end


dft_data = dft_data(:);


end