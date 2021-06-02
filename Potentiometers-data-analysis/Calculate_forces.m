%% Potentiometers signatures
% FR = FL = Front Roll Damper
% FF = FR = Front Heave Damper
% RF = RL = Rear Heave Damper
% RR = RR = Rear Roll Damper

%% Read data
clc
clear all

Table1 = importdata("Track_data_20.08.2020\Telemetria_200820141049.xlsx");
T = Table1.data.Arkusz2;
czas = T(:,1);
FL = T(:,15);
FR = T(:,16);
RL = T(:,17);
RR = T(:,18);
RPM = T(:,13);
ACC = T(:, 4);
BREAK = T(:, 5);

%% Settings
V_max_pot=0.01; % maximal allowed potentiometer velocity - everything above that value will be treated as anomally and filtered out
T_poczatek = 100; % start time index
T_koniec =1000; % end time index

czas = czas(T_poczatek:T_koniec);
FL = FL(T_poczatek:T_koniec);
FR = FR(T_poczatek:T_koniec);
RL = RL(T_poczatek:T_koniec);
RR = RR(T_poczatek:T_koniec);
RPM = RPM(T_poczatek:T_koniec);
ACC = ACC(T_poczatek:T_koniec).*100/255;
BREAK = BREAK(T_poczatek:T_koniec).*100/255;
%% Obliczenia

FL_v=velocity(FL,czas, V_max_pot);
FR_v=velocity(FR,czas, V_max_pot);
RL_v=velocity(RL,czas, V_max_pot);
RR_v=velocity(RR,czas, V_max_pot);

FR_poprawka=0.505;
RL_poprawka=-0.197;
FL_poprawka=0.115;
RR_poprawka=-0.005;
FR_relative=displacement(FR, FR_v);
RL_relative=displacement(RL, RL_v);
FL_relative=displacement(FL, FL_v);
RR_relative=displacement(RR, RR_v);

ch_bump=1538;
ch_rebound=1538;
cd_bump=1538;
cd_rebound=1538;

F_front_strong=force_strong(FR_relative,FR_v,FL_relative,FL_v,ch_bump,ch_rebound);
F_front_weak=force_weak(FR_relative,FR_v,FL_relative,FL_v,ch_bump,ch_rebound);
F_rear_strong=force_strong(RL_relative,RL_v,RR_relative,RR_v,ch_bump,ch_rebound);
F_rear_weak=force_weak(RL_relative,RL_v,RR_relative,RR_v,ch_bump,ch_rebound);

F_front=F_front_strong + F_front_weak;
F_rear=F_rear_strong + F_rear_weak;
F_total=F_front+F_rear;

F_front=smooth(F_front);
F_rear=smooth(F_rear);
F_total=smooth(F_total);
%% Plot data
czas=czas-T(1,1);

figure(1)

sgtitle("Potentiometer displacement")

plot6(czas,FR,1,"Front Heave","Displacement",[2000 6000])
plot6(czas,RL,2,"Rear Heave","Displacement",[2800 6000])
plot6(czas,FL,3,"Front Roll","Displacement",[4800 6800])
plot6(czas,RR,4,"Rear Roll","Displacement",[4800 6800])
plot6(czas,RPM,5,"RPM","RPM",[0 2500])
plot6(czas,RPM,6,"RPM","RPM",[0 2500])

figure(2)

sgtitle("Relative potentiometer displacement [mm]")

plot6(czas,FR_relative,1,"Front Heave","Displacement [mm]",[-4 4])
plot6(czas,RL_relative,2,"Rear Heave","Displacement [mm]",[-4 4])
plot6(czas,FL_relative,3,"Front Roll","Displacement [mm]",[-4 4])
plot6(czas,RR_relative,4,"Rear Roll","Displacement [mm]",[-4 4])
plot6(czas,RPM,5,"RPM","RPM",[0 2500])
plot6(czas,RPM,6,"RPM","RPM",[0 2500])

figure(3)

sgtitle("Potentiometers velocity [m/s]")

