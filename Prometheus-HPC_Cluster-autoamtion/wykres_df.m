clc
clear all

file=fopen("data.txt");

i=1;
while 1
    tline = fgetl(file);
    if ~ischar(tline)
        break
    end
    numer=str2num(tline);
    if ~isempty(numer)
        if length(numer)>=16
            temp=numer(1,[1:16]);
            dane(i,:)=temp;
            i=i+1;
        end
    end
end
fclose(file);

j=1;
for i=1:length(dane(end,:))
    if (150<dane(end,i)) && (dane(end,i)<500)
        kolumna(j)=i;
        j=j+1;
    end
end

ld=dane(end,kolumna(1))-50;
lg=dane(end,kolumna(1))+50;
figure(1)
plot(dane(:,1),dane(:,kolumna(1)),"k",dane(:,1),dane(:,kolumna(2)),"r")
ylim([ld lg])
xlabel("iteration")
ylabel("downforce [N]")
grid on

saveas(figure(1),"plot.jpg")

Srednia=mean(dane([850,1000],kolumna(1)))
Odchylenie=std(dane([850,1000],kolumna(1)))
Stosunek=Odchylenie/dane(end,kolumna(1))*100
opis=["Powy�sza wielko�c okre�la stosnek odchylenia standardowego do si�y docisku uzyskanej w ostatniej iteracji. Warto�� zosta�a zwi�kszona 100-krotnie dla wi�kszej czytelno�ci"];
disp(opis)
warning=["UWAGA!!";"Nale�y sprawdzi� poprawno�� opisu danych - warto�ci zawarte w tym dokumencie s� poprawne tylko gdy na wykresie plot.jpg kolorem czarnym sa zaznaczone warto�ci u�rednione a czerwonym chwilowe"];
disp(warning)