clc
clear 
close all



h = [1 2 3];

x = [1 1 1 1 2 2 2 2 2 4 4 4 3 3 3 3 5 5 5];

y1 = conv(h,x)

y2 = overlap_add(h,x,4)'

y3 = overlap_save(h,x,4)'

y4 = overlap_save_amir(h,x,4)'





