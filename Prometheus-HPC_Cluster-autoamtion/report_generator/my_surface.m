function fig=my_surface(m,rozmiar,fig)
    if (length(inputname(1))==length('s_floor_m_num')) & (inputname(1)=='s_floor_m_num')
         os_y=[" "];
         os_x=["endplate","out","c","in"];
         pointsx=[0:3];
         pointsy=1;
    elseif (length(inputname(1))==length('floor_m_num')) & (inputname(1)=='floor_m_num')
        os_y=[" "];
        os_x=["floor-1", "floor-2", "d-in", "d-out"];
        pointsx=[0:3];
        pointsy=1;
    elseif (length(inputname(1))==length('s_in_m_num')) & (inputname(1)=='s_in_m_num')
        os_y=["bot","c", "up"];
        os_x=["out", "in"];
        pointsx=[2:1:3];
        pointsy=[1:1:3];
    else
        os_y=["bot", "c", "up"];
        os_x=["out", "c", "in"];
        pointsx=[1.5:1:3.5];
        pointsy=[1.5:1:3.5];
        
    end
    figure(fig)
    colormap pink
    x=1:rozmiar(2)+1;
    y=1:rozmiar(1)+1;
    [meshx,meshy]=meshgrid(x,y); 
    m=reshape(m,rozmiar(1),rozmiar(2));
    m(:,rozmiar(2)+1)=m(:,rozmiar(2));
    m(rozmiar(1)+1,:)=m(rozmiar(1),:);
    s=surf(meshx,meshy,m,'FaceColor','flat','FaceAlpha',0.85);
    view(2)
    vector=[0 0 1];
    rotate(s,vector,-90)
    colorbar
    set(gca,'xtick',pointsx,'xticklabel',os_x)
    set(gca,'ytick',pointsy,'yticklabel',os_y)
    fig=fig+1;
end