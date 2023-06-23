function Y=ybus(datos)
    a=size(datos);
    i=1;

    Yprim=zeros(a(1,1),a(1,1));
    while i<=a(1,1)
        Yprim(i,i)=datos(i,4);
        i=i+1;
    end
    i=1;
    Yprim=inv(Yprim);
    A=zeros(a(1,1),max(datos(:,3)));

    while i<=a(1,1)
            if(datos(i,2)==0)
                A(i,datos(i,3))=1;
            end
            if(datos(i,3)==0)
                A(i,datos(i,2))=-1;
            end
            if(datos(i,2)~=0)
                A(i,datos(i,2))=-1;
            end
            if(datos(i,3)~=0)
                A(i,datos(i,3))=1;
            end
        i=i+1;
    end
    Y=A'*Yprim*A;
end