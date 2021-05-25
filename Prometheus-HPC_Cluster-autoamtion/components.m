clc
clear all

file=fopen("components.out");

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

tekst=erase(tekst,'"');
tekst=strsplit(tekst);
jpg='_plot.jpg';

newchar=erase(tekst(1),'"');

for i=2:length(tekst)
    figure(i-1)
    plot(dane(:,1),dane(:,i),"k")
    title(tekst(i))
    xlabel("iteration")
    ylabel("downforce [N]")
    grid on
    name=char(append(tekst(i), jpg));
    saveas(figure(i-1), name)
end

opis=["Wielkoœæ 'Stosunek' okreœla stosnek odchylenia standardowego do si³y docisku uzyskanej w ostatniej iteracji. Wartoœæ zosta³a zwiêkszona 100-krotnie dla wiêkszej czytelnoœci"];
disp(opis)
odstep=["===============";"===============";"==============="];
disp(odstep)
for i=2:length(dane(1,:))
    disp(odstep)
    disp(tekst(i))
    Srednia=mean(dane([850,1000],i))
    Odchylenie=std(dane([850,1000],i))
    Stosunek=abs(Odchylenie/dane(end,i)*100)
end