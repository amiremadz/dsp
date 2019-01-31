function plotAllResults(Wall,Eall,a,param,af)

persistent lgindx;
persistent lgtxt;

persistent lgindxe;
persistent lgtxte;



mycolor = [.7 .1 .1;.1 .7 .1;.1 .1 .7;.2 .5 .2;.9 .1 .4;.4 .1 .4];

Nparam = length(Wall);

M = size(Wall{1},2);

Nx = size(Wall{1},1);


if isempty(lgindx)
    
    lgindx = 1;
    
    for ii = 1:M
        
        figure(ii)
        hold on
        plot([1 Nx],[-a(ii+1) -a(ii+1)],'k--','linewidth',2)
        
    end
    
end


if isempty(lgindxe)
    
    lgindxe = 1;
    
end

for jj = 1:Nparam

    myW = Wall{jj};
    myE = Eall(:,jj);
    
    
    for ii = 1:M
        
        figure(ii)
        plot(myW(:,ii),'color',mycolor(lgindx,:),'linewidth',2)
        xlabel('Iteration #');
        
        switch af
            
            case 'LMS'
        
                lgtxt{ii,lgindx} = sprintf('%s w(%d) for mu = %.3f',af,ii,param(jj));
                
            case 'RLS'
                
                lgtxt{ii,lgindx} = sprintf('%s w(%d) for rho = %.3f',af,ii,param(jj));
                
        end
                
        box on;
        
    end
    
    lgindx = lgindx + 1;

end
    

for ii = 1:M
    
    figure(ii)
   
    switch ii
        
        case 1 
            legend(sprintf('w(%d)',ii),lgtxt{ii,:},'location','southeast')
        case 2
            legend(sprintf('w(%d)',ii),lgtxt{ii,:},'location','northeast')
    end
    
end


for ii = 1:Nparam

    figure(M+1)
    hold on 
    plot(M+1:Nx,Eall(:,ii).^2,'color',mycolor(lgindxe,:),'linewidth',2)
    xlabel('Interation #');
    box on;
    
    switch af
        
        case 'LMS'
            lgtxte{lgindxe} = sprintf('%s mu = %.3f',af,param(ii));
        case 'RLS'
            lgtxte{lgindxe} = sprintf('%s rho = %.3f',af,param(ii));
    end
    
    
            
    ylabel('|e|^2')
    
    lgindxe = lgindxe + 1;
    
    
end

legend(lgtxte);












end