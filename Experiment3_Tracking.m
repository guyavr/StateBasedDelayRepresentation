clc
clear
close all

m2cm=100;

tlim=[0 2.5];
poslim=[-0.14 0.14]*m2cm;
scrsz = [1,1,1280,800];
fps=[10 10 scrsz(3)*2/4 scrsz(3)*2/4];

lw=8;
lwtarg=12;
lweli=8;
lwmaj=5;
lwa=3;
afs=30;
tifs=26;

cHand=[1 1 1]*0.5;
cPre=[121 85 116]/255; % purple
cPost=[155 187 89]/255; % light green
dark_post=0.8; % darkening the major line
dark_pre=0.6; % darkening the major line

postick=-15:5:15;
timetick=0:1:3;

T=2.5;
t=0:0.01:T;

tau=0.7;
delay=[0 -tau]+0.2; % add a lag to baseline (no delay) tracking

xshiftH=[0 0.04]*m2cm;

gain=1.5; % gain value
ampT=0.08*m2cm;
ampH=[ampT ampT*gain];

Xt=ampT*sin(2*pi*t/T(1));

% Baseline (No delay) analysis
d=1;
a=1;
x=1;

tSEI=10; % targ start end ind
Xh(1,:)=ampH(a)*sin(2*pi*t/T-delay(d))+xshiftH(x);
dXh=(2*pi/T)*ampH(a)*cos(2*pi*t/T-delay(d));
ddXh=-(2*pi/T)^2*ampH(a)*sin(2*pi*t/T-delay(d));

xmin=3*min(Xt);
xmax=3*max(Xt);

PosTH_ND=[Xt' Xh(d,:)']; % position Target-Hand
ATH_ND=EllipseDirectFit(PosTH_ND);
Eqt_ND= ExtractEllipseFun(ATH_ND); % Analytic equation of an ellipse
geo_ND=EllipseGeometry(ATH_ND,delay(d));

% Delay
for model=1:4
    
    if model==1
        % Change in delay: time representation
        d=2;
        a=1;
        x=1;
    elseif model==2
        % Change in shift: : state representation- shift
        x=2;
        a=1;
        d=1;
    elseif model==3
        % Change in amp: : state representation- gain
        x=1;
        a=2;
        d=1;
    end
    
    if model==4
        % Change in amp and delay: state representation- mechanical system
        K=20;
        B=10;
        M=0.1;
        Xh(2,:)=Xh(1,:)+(B/K)*dXh+(M/K)*ddXh;
    else
        Xh(2,:)=ampH(a)*sin(2*pi*t/T-delay(d))+xshiftH(x);
    end
    
    PosTH_D=[Xt' Xh(2,:)']; % position Target-Hand
    ATH_D=EllipseDirectFit(PosTH_D);
    Eqt_D= ExtractEllipseFun(ATH_D); % Analytic equation of an ellipse
    geo_D=EllipseGeometry(ATH_D,delay(d));
    
    % trajectories
    figure('Position',fps);
    plot(t(tSEI:end-tSEI),Xt(tSEI:end-tSEI),'k', 'linewidth',lwtarg);
    hold on
    plot(t,Xh(1,:),'--','color',cHand,'linewidth',lw);
    plot(t,Xh(2,:),':','color',cHand,'linewidth',lw);
    plot(tlim,[0 0],':','color','k','linewidth',lwa);
    box off
    xlabel('Time [s]','fontsize',afs,'fontweight','b');
    ylabel('Position [cm]','fontsize',afs,'fontweight','b');
    set(gca,'fontsize',tifs,'xtick',timetick,'ytick',postick,'fontweight','b')
    xlim(tlim);
    ylim(poslim);
    
    % target-hand position space
    figure('Position',fps);
    hold on
    
    plot(Xt,Xh(1,:),':','color',cPre,'linewidth',6);
    ezB=ezplot(Eqt_ND,[xmin,xmax]);
    title([]);
    set(ezB,'color',cPre,'linewidth',lweli)
    plot(geo_ND.points2(1,:),geo_ND.points2(2,:),'-.','color',cPre*dark_pre,'linewidth',lwmaj)
    plot(Xt,Xh(2,:),':','color',cPost,'linewidth',6);
    ezA=ezplot(Eqt_D,[xmin,xmax]);
    title([]);
    set(ezA,'color',cPost,'linewidth',lweli)
    plot(geo_D.points2(1,:),geo_D.points2(2,:),'-.','color',cPost*dark_post,'linewidth',lwmaj)
    plot(poslim,[0 0],':',[0 0],poslim,':','color','k','linewidth',lwa);
    box off
    xlabel('Target Position [cm]','fontsize',afs,'fontweight','b');
    ylabel('Hand Position [cm]','fontsize',afs,'fontweight','b');
    xlim(poslim);
    ylim(poslim);
    axis normal
    set(gca,'fontsize',tifs,'xtick',postick,'ytick',postick,'fontweight','b')
    
end