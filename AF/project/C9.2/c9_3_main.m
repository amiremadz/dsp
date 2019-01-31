clc
clear 
close all

num_runs = 100;

%% Part (a)


Nx = 1000;
sig_x = 1;

gamma = 0.1;

x = sig_x*randn(Nx,1);

M = [4 5];      % M: Adaptive filter order

b = [1 1.8 0.81];

fprintf('Plant Coefficients:');
disp(b);

d = filter(b,1,x);

dtilde = d + gamma*randn(Nx,1);


mycolor = [.7 .1 .1;.1 .7 .1;.1 .1 .7;.2 .5 .2;.9 .1 .4;.4 .1 .9];

%% Part (a),(b)

beta = 0.1/2;

for ii = 1:length(M)
    
    [Wnlms,Enlms] = myNLMS(x,dtilde,M(ii),beta);
    
    WnlmsM{ii} = Wnlms;
    EnlmsM{ii} = Enlms;
    

end
    

for ii = 1:length(M)
   
    fprintf('AF NLMS w for M = %d: ',M(ii))
    myWnlms = WnlmsM{ii};
    disp(myWnlms(end,:));
    
end
    
    



for ii = 1:length(M)
    
    figure
    hold on

    for jj = 1:M(ii)+1
        
        myWnlms = WnlmsM{ii};
        
        plot(myWnlms(:,jj),'color',mycolor(jj,:),'linewidth',2)
        xlabel('Iteration #')
        box on
        title(['NLMS,', 'M = ',num2str(M(ii))]);
        
    end
    
    lgstr = [];

    for kk = 1:M(ii)+1
        
        lgstr{kk} = sprintf('w(%d)',kk);
        
    end
    
    legend(lgstr)

end
    

figure

for ii = 1:length(M)
    
    subplot(length(M),1,ii)
    
    plot(M(ii)+1:Nx,EnlmsM{ii},'linewidth',2,'color',mycolor(ii,:))
    xlabel('Iteration #')
    ylabel('e = d-y')
    title(sprintf('NLMS, M = %d',M(ii)))

end



%%














