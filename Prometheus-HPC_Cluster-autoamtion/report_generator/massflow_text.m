function rozmiar=massflow_text(m)
    if length(m)==4
        rozmiar=[4,1];
    elseif length(m)==6
        rozmiar=[2,3];
    elseif (length(m)==9)
        rozmiar=[3,3];
    end
%     rozmiar(1) %kolumny
%     rozmiar(2) %wiersze

    index=[1:rozmiar(1)];
    for i=1:rozmiar(2)
        fprintf('%-20s ', m(1,index))
        fprintf('\n')
        fprintf('%-20s ', m(2,index))
        fprintf('\n \n')
        index=index+ones(1,rozmiar(1))*rozmiar(1);
        i=i+1;
    end
end