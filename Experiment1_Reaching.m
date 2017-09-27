clc;
clear;
close all;

T=0.3; % movement duration
dt=0.001;
t=0:dt:T;
            
x0=0;
y0=0;

XF=[-10*cos(pi/4) 0 10*cos(pi/4)]; % Targets' x coordinates
YF=[10*cos(pi/4) 10 10*cos(pi/4)]; % Targets' y coordinates

NoiseSTD=1;
ShiftX=[-1.0607 0 1.0607]; % Spatial shift- x coordinates
ShiftY=[1.0607 1.5 1.0607]; % Spatial shift- y coordinates
for i=1:15
    for j=1:3
            xf_NoDelay=XF(j)+normrnd(0,NoiseSTD);
            yf_NoDelay=YF(j)+normrnd(0,NoiseSTD);
        
            xf=XF(j)+normrnd(0,NoiseSTD);
            yf=YF(j)+normrnd(0,NoiseSTD);
            
            % Reaching movements according to the minimum jerk model (Flash
            % and Hogan, 1985)
            Px=x0+(x0-xf)*(15*(t.^4)./T^4-6*(t.^5)./T^5-10*(t.^3)./T^3);
            Pxdot=(x0-xf)*(60*(t.^3)./T^4-30*(t.^4)./T^5-30*(t.^2)./T^3);
            Pxdot2=(x0-xf)*(180*(t.^2)./T^4-120*(t.^3)./T^5-60*t./T^3);
            
            Py=y0+(y0-yf)*(15*(t.^4)./T^4-6*(t.^5)./T^5-10*(t.^3)./T^3);
            Pydot=(y0-yf)*(60*(t.^3)./T^4-30*(t.^4)./T^5-30*(t.^2)./T^3);
            Pydot2=(y0-yf)*(180*(t.^2)./T^4-120*(t.^3)./T^5-60*t./T^3);
            
            EstTau=0.1;
            P_Pos=[x0*ones(1,EstTau/dt) sqrt(Px.^2+Py.^2)]; % paddle's estimated position
            
            % Time Representation
            DH_Pos=sqrt(Px.^2+Py.^2); % hand position
            
            % Shift Representation
            Sxf=xf+ShiftX(j);
            SPx=x0+(x0-Sxf)*(15*(t.^4)./T^4-6*(t.^5)./T^5-10*(t.^3)./T^3);
            SPxdot=(x0-Sxf)*(60*(t.^3)./T^4-30*(t.^4)./T^5-30*(t.^2)./T^3);
            SPxdot2=(x0-Sxf)*(180*(t.^2)./T^4-120*(t.^3)./T^5-60*t./T^3);
           
            Syf=yf+ShiftY(j);
            SPy=y0+(y0-Syf)*(15*(t.^4)./T^4-6*(t.^5)./T^5-10*(t.^3)./T^3);
            SPydot=(y0-Syf)*(60*(t.^3)./T^4-30*(t.^4)./T^5-30*(t.^2)./T^3);
            SPydot2=(y0-Syf)*(180*(t.^2)./T^4-120*(t.^3)./T^5-60*t./T^3);
            
            SH_Pos=sqrt(SPx.^2+SPy.^2); % hand position
            
            % Gain Representation
            g=1.2;
            GHx=g*Px;
            GHy=g*Py;
            
            GH_Pos=sqrt(GHx.^2+GHy.^2); % hand position

            % Mechanical System Representation
            EstTau=0.1;
            
            MH_x=Px+EstTau*Pxdot+(0.5*EstTau^2)*Pxdot2;
            MH_y=Py+EstTau*Pydot+(0.5*EstTau^2)*Pydot2;
            
            MH_Pos=sqrt(MH_x.^2+MH_y.^2); % hand position
            
            D.TargetNoPertub(i,j)=sqrt(xf_NoDelay^2+yf_NoDelay^2);
            D.AngleNoPertub(i,j)=atan2(yf_NoDelay,xf_NoDelay);
            D.TargetPertub(i,j)=max(P_Pos);
            D.Delay(i,j)=max(DH_Pos);
            D.Shift(i,j)=max(SH_Pos);
            D.Gain(i,j)=max(GH_Pos);
            D.Mechanical(i,j)=max(MH_Pos);
            D.Angle(i,j)=atan2(yf,xf);
            
    end
end    

i=0;
while i
    if exist(['ReachingSimulation',num2str(i),'.mat'],'file')
        i=i+1;
    else
       save(['ReachingSimulation',num2str(i),'.mat'],'D')
       i=0;
    end
end
%%
lfs=30;

set(0, 'DefaultAxesLineWidth', 2, 'DefaultAxesFontSize', 40, 'DefaultAxesFontWeight','bold',...
    'DefaultLineLineWidth', 4, 'DefaultLineMarkerSize', 15);

scrsz = [1,1,1280,800];
figPos = [scrsz(3)/8 scrsz(4)/8 scrsz(3)*4/5 scrsz(3)*3/5];

