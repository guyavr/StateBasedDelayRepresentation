clc
clear
close all

cB=[1 1 1]*0; % black
cA=[1 1 1]*0.5; % gray

afs=24;
tickfs=20;
txtfs=18;
msB=18;
lwB=4;
msA=14;
lwA=2;
lw=5;
ms=14;

xLim=[0.5 1.5];
yLim=[0 0.7];
yLim_d=[-0.2 0.2];
yLim_dB=[-50 0];
yLim_dB_d=[-0.1 5.1];
xTick=0:0.5:3;
yTick=0:0.2:1;
yTick_dB=0:3:18;
yTick_dB_d=0:1:8;

% load pong data
% mean frequency responses of late adaptation (last 4 trials)
load('meanPongAmpLateAdapt')
% the presented simulation (Figure 11c) is for a mean frequency
% response of a single participant during baseline (no delay)
subj=1;
f_nd=pxx_ha_f_oneVec;
f=f_nd;
w=2*pi*f;

% Amplitude - No Delay
Amp_nd=pxx_ha_m_meanStage;
Pow_nd=(Amp_nd.^2)/2;
Amp_nd_dB=10*log10(Pow_nd);

for m=1:4 % 1-Time; 2-Shift; 3-Gain; 4-Mech
    
    % Amplitude - Delay
    if m==1
        Amp_d=Amp_nd;
    elseif m==2
        Amp_d=Amp_nd;
    elseif m==3
        g=1.25;
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
    
    % Amplitude - dB (D-ND diff)
    figure
    hold on
    plot(xLim,[0 0],':','color',[1 1 1]*0,'linewidth',2)
    plot(f,Amp_d_dB-Amp_nd_dB,'color',[1 1 1]*0.4,'linewidth',5)
    xlabel('Frequency [Hz]','fontsize',afs,'fontweight','b');
    ylabel({'Amplitude [dB]','Delay-No Delay'},'fontsize',afs,'fontweight','b');
    set(gca,'XTick',xTick,'YTick',yTick_dB_d,'fontsize',tickfs,'fontweight','b');
    xlim(xLim);
    ylim(yLim_dB_d);
    
end
