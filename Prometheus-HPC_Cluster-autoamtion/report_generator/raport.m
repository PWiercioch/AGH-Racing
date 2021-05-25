%% @
%%
clc
clear all

file=fopen("@_components.out");

i=1;
j=1;
while 1
    tline = fgetl(file);
    if ~ischar(tline)
        break
    end
    if j==3
        tekst=tline;
    end
    temp=str2num(tline);
    if ~isempty(temp)
        dane(i,:)=temp;
        i=i+1;
    end
    j=j+1;
end

fclose(file);

file=fopen("@_massflow.out");

i=1;
j=1;
while 1
    tline = fgetl(file);
    if ~ischar(tline)
        break
    end
    if j==3
        tekst_m=tline;
    end
    temp=str2num(tline);
    if ~isempty(temp)
        dane_m(i,:)=temp;
        i=i+1;
    end
    j=j+1;
end

fclose(file);

%%
fwheel_massflow=imread("fwheel_massflow.JPG");
rwheel_massflow=imread("rwheel_massflow.JPG");
floor_massflow=imread("floor_massflow.JPG");
sidepod_massflow=imread("sidepod_massflow.JPG");
out_massflow=imread("out_massflow.JPG");
modeljpg=imread("@_model.JPG");
s_floor_massflow=("s_floor_massflow.JPG");
fig=1;

%%
tekst=erase(tekst,'"');
tekst=strsplit(tekst);
tekst_m=erase(tekst_m,'"');
tekst_m=strsplit(tekst_m);
newchar=erase(tekst(1),'"');
dane(end,:)=round(dane(end,:),2);
dane=num2str(dane(end,:));
dane=strsplit(dane);
results=tekst;
results(2,:)=dane;
results=string(results);
dane_m=num2str(abs(round(dane_m(end,:),3)));
dane_m=strsplit(dane_m);
massflow=tekst_m;
massflow(2,:)=dane_m;
massflow=string(massflow);

 format='%20s %15s %15s \n';
 formatSpec='%20s %15.2f %15.2f \n';
%%
components_df=[2:10];
components_drag=[11:19];
fw_df=[20:24];
fw_drag=[34:38];
rw_df=[29:33];
rw_drag=[43:47];
s_df=[25:28];
s_drag=[39:42];

%%
fwh_m(1,:)=massflow(1,[16:24]);
fwh_m(2,:)=massflow(2,[16:24]);
fwh_m_num=str2double(fwh_m(2,:));

out_m(1,:)=massflow(1,[25:33]);
out_m(2,:)=massflow(2,[25:33]);
out_m_num=str2double(out_m(2,:));

rwh_m(1,:)=massflow(1,[34:41]);
rwh_m(1,9)=".";
rwh_m(2,9)="0";
rwh_m(2,[1:8])=massflow(2,[34:41]);
rwh_m_num=str2double(rwh_m(2,:));

floor_m(1,:)=massflow(1,[2:5]);
floor_m(2,:)=massflow(2,[2:5]);
floor_m_num=str2double(floor_m(2,:));

s_in_m(1,:)=massflow(1,[6:11]);
s_in_m(2,:)=massflow(2,[6:11]);
s_in_m_num=str2double(s_in_m(2,:));

s_floor_m(1,:)=massflow(1,[12:15]);
s_floor_m(2,:)=massflow(2,[12:15]);
s_floor_m_num=str2double(s_floor_m(2,:));

%%
imshow(modeljpg)
snapnow
file=fopen("@_tekst.txt");
i=1;
while 1
    tline = fgetl(file);
    if ~ischar(tline)
        break
    end
   fprintf("%s \n",tline)
    i=i+1;
end
fclose(file);
fprintf("\n \n \n \n \n \n \n \n \n \n  \n \n \n \n \n") %10 - 2 linijki tekstu 10 linijek tekstu to max


%% Forces
forces(components_df,components_drag,results)

%% FW
forces(fw_df,fw_drag,results)

%% RW
forces(rw_df,rw_drag,results)

%% S
forces(s_df,s_drag,results)

%% Massflow - front wheel inside
figure(fig)
imshow(fwheel_massflow)
fig=fig+1;
snapnow
rozmiar=massflow_text(fwh_m);
snapnow
%%
fig=my_surface(fwh_m_num,rozmiar,fig);
title("Massflow - front wheel inside")

%% Massflow - front wheel outside
figure(fig)
imshow(out_massflow)
fig=fig+1;
snapnow
rozmiar=massflow_text(out_m);
%%
fig=my_surface(out_m_num,rozmiar,fig);
title("Massflow - front wheel outside")

%% Massflow - rear wheel inside
figure(fig)
imshow(rwheel_massflow)
fig=fig+1;
snapnow
rozmiar=massflow_text(rwh_m);
%%
fig=my_surface(rwh_m_num,rozmiar,fig);
title("Massflow - rear wheel inside")

%% Massflow - sidepod
figure(fig)
imshow(sidepod_massflow)
fig=fig+1;
snapnow
rozmiar=massflow_text(s_in_m);
%%
fig=my_surface(s_in_m_num,rozmiar,fig);
title("Massflow - sidepod inlet")
%%
figure(fig)
imshow(s_floor_massflow);
fig=fig+1;
snapnow
rozmiar=massflow_text(s_floor_m);
%%
x=1:4;
name2=["e", "out", "c", "in"];
bar(str2double(s_floor_m(2,:)))
set(gca,'xtick',[1:4],'xticklabel',name2)
title("massflow s-floor")
grid on

%% Massflow - floor
figure(fig)
imshow(floor_massflow);
fig=fig+1;
snapnow
rozmiar=massflow_text(floor_m);
%%
name1=["floor-1","floor-2","d-in","d-out"];
bar(str2double(floor_m(2,:)))
set(gca,'xtick',[1:4],'xticklabel',name1)
title("massflow floor")
grid on

%%

% %% Massflow - sidepod floor
% rozmiar=massflow_text(s_floor_m);
% %%
% fig=my_surface(s_floor_m_num,rozmiar,fig);