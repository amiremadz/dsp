clc
clear 
close all


mycolor = [.7 .1 .1;.1 .7 .1;.1 .1 .7;.2 .5 .2;.9 .1 .4;.4 .1 .4;.4 .7 .4];


N = 1000;
n = 0:N-1;
sig = sin(0.051*pi*n);

sig = sig(:);

g = randn(N,1)';

v = filter([1 0 0.5],1,g);

v = v(:);

d = sig + v;

%% Part (a)

rv = xcorr(v,v)/N;

figure
plot(0:N-1,rv(N:end),'-o','markerface',[1 1 1])
xlabel('lag (samples)')
ylabel('R_v')
xlim([-200 N])

k0min = 4;
fprintf('Minimum k0 is %d samples.\n\n',k0min);


break
%% Part (b), (c)

k0 = [ 4 10 15 20 25]';
beta = 0.05;
M = [5 10 15 20]';


for ii = 1:length(k0)
    
    for jj = 1:length(M)
        
        xk0 = [zeros(k0(ii),1);d(1:end-k0(ii))];
        
        [Y{ii,jj},W{ii,jj},E{ii,jj}] = myNLMS2(xk0,sig,M(jj),beta);

    end
    
end
    
%% Part (b), (c)

for jj = 1:length(M)

    figure
    
    
    for ii = 1:length(k0)
        
        subplot(length(k0),1,ii)
        hold on
        
        if ii == 1
            title(sprintf('M = %d',M(jj)));
        end
        
        plot(n,sig,'linewidth',2)
        plot(n,Y{ii,jj},'-','color',mycolor(ii,:))
        
        legend('d',sprintf('k_0 = %d',k0(ii)))
        box on
        
    end
    
    xlabel('n')

end

break
    
%% Part (d): Wiener


for ii = 1:length(k0)
    
    for jj = 1:length(M)
        
        xk0 = [zeros(k0(ii),1);d(1:end-k0(ii))];
        
        rxx = xcorr(xk0,xk0)/N;
        rxx = rxx(N:N+M(jj));
        R = toeplitz(rxx);
        
        rxd = xcorr(xk0,d)/N;
        rxd = rxd(N:N+M(jj));
        
        ho{ii,jj} = R\rxd;

    end
    
end



%%  Part (d): Wiener



for ii = 1:length(k0)
    
    for jj = 1:length(M)

        fignum = 11;
        
        myW = W{ii,jj};
        myho = ho{ii,jj};
        
        for kk = 1:M(jj)+1
            
            figure(fignum)
            hold on
            plot([0 N-1],[myho(kk),myho(kk)]','linewidth',2)
            plot(n,myW(:,kk),'r')
            box on
            legend('Wiener','NLMS')
            xlabel('n')
            ylabel(sprintf('w( %d )',kk-1))
            title( sprintf( 'k_0 = %d, M = %d',k0(ii),M(jj) ) )
            
            fignum = fignum + 1;
            
        end
        
        pause;
        close(11:fignum-1);
        
        
    end
    
end



%%













