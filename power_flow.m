function [V0,i]=power_flow(itemax,tol,buses,linea)
    Ybus=ybus(linea);
    Y=abs(Ybus);
    [nY, ~] = size(Y);
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
    V0=buses(:,2);
    V0(:,2)=[0];
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
    
    
    for h=1:itemax
        %Calculo de las potencias dadas del problema
        for q=1:n
            k1=km1(q);
            P_given(q,:)=(buses(k1,4)-buses(k1,6))/100; %division entre 100 para que sea p.u.
        end
        for p=1:m
            k2=km2(p);
            Q_given(p,:)=(buses(k2,5)-buses(k2,7))/100;
        end
        %Potencias calculadas
        for i=1:n
            P_calculated(i,1)=0;
            for q=1:nY
                k1=km1(i);
                P_calculated(i,1)=P_calculated(i,1)+V0(k1,1)*V0(q,1)*(G(k1,q)*cos(V0(k1,2)-V0(q,2))+B(k1,q)*sin(V0(k1,2)-V0(q,2)));
            end
        end
        for i=1:m
            Q_calculated(i,1)=0;
            for p=1:nY
                k2=km2(i);
                Q_calculated(i,1)=Q_calculated(i,1)+V0(k2,1)*V0(p,1)*(G(k2,p)*sin(V0(k2,2)-V0(p,2))-B(k2,p)*cos(V0(k2,2)-V0(p,2)));
            end
        end
        delta_P=P_given-P_calculated;
        delta_Q=Q_given-Q_calculated;
        if max(delta_P)<tol
            if max(delta_Q)<tol
            break
            end
        end
        for i=1:n
            k1=km1(i);
            delta_P_diV(i,1)=delta_P(i,1)/V0(k1,1);
        end
        for i=1:m
            k2=km2(i);
            delta_Q_diV(i,1)=delta_Q(i,1)/V0(k1,1);
        end

        delta_ang=factorizacion_matriz(Bi,delta_P_diV);
        delta_V=factorizacion_matriz(Bii,delta_Q_diV);
        
        for i=1:m
            k1=km2(i);
            V0(k1,1)=V0(k1,1)+delta_V(i,1);
        end
        for i=1:n
            k2=km1(i);
            V0(k2,2)=V0(k2,2)+delta_ang(i,1);
        end
        
    end
    V0(:,2)=rad2deg(V0(:,2));
end