plot4(czas,FR_v,1,"Front Heave","Velocity [m/s]",[-0.4 0.4])
plot4(czas,RL_v,2,"Rear Heave","Velocity [m/s]",[-0.1 0.1])
plot4(czas,FL_v,3,"Front Roll","Velocity [m/s]",[-0.1 0.1])
plot4(czas,RR_v,4,"Rear Roll","Velocity [m/s]",[-0.1 0.1])

figure(4)

sgtitle("Forces")

subplot(3,2,1)
plot(czas,F_front_strong)
title("Front heavy loaded tire")
xlabel("Time [s]")
ylabel("Force [N]")
grid on

subplot(3,2,2)
plot(czas,F_front_weak)
title("Front light loaded tire")
xlabel("Time [s]")
ylabel("Force [N]")
grid on

subplot(3,2,3)
plot(czas,F_rear_strong)
title("Rear heavy loaded tire")
xlabel("Time [s]")
ylabel("Force [N]")
grid on

subplot(3,2,4)
plot(czas,F_rear_weak)
title("Rear light loaded tire")
xlabel("Time [s]")
ylabel("Force [N]")
grid on

subplot(3,2,5)
plot(czas,RPM)
title("RPM")
xlabel("Time [s]")
ylabel("RPM")
grid on

subplot(3,2,6)
plot(czas,RPM)
title("RPM")
xlabel("Time [s]")
ylabel("RPM")
grid on

figure(5) 
tiledlayout(6,1)

ax1 = nexttile;
plot(czas,F_front)
title("Front axis")
xlabel("Time [s]")
ylabel("Force [N]")
ylim([-200 20])
grid on

ax2 = nexttile;
plot(czas,F_rear)
title("Rear axis")
xlabel("Time [s]")
ylabel("Force [N]")
ylim([-100 50])
grid on

ax3 = nexttile;
plot(czas,F_total)
title("Total")
xlabel("Time [s]")
ylabel("Force [N]")
ylim([-250 50])
grid on

ax4 = nexttile;
plot(czas,RPM)
title("RPM")
xlabel("czas [s]")
ylabel("RPM")
grid on
ax5 = nexttile;
plot(czas,ACC)
title("ACC pedal")
xlabel("czas [s]")
ylabel("% ACC")
ylim([0 100])
grid on
ax6 = nexttile;
plot(czas,BREAK)
title("Break pedal")
xlabel("czas [s]")
ylabel("% Break")
ylim([0 100])
grid on
linkaxes([ax1 ax2 ax3 ax4 ax5 ax6],'x')


%% Functions

function relative=displacement(data, vel)
    relative_0=data(1);
    for i=1:length(data)
        if vel(i)==0 & i==1
            relative(i)=relative_0/1000;
        elseif vel(i)==0
            relative(i)=relative(i-1);
        else
            relative(i)=(data(i)-relative_0)/1000;
        end
    end
end

function result=velocity(data, czas, V_max)
    for i=1:length(data)-1
     result(i)=(data(i+1)-data(i))/(czas(i+1)-czas(i))/100000;
     if abs(result(i))>V_max
         result(i) = 0;
     end
     i=i+1;
    end
    result(end+1)=0;
end

function F=force_strong(data,data2,data3,data4,ch,cd) % calcualte force from spring displacement on more loaded side
    F=-((data*60+data2*ch)*1.08+(data3*50+data4*cd)*1.6);
end

function F=force_weak(data,data2,data3,data4,ch,cd) % calcualte force from spring displacement on less loaded side
    F=-((data*60+data2*ch)*1.08-(data3*50+data4*cd)*1.6);
end

function plot4(czas,data,index,tytul,os_y,limit)
    subplot(2,2,index)
    plot(czas,data);
    title(tytul);
    xlabel('Time [s]');
    ylabel(os_y);
    ylim(limit);
    grid on
end

function plot6(czas,data,index,tytul,os_y,limit)
    subplot(3,2,index)
    plot(czas,data);
    title(tytul);
    xlabel('Time [s]');
    ylabel(os_y);
    ylim(limit);
    grid on
end