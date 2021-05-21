%% Data prep: 
% Change periods for commas in *.txt files

%% Potentiometers signatures
% FR = FL = Front Roll Damper
% FF = FR = Front Heave Damper
% RF = RL = Rear Heave Damper
% RR = RR = Rear Roll Damper

%% Read data
clc
clear all
Table1 = importdata("Test_data_21.07\2.txt"); % select file 1
Table2 = importdata("Test_data_28.07\1.txt"); % select file 2
T1 = Table1.data;
T2 = Table2.data;
czas1 = T1(:,1);
czas2 = T2(:,1);
FL1 = T1(:,19)/10;
FR1 = T1(:,21)/10;
RL1 = T1(:,23)/10;
RR1 = T1(:,25)/10;
FL2 = T2(:,19)/10;
FR2 = T2(:,21)/10;
RL2 = T2(:,23)/10;
RR2 = T2(:,25)/10;

%% Data visualization
grid on
hold on
czas1=czas1-T1(1,1);
czas2=czas2-T2(1,1);

subplot(2,2,1)
plot(czas1,FL1);'F Roll1';
hold on
plot(czas2,FL2);'F Roll2';
hold off
title('Front Roll');
xlabel('Time [s]');
ylabel('Damper length [mm]');
legend('Test 1', 'Test 2')

subplot(2,2,2)
plot(czas1,FR1);'F Heave1';
hold on
plot(czas2,FR2);'F Heave2';
hold off
title('Front Heave');
xlabel('Time [s]');
ylabel('Damper length [mm]');
legend('Test 1', 'Test 2')

subplot(2,2,4)
plot(czas1,RL1);'R Heave1';
hold on
plot(czas2,RL2);'R Heave2';
hold off
title('Rear Heave');
xlabel('Time [s]');
ylabel('Damper length [mm]');
legend('Test 1', 'Test 2')

subplot(2,2,3)
plot(czas1,RR1);'R Roll1';
hold on
plot(czas2,RR2);'R Roll2';
hold off
title('Rear Roll');
xlabel('Time [s]');
ylabel('Damper length [mm]');
legend('Test 1', 'Test 2')

hold off