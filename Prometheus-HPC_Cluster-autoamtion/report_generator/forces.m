function forces(df,drag,results)
    format='%20s %15s %15s \n';
    formatSpec='%20s %15.2f %15.2f \n';
    force(1,:)=results(1,df);
    force(2,:)=results(2,df);
    force(3,:)=results(2,drag);
    force=erase(force,"df-");
    suma(1)=sum(str2double(force(2,:)));
    suma(2)=sum(str2double(force(3,:)));
    fprintf(format,".","df",'drag')
    fprintf(formatSpec,force)
    fprintf('%20s %15.2f %15.2f \n',"SUMA",suma)
    fprintf("\v")
end