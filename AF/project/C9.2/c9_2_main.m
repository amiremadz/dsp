clc
clear 
close all

num_runs = 100;

%% Part (a)


Nx = 1000;
sig_x = 1;

sig_n = 0;

x = sig_x*randn(Nx,1);

M = 4;      % M: Adaptive filter order

mu_max = 1/( (M+1)*sig_x^2 );

disp(['Mu max: ',num2str(mu_max)]);

mu = mu_max*[0.01 0.1 0.2]';

b = [1 1.8 0.81];

d = filter(b,1,x);



%% Part (b),(e)

for kk = 1:length(mu)
    
    [W,E] = myLMS(x,d,M,mu(kk));

    Wmu{kk} = W;
    Emu(:,kk) = E;

end



for ii = 1:length(mu)
    
    fprintf('AF LMS w for mu = %.3f: ',mu(ii))
    myW = Wmu{ii};
    disp(myW(end,:));
    
end


mycolor = [.7 .1 .1;.1 .7 .1;.1 .1 .7;.2 .5 .2;.9 .1 .4];

for ii = 1:length(mu)
    
     myW = Wmu{ii};
   
     for jj = 1:M+1
         
         figure(jj)
         hold on
         plot(myW(:,jj),'color',mycolor(ii,:),'linewidth',2)
         xlabel('Iteration #')
         ylabel(sprintf('w(%d)',jj))
         box on
         title('LMS');
         
     end
     
     
end



for jj = 1:M+1
    figure(jj)
    legend(sprintf('mu = %.3f',mu(1)),...
        sprintf('mu = %.3f',mu(2)),sprintf('mu = %.3f',mu(3)),...
        'location','southeast');
    title('LMS');
end




figure
plot(M+1:Nx,Emu,'linewidth',2)
legend(sprintf('mu = %.3f',mu(1)),...
        sprintf('mu = %.3f',mu(2)),sprintf('mu = %.3f',mu(3)),...
        'location','southeast');
xlabel('Iteration #')
ylabel('e = d-y')
title('LMS')


%% Part (c)

beta = 0.1/2;

[Wnlms,Enlms] = myLMS(x,d,M,beta);

fprintf('AF NLMS w for beta = %.3f: ',beta)
disp(Wnlms(end,:));

figure
hold on

for jj = 1:M+1
    
    plot(Wnlms(:,jj),'color',mycolor(jj,:),'linewidth',2)
    xlabel('Iteration #')
    box on
    title('NLMS');
    
end

lgstr = [];

for ii = 1:M+1

    lgstr{ii} = sprintf('w(%d)',ii);
    
end

legend(lgstr)


figure
plot(M+1:Nx,Enlms,'linewidth',2)
xlabel('Iteration #')
ylabel('e = d-y')
title('NLMS')



break


%% Part (d)

for kk = 1:length(mu)
    
    Eruns = [];
    
    for ii = 1:num_runs
        
        x = randn(Nx,1);
        d = filter(b,1,x);
        
        [~,E] = myLMS(x,d,M,mu(kk));
        
        Eruns = [Eruns;E'];
        
    end
    
    Erunsmu{kk} = Eruns;

end
    
figure
hold on
for ii = 1:length(mu)
    
    plot(M+1:Nx,mean(Erunsmu{ii}.^2),'color',mycolor(ii,:))
    
end
legend(sprintf('mu = %.3f',mu(1)),...
        sprintf('mu = %.3f',mu(2)),sprintf('mu = %.3f',mu(3)),...
        'location','northeast');
xlabel('Iteration #')
ylabel('Avg Squared Error')
box on


%% Part (d): Settling time computation


for ii = 1:length(mu)

    tau(ii) = 1/( 4*mu(ii)*sig_x^2 );
    
    fprintf('For mu = %.3f, theoretical settling time is %3d samples.\n',mu(ii),round(4*tau(ii)));

    e2mean = mean(Erunsmu{ii}.^2);
    e2max = max(e2mean);
    
    myindx = find(e2mean<0.1*e2max);
    
    fprintf('For mu = %.3f, after %3d iterations MSE falls to 10%% of its peak value.\n\n',mu(ii),myindx(1)+M);

end
    


%% Part (d): Jmin, EMSE computaion

Jmin = sig_n^2;

for ii = 1:length(mu)
    
    EMSE(ii) = mu(ii)*(M+1)*sig_x^2*Jmin;
    
    fprintf('For mu = %.3f, EMSE = %.3f.\n',mu(ii),EMSE(ii))

end

% close(1:5)

break

%% Simulation of Jmin and EMSE

N = length(x); % length(x) = length(d)

Rxx = xcorr(x,x)/N;
Rxd = xcorr(x,d)/N;
Rdd = xcorr(d,d)/N;

rdd0 = Rdd(N);
pbar = Rxd(N:N+M);

Jmin_sim = rdd0 - W(end,:)*pbar;

P0 = Rxx(N);

EMSE_sim = mu*Jmin*(M+1)*P0;



%%














