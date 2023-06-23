function [Bi,Bii]=power_flow(itemax,tol,buses,linea)
    Ybus=ybus(linea);
    G=real(Ybus);
    B=imag(Ybus);
    ang=atan(B./G);
    [t1,t2,t3]=contar(buses);
    aux=double([linea(:,2) linea(:,3)]);
    [km1,km2]=vkm(aux,buses,Ybus);
    Bi=zeros(t2+t3);
    Bii=zeros(t3);
    n=length(km1);
    m=length(km2);
    %En los siguientes ciclos for se calculan las submatrices B' y B''
    for q=1:n
        k1=km1(q);
        for p=1:n
            m1=km1(p);
            Bi(q,p)=-B(k1,m1);
        end
    end
    for q=1:m
        k2=km2(q);
        for p=1:m
            m2=km2(p);
            Bii(q,p)=-B(k2,m2);
        end
    end
end