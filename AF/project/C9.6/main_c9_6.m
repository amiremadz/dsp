clc
clear
clear  plotAllResults

close all


%%

mycolor = [.7 .1 .1;.1 .7 .1;.1 .1 .7;.2 .5 .2;.9 .1 .4;...
    .4 .1 .4;.3 .8 .2;.8 .1  .2;.5 .5 .5;.7 .7 .7];

rho = [1 0.99 0.95 0.92 0.90]';

mu = [0.001 0.002 0.005 0.008]';

Nx = 1*200;

sig_v = 1;

v = sig_v*randn(Nx,1);

a = [1 -1.2728 +0.81];

x = filter(1,a,v);

M = 2;

L = 200;

%% Theory

r = rlevinson([1 -1.2728 .81],1);
R = toeplitz(r);
lambdas = eig(R);
fprintf('Lambda values of R:\n')
disp(lambdas)
mumax = 1/max(lambdas);
fprintf('mu max: %.3f\n\n',mumax);

P0 = r(1);

EMSE = mu*(M+1)*P0;

fprintf('For mu:          [%.3f %.3f %.3f %.3f]\n',mu');
fprintf('EMSE Theory:     [%.3f %.3f %.3f %.3f]\n',EMSE');


%% Part (a): LMS

for jj = 1:length(mu)

    [Wlms{jj},myElms] = myLMSpredictor(x,M,mu(jj));
    
    Elms(:,jj) = myElms;
    
end
    

plotAllResults(Wlms,Elms,a,mu,'LMS')

%% RLS

[Wrls{1},Erls] = myRLSpredictor(x,M,rho(3));


plotAllResults(Wrls,Erls,a,rho(1),'RLS')


%% Learning curve
        
E2rlsrhomu = [];
E2lmsrhomu = [];

for ii = 1:length(rho)
    
   E2mean = generateE2curve(Nx,a,rho(ii),L,M,'RLS');
   E2rlsrhomu{ii} = E2mean;
   EMSErlsrho(ii,1) =  mean(E2mean(end-49:end)) ;
  
end



for ii = 1:length(mu)
    
   E2mean = generateE2curve(Nx,a,mu(ii),L,M,'LMS');
   E2lmsrhomu{ii} = E2mean;
   EMSElmsmu(ii,1) =  mean(E2mean(end-49:end)) ;

  
end

fprintf('EMSE Simulation: [%.3f %.3f %.3f %.3f]\n\n',EMSElmsmu');
fprintf('For rho:         [%.3f %.3f %.3f %.3f %.3f]\n',rho');
fprintf('RLS Simulation : [%.3f %.3f %.3f %.3f %.3f]\n',EMSErlsrho');


lgindx = 1;

figure
hold on;
ylabel('mean |e|^2')
xlabel('Iteration #')
for ii = 1:length(mu)
  
    plot(M+1:Nx,E2lmsrhomu{ii}.^2,'color',mycolor(lgindx,:),'linewidth',2)
    lgnde{lgindx} = sprintf('LMS mu = %.3f',mu(ii));
    lgindx = lgindx + 1;
    
end
for ii = 1:length(rho)
  
    plot(M+1:Nx,E2rlsrhomu{ii},'color',mycolor(lgindx,:),'linewidth',2)
    lgnde{lgindx} = sprintf('RLS rho = %.3f',rho(ii));

    lgindx = lgindx + 1;
    
end

box on
legend(lgnde)
ylim([0 50])    
    
break
    
%%  Part (e): Non Stationary  
    
    
    
a1 = [1 -1.2728 +0.81];
a2 = [1 0 +0.81];

N1 = 50;
N2 = 100;


[x1,zf1] = filter(1,a1,v(1:N1));    
[x2,zf2] = filter(1,a2,v(N1+1:N2),zf1);
x3 = filter(1,a1,v(N2+1:end),zf2);
x = [x1;x2;x3];

[WlmsNS,myElmsNS] = myLMSpredictor(x,M,mu(4));
[WrlsNS,myErlsNS] = myRLSpredictor(x,M,rho(5));  

figure
subplot(211)
hold on
plot([1 N1 N1+1 N2 N2+1 Nx],-[a1(2) a1(2) a2(2) a2(2) a1(2) a1(2)],'k--','linewidth',2)
plot([1 Nx],-[a1(3) a1(3)],'k--','linewidth',2)
plot(WrlsNS(:,1),'color',mycolor(1,:),'linewidth',2)
plot(WrlsNS(:,2),'color',mycolor(2,:),'linewidth',2)
legend('w(1)','w(2)','RLS w(1)','RLS w(2)')
xlabel('Iteration #')
box on
subplot(212)
hold on
plot([1 N1 N1+1 N2 N2+1 Nx],-[a1(2) a1(2) a2(2) a2(2) a1(2) a1(2)],'k--','linewidth',2)
plot([1 Nx],-[a1(3) a1(3)],'k--','linewidth',2)
plot(WlmsNS(:,1),'color',mycolor(1,:),'linewidth',2)
plot(WlmsNS(:,2),'color',mycolor(2,:),'linewidth',2)
legend('w(1)','w(2)','LMS w(1)','LMS w(2)')
xlabel('Iteration #')
box on




%%  Part (e): Non Stationary  

[x1,zf1] = filter(1,a1,v(1:100));    
[x2,zf2] = filter(1,a2,v(101:200),zf1);
x = [x1;x2];
    
[WlmsNS,myElmsNS] = myLMSpredictor(x,M,mu(4));
[WrlsNS,myErlsNS] = myRLSpredictor(x,M,rho(5));


figure
subplot(211)
hold on
plot(1+[0 99 100 Nx-1],[-a1(2) -a1(2) -a2(2) -a2(2)],'k--','linewidth',2)
plot(1+[0 Nx-1],[-a1(3) -a1(3)],'k--','linewidth',2)
plot(WrlsNS(:,1),'color',mycolor(1,:),'linewidth',2)
plot(WrlsNS(:,2),'color',mycolor(2,:),'linewidth',2)
legend('w(1)','w(2)','RLS w(1)','RLS w(2)')
xlabel('Iteration #')
box on    

subplot(212)
hold on
plot(1+[0 99 100 Nx-1],[-a1(2) -a1(2) -a2(2) -a2(2)],'k--','linewidth',2)
plot(1+[0 Nx-1],[-a1(3) -a1(3)],'k--','linewidth',2)
plot(WlmsNS(:,1),'color',mycolor(1,:),'linewidth',2)
plot(WlmsNS(:,2),'color',mycolor(2,:),'linewidth',2)
legend('w(1)','w(2)','LMS w(1)','LMS w(2)')
xlabel('Iteration #')
box on    



%%    
    
    
    
    
    