xTick=-10:5:10;
xTickLabel=10:-5:-10;
yTick=0:5:15;
yTickLabel=0:5:15;

cnd=[117 144 167]/255; % gray blue
cd=[247 181 106]/255; % light orange

% Run saved simulations (Figure 4c)
% To run new simulations remove the 'load' commands below

% Time Representation
load('ReachingSimulation_Time.mat')
figure('Position',figPos)
hold on;
axis([-12 12 -2 16])
plot(0,0,'s','color','k','linewidth',4,'markersize', 30)
for i=1:3
    P1=plot(D.TargetNoPertub(:,i).*cos(D.AngleNoPertub(:,i)),D.TargetNoPertub(:,i).*sin(D.AngleNoPertub(:,i)),'^','color','k','markerfacecolor',cnd,'markersize',20);
    P2=plot(D.Delay(:,i).*cos(D.Angle(:,i)),D.Delay(:,i).*sin(D.Angle(:,i)),'o','color','k','markerfacecolor',cd,'markersize',20);
    plot(XF(i),YF(i),'s','color',[0.4 0.4 0.4],'linewidth',4,'markersize', 30)
    set(gca,'xtick',xTick,'xticklabel',xTickLabel,'ytick',yTick,'yticklabel',yTickLabel)
end
leg=legend([P1 P2],'Post No Delay','Post Delay','location','southeast');
set(leg,'box','off','location','southeast','fontsize',lfs);
xlabel('X [cm]');
ylabel('Y [cm]');

% Spatial Shift
load('ReachingSimulation_Shift.mat')
figure('Position',figPos)
hold on;
axis([-15 15 -2 18])
plot(0,0,'s','color','k','linewidth',4,'markersize', 30)
for i=1:3
    P1=plot(D.TargetNoPertub(:,i).*cos(D.AngleNoPertub(:,i)),D.TargetNoPertub(:,i).*sin(D.AngleNoPertub(:,i)),'^','color','k','markerfacecolor',cnd,'markersize',20);
    P2=plot(D.Shift(:,i).*cos(D.Angle(:,i)),D.Shift(:,i).*sin(D.Angle(:,i)),'o','color','k','markerfacecolor',cd,'markersize',20);
    plot(XF(i),YF(i),'s','color',[0.4 0.4 0.4],'linewidth',4,'markersize', 30)
    set(gca,'xtick',xTick,'xticklabel',xTickLabel,'ytick',yTick,'yticklabel',yTickLabel)
end
leg=legend([P1 P2],'Post No Delay','Post Delay','location','southeast');
set(leg,'box','off','location','southeast','fontsize',lfs);
xlabel('X [cm]');
ylabel('Y [cm]');

% Gain
load('ReachingSimulation_Gain.mat')
figure('Position',figPos)
hold on;
axis([-15 15 -2 18])
plot(0,0,'s','color','k','linewidth',4,'markersize', 30)
for i=1:3
    P1=plot(D.TargetNoPertub(:,i).*cos(D.AngleNoPertub(:,i)),D.TargetNoPertub(:,i).*sin(D.AngleNoPertub(:,i)),'^','color','k','markerfacecolor',cnd,'markersize',20);
    P2=plot(D.Gain(:,i).*cos(D.Angle(:,i)),D.Gain(:,i).*sin(D.Angle(:,i)),'o','color','k','markerfacecolor',cd,'markersize',20);
    plot(XF(i),YF(i),'s','color',[0.4 0.4 0.4],'linewidth',4,'markersize', 30)
    set(gca,'xtick',xTick,'xticklabel',xTickLabel,'ytick',yTick,'yticklabel',yTickLabel)
end
leg=legend([P1 P2],'Post No Delay','Post Delay','location','southeast');
set(leg,'box','off','location','southeast','fontsize',lfs);
xlabel('X [cm]');
ylabel('Y [cm]');

% Mechanical System
load('ReachingSimulation_Mech.mat')
figure('Position',figPos)
hold on;
axis([-15 15 -2 18])
plot(0,0,'s','color','k','linewidth',4,'markersize', 30)
for i=1:3
    P1=plot(D.TargetNoPertub(:,i).*cos(D.AngleNoPertub(:,i)),D.TargetNoPertub(:,i).*sin(D.AngleNoPertub(:,i)),'^','color','k','markerfacecolor',cnd,'markersize',20);
    P2=plot(D.Mechanical(:,i).*cos(D.Angle(:,i)),D.Mechanical(:,i).*sin(D.Angle(:,i)),'o','color','k','markerfacecolor',cd,'markersize',20);
    plot(XF(i),YF(i),'s','color',[0.4 0.4 0.4],'linewidth',4,'markersize', 30)
    set(gca,'xtick',xTick,'xticklabel',xTickLabel,'ytick',yTick,'yticklabel',yTickLabel)
end
leg=legend([P1 P2],'Post No Delay','Post Delay','location','southeast');
set(leg,'box','off','location','southeast','fontsize',lfs);
xlabel('X [cm]');
ylabel('Y [cm]');
