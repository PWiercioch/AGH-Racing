clc
clear all

name=sheetnames('profile.xlsx');
name(1,:)=[];
name([19,21,23],:)=[];
x=readmatrix("profile.xlsx","Sheet","SG6040","Range","A2:A17");

i=1;
for i=1:length(name)
    data(:,[1,2,3,4,5]+(i-1)*5)=readmatrix("profile.xlsx","Sheet",name(i),"Range","A2:E17");
end

i=1;
j=1;
for i=1:length(data(1,:))
    if data(1,i) > 45
        df(:,j)=data(:,i);
        j=j+1;
    end
end

temp=df([4:12],:);
temp=sort(temp,'descend');
temp2=temp(1,:);
temp2=sort(temp2,'descend');
top=temp2(1:6);

for i=1:length(top)
    [row(i),col(i)]=find(df==top(i));
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

Wyniki=[name(col)';string(top)]