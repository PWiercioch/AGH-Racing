%%
clc
clear all

data = dir("Track_data_17.09.2020/*.txt"); % read all files from directory

for i=1:length(data) % create array of file names
    czas(i,:)=string(erase(data(i).name,".txt"));
    i=i+1;
end

%% Zalezne od nazw danych - ulozenie alfabetyczne
[fh,i] = create_cells(1, czas);
[fr,i] = create_cells(i, czas);
[rh,i] = create_cells(i, czas);
[rpm,i] = create_cells(i, czas);
[rr,i] = create_cells(i, czas);

time_step=0.006; % [s]
time_step_rpm=0.05; % [s]

%%
for i=1:length(rpm)
    time=0:time_step:(length(fh{i,1})-1)*time_step; % different length of data collected from each sensor
    figure(i)
    subplot(2,3,1)
    plot(time,cell2mat(fh(i)))
    title("Front Heave")
    grid on
    xlabel("Time [s]")
    ylabel("Spring displacement [cm]")
    subplot(2,3,2)
    time=0:time_step:(length(fr{i,1})-1)*time_step;
    plot(time,cell2mat(fr(i)))
    title("Front Roll")
    grid on
    xlabel("Time [s]")
    ylabel("Spring displacement [cm]")
    subplot(2,3,4)
    time=0:time_step:(length(rh{i,1})-1)*time_step;
    plot(time,cell2mat(rh(i)))
    title("Rear Heave")
    grid on
    xlabel("Time [s]")
    ylabel("Spring displacement [cm]")
    subplot(2,3,5)
    time=0:time_step:(length(rr{i,1})-1)*time_step;
    plot(time,cell2mat(rr(i)))
    title("Rear Roll")
    grid on
    xlabel("Time [s]")
    ylabel("Spring displacement [cm]")
    subplot(2,3,[3,6])
    time=0:time_step_rpm:(length(rpm{i,1})-1)*time_step_rpm;
    plot(time,cell2mat(rpm(i)))
    title("RPM")
    grid on
    xlabel("Time [s]")
    ylabel("RPM")
end

%%
start_n=4;
end_n=10;

figure(length(rpm)+1)
sgtitle("Front heave vs RPM")
subplot(2,1,1)
for i=start_n:end_n
    time=0:time_step:(length(fh{i,1})-1)*time_step;
    plot(time,cell2mat(fh(i)))
    hold on
    i=i+1;
end
legend(czas(1:1:i-1))
hold off
grid on
xlabel("Time [s]")
ylabel("Spring displacement [cm]")
subplot(2,1,2)
for i=start_n:end_n
    time=0:time_step_rpm:(length(rpm{i,1})-1)*time_step_rpm;
    plot(time,cell2mat(rpm(i)))
    hold on
    i=i+1;
end
legend(czas(55:1:53+i))
hold off
grid on
xlabel("Time [s]")
ylabel("RPM")

figure(length(rpm)+2)
sgtitle("Front heave vs Front roll")
subplot(2,1,1)
for i=start_n:end_n
    time=0:time_step:(length(fh{i,1})-1)*time_step;
    plot(time,cell2mat(fh(i)))
    hold on
    i=i+1;
end
legend(czas(1:1:i-1))
hold off
grid on
xlabel("Time [s]")
ylabel("Spring displacement [cm]")
subplot(2,1,2)
for i=start_n:end_n
    time=0:time_step:(length(fr{i,1})-1)*time_step;
    plot(time,cell2mat(fr(i)))
    hold on
    i=i+1;
end
legend(czas(19:1:16+i))
hold off
grid on
xlabel("Time [s]")
ylabel("Spring displacement [cm]")

figure(length(rpm)+3)
sgtitle("Front heave vs Rear heave")
subplot(2,1,1)
for i=start_n:end_n
    time=0:time_step:(length(fh{i,1})-1)*time_step;
    plot(time,cell2mat(fh(i)))
    hold on
    i=i+1;
end
legend(czas(1:1:i-1))
hold off
grid on
xlabel("Time [s]")
ylabel("Spring displacement [cm]")
subplot(2,1,2)
for i=start_n:end_n
    time=0:time_step:(length(rh{i,1})-1)*time_step;
    plot(time,cell2mat(rh(i)))
    hold on
    i=i+1;
end
legend(czas(37:1:34+i))
hold off
grid on
xlabel("Time [s]")
ylabel("Spring displacement [cm]")

%%
function [name,i] = create_cells(start, czas)
    index = 1;
    for i=start:start+length(czas)/5-1 
        temp = readmatrix(strcat("Track_data_17.09.2020/",czas(i),".txt"));
        name(index,:) = {temp(:,2)};
        i=i+1;
        index =index +1;
    end
end
