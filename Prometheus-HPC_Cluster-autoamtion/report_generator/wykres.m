x=1:4
name1=["floor-1","floor-2","d-in","d-out"]
grid on
figure(2)
bar(str2double(floor_m(2,:)))
set(gca,'xtick',[1:4],'xticklabel',name1)
title("massflow floor")
grid on

name2=["e", "out", "c", "in"]
figure(3)
plot(x,str2double(s_floor_m(2,:)))
set(gca,'xtick',[1:4],'xticklabel',name2)
title("massflow s-floor")
grid on
figure(4)
bar(str2double(s_floor_m(2,:)))
set(gca,'xtick',[1:4],'xticklabel',name2)
title("massflow s-floor")
grid on