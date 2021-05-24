clc
clear all

% read airfoil names
name=sheetnames('profile.xlsx');
name(1,:)=[];
name([19,21,23],:)=[];
% read angle of attack span
x=readmatrix("profile.xlsx","Sheet","SG6040","Range","A2:A17");

%% read data
i=1;
for i=1:length(name)
    data(:,[1,2,3,4,5]+(i-1)*5)=readmatrix("profile.xlsx","Sheet",name(i),"Range","A2:E17");
end

%% extract downforce from data
i=1;
j=1;
for i=1:length(data(1,:))
    if data(1,i) > 45 % minimal value of downforce at 30 deg angle of attack is greater than 45
        df(:,j)=data(:,i);
        j=j+1;
    end
end

%% calculations
% select bounds
min_angle=8; % by index in data table
max_angle=12; % by index in data table
airfoil_n=4; % number of best airfoils to find

temp=df([min_angle:max_angle],:); % select angle pof attack range
temp=sort(temp,'descend'); % sort columns i descending order
temp2=temp(1,:); % select first row - highest downforce value for every column(airfoil) 
temp2=sort(temp2,'descend'); % sort airfoils by peak performance
top=temp2(1:airfoil_n); % select best 6 arfoils

%% draw 6 airfoils with best peak performance with full range of angle of attack
for i=1:length(top)
    [row(i),col(i)]=find(df==top(i)); % find airfoils in df table
    i=i+1;
end

figure(1)
for i=1:length(col)
    plot(x,df(:,col(i)))
    hold on
    i=i+1;
end
legend(name(col),'Location','SouthEast')
grid on
hold off

%% draw 6 airfoils with best peak performance with limited range of angle of attack
figure(2)
for i=1:length(col)
    plot(x,df(:,col(i)))
    hold on
    i=i+1;
end
xlim([x(max(row)+1) x(min(row)-1)])
legend(name(col),'Location','SouthEast')
grid on
hold off

Wyniki=[name(col)';string(top)] % output peak performance of 6 best airfoils