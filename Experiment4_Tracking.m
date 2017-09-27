clc
clear
close all

cB=[154 0 77]/255; % dark red
cA=[117 175 163]/255; % cyan

afs=24;
tickfs=20;
txtfs=18;
msB=18;
lwB=8;
msA=14;
lwA=5;
lw=5;
ms=14;

xLim=[0.1 1];
yLim=[1.9 7.1];
yLim_d=[-0.2 2.2];
yLim_dB=[1.9 15.1];
yLim_dB_d=[-0.1 3.1];
xTick=0:0.2:1;
yTick=0:1:12;
yTick_dB=0:3:18;
yTick_dB_d=0:1:8;

At=2;
f=0:0.01:1;
w=2*pi*f;
Nw=length(w);

for fun=1:2 % 1- accurate baseline performance;
            % 2- baseline amplitude increases with frequency
    
    % Amplitude - No Delay
    if fun==1
        Amp_nd=At*ones(1,Nw);
    else
        Amp_nd=0.1*w.^2+At;
    end
    
    Pow_nd=(Amp_nd.^2)/2;
    Amp_nd_dB=10*log10(Pow_nd);
    
    % Amplitude - Delay
    for m=1:2 % 1- Gain; 2- Mechanical System
        if m==1
            g=1.15; % Gain
            Amp_d=g*Amp_nd;
        else
            tau=0.2;
            % The furier tansform of the mechanical system:
            % Xh(jw)/Xp(jw)=1-(tau^2)*(w^2)/2+tau*w*j=A+Bj
            % for a sine wave of the target is At*sin(w*t), the increase in amplitude is
            % Amp=At*sqrt(A^2+B^2)=At*sqrt(1+tau^4*w^4/4)
            Amp_d=Amp_nd.*sqrt(1+tau^4.*w.^4/4);
        end
        Pow_d=(Amp_d.^2)/2;
        Amp_d_dB=10*log10(Pow_d);
        
        % Amplitude - cm
        figure
        hold on
        plot(f,Amp_nd,'color',cB,'linewidth',lwB)
        plot(f,Amp_d,'color',cA,'linewidth',lwA)
        xlabel('Frequency [Hz]','fontsize',afs,'fontweight','b');
        ylabel('Amplitude [cm]','fontsize',afs,'fontweight','b');
        set(gca,'XTick',xTick,'YTick',yTick,'fontsize',tickfs,'fontweight','b');
        xlim(xLim);
        ylim(yLim);
        
        % Amplitude - cm (D-ND diff)
        figure
        hold on
        plot(xLim,[0 0],':','color',[1 1 1]*0,'linewidth',2)
        plot(f,Amp_d-Amp_nd,'color',[1 1 1]*0.4,'linewidth',lwA)
        xlabel('Frequency [Hz]','fontsize',afs,'fontweight','b');
        ylabel({'Amplitude [cm]','Delay-No Delay'},'fontsize',afs,'fontweight','b');
        set(gca,'XTick',xTick,'YTick',yTick_dB_d,'fontsize',tickfs,'fontweight','b');
        xlim(xLim);
        ylim(yLim_d);
        
        % Amplitude - dB
        figure
        hold on
        plot(f,Amp_nd_dB,'color',cB,'linewidth',lwB)
        plot(f,Amp_d_dB,'color',cA,'linewidth',lwA)
        xlabel('Frequency [Hz]','fontsize',afs,'fontweight','b');
        ylabel('Amplitude [dB]','fontsize',afs,'fontweight','b');
        set(gca,'XTick',xTick,'YTick',yTick_dB,'fontsize',tickfs,'fontweight','b');
        xlim(xLim);
        ylim(yLim_dB);
        
        % Amplitude - dB (D-ND diff)
        figure
        hold on
        plot(xLim,[0 0],':','color',[1 1 1]*0,'linewidth',2)
        plot(f,Amp_d_dB-Amp_nd_dB,'color',[1 1 1]*0.4,'linewidth',lwA)
        xlabel('Frequency [Hz]','fontsize',afs,'fontweight','b');
        ylabel({'Amplitude [dB]','Delay-No Delay'},'fontsize',afs,'fontweight','b');
        set(gca,'XTick',xTick,'YTick',yTick_dB_d,'fontsize',tickfs,'fontweight','b');
        xlim(xLim);
        ylim(yLim_dB_d);
        
    end
end