function xUsfiltDs = myUpDownSampler(x,h,Us,Ds)


xUs = myexpander(x,Us);
xUsfilt = filter(h,1,xUs);
xUsfiltDs = mydownsampler(xUsfilt,Ds);



end