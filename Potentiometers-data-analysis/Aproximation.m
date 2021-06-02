clc
clear all

%% all data points
fh.all=[32.8 33.4 32 33 31.3 33.2 31.1 32.5 31.1 29.9 31.7 30.8];
rh.all=[40.8 41.3 40.1 41 39.7 41.1 39.5 40.8 40.5 42.2 40.7 39.7];
tekst.all=[3 4 5 6 7 8 9 10 14 15 16 17];
rpm.all=[1180 1275 1525 1520 1400 1490 1735 1800 2100 2080 1930 1860];
reduktor=0.0207836;
velocity.all=reduktor*rpm.all;
total.all=fh.all+rh.all;

%% selected data points
fh.selected=[33.4 33.2 32.5 31.7 31.1];
rh.selected=[41.3 41.1 40.8 40.7 40.5];
tekst.selected=[3 4 5 6 7 8 9 10 14 15 16 17];
rpm.selected=[1275 1490 1800 1930 2100];
velocity.selected=reduktor*rpm.selected;
total.selected=fh.selected+rh.selected;

%% Draw plots
[comp_front_25.all, comp_front_45.all]=analiza(1,velocity.all,-fh.all,"Front dampers compression");
[comp_rear_25.all, comp_rear_45.all]=analiza(2,velocity.all,-rh.all,"Rear dampers compression");
[comp_total_25.all, comp_total_45.all]=analiza(3,velocity.all,-total.all,"Summary dampers compression");

[comp_front_25.selected, comp_front_45.selected]=analiza(7,velocity.selected,-fh.selected,"Front dampers compression");
[comp_rear_25.selected, comp_rear_45.selected]=analiza(8,velocity.selected,-rh.selected,"Rear dampers compression");
[comp_total_25.selected, comp_total_45.selected]=analiza(9,velocity.selected,-total.selected,"Summary dampers compression");

%% Calculate damper jump
jump_front.all=comp_front_45.all-comp_front_25.all;
jump_rear.all=comp_rear_45.all-comp_rear_25.all;
jump_total.all=comp_total_45.all-comp_total_25.all;

jump_front.selected=comp_front_45.selected-comp_front_25.selected;
jump_rear.selected=comp_rear_45.selected-comp_rear_25.selected;
jump_total.selected=comp_total_45.selected-comp_total_25.selected;

%% Calculate force difference
force_front.all=1.08*60*jump_front.all;
force_rear.all=1.08*60*jump_rear.all;
force_total.all=1.08*60*jump_total.all;

force_front.selected=1.08*60*jump_front.selected;
force_rear.selected=1.08*60*jump_rear.selected;
force_total.selected=1.08*60*jump_total.selected;

%% Function
function [df_25,df_45]=analiza(i,velocity,dane,tytul)
    
    fit=fitlm(velocity,dane, 'quadratic')
    figure(i)
    plot(fit)
    grid on
    title(tytul)
    xlabel("Velocity [m/s]")
    ylabel("Damper displacement [mm]")

    coeff=table2array(fit.Coefficients(:,1))';
    f = @(v) coeff(3)*v.^2 + coeff(2)*v + coeff(1);
    
    x=0:100;
    figure(i+3)
    plot(x,f(x))
    grid on
    title(tytul+" extrapolation")
    xlabel("Velocity [m/s]")
    ylabel("Damper displacement [mm]")

    df_25=abs(f(25));
    df_45=abs(f(45));
